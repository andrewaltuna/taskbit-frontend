import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/mixins/date_formatter.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/task_cubit.dart';
import 'package:taskbit/core/cubit/user_data_cubit.dart';

class TaskCreateForm extends StatefulWidget {
  const TaskCreateForm({super.key});

  @override
  State<TaskCreateForm> createState() => _TaskCreateFormState();
}

class _TaskCreateFormState extends State<TaskCreateForm> with DateFormatter {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController dateDueController;

  @override
  void initState() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    dateDueController = TextEditingController();

    final state = BlocProvider.of<TaskCubit>(context).state;
    if (!state.isCreate) {
      nameController.text = state.name;
      descriptionController.text = state.description ?? '';
      dateDueController.text = formatDate(state.dateDue);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30.0),
        _NameField(controller: nameController),
        _DescriptionField(controller: descriptionController),
        _DateDueField(controller: dateDueController),
        const SizedBox(height: 30.0),
        const _SubmitButton(),
      ],
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final taskCubit = BlocProvider.of<TaskCubit>(context);
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return TextField(
          controller: controller,
          onChanged: taskCubit.nameChanged,
          decoration: InputDecoration(
            label: const Text('Name'),
            errorText: taskCubit.state.nameInputStatus == InputStatus.invalid
                ? 'Invalid name'
                : null,
          ),
        );
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final taskCubit = BlocProvider.of<TaskCubit>(context);
    return TextField(
      controller: controller,
      onChanged: taskCubit.descriptionChanged,
      decoration: const InputDecoration(
        label: Text('Description'),
      ),
    );
  }
}

class _DateDueField extends StatelessWidget with DateFormatter {
  const _DateDueField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final taskCubit = BlocProvider.of<TaskCubit>(context);

    return TextField(
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: taskCubit.state.dateDue ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
        );

        if (date != null) {
          taskCubit.dateDueChanged(date);
          controller.text = formatDate(date);
        }
      },
      controller: controller,
      readOnly: true,
      decoration: const InputDecoration(
        label: Text('Date Due'),
        suffixIcon: Icon(Icons.calendar_month),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);
    final userDataCubit = BlocProvider.of<UserDataCubit>(context);
    final taskCubit = BlocProvider.of<TaskCubit>(context);

    final isCreate = taskCubit.state.isCreate;

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: !taskCubit.state.formIsValid
                ? null
                : () async {
                    if (isCreate
                        ? await taskCubit.createTask()
                        : await taskCubit.updateTask()) {
                      await userDataCubit.fetchUserData();
                      navigationCubit.pageChanged(Pages.home);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Task successfully ${isCreate ? 'created' : 'updated'}!'),
                          ),
                        );
                      }
                    }
                  },
            child: Text(isCreate ? 'Create' : 'Update'),
          ),
        );
      },
    );
  }
}
