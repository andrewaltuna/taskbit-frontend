import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/mixins/date_formatter.dart';
import 'package:taskbit/tasks/cubit/task_create_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';

class TaskCreatePage extends StatelessWidget with DateFormatter {
  const TaskCreatePage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: TaskCreatePage());
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController dateDueController = TextEditingController();
    TaskCreateCubit taskCreateCubit = context.read<TaskCreateCubit>();
    TasksCubit tasksCubit = context.read<TasksCubit>();
    return BlocBuilder<TaskCreateCubit, TaskCreateState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            taskCreateCubit.resetState();
            tasksCubit.pageChanged(Pages.home);
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30.0),
                _nameField(taskCreateCubit),
                _descriptionField(taskCreateCubit),
                _dateDueField(context, taskCreateCubit, dateDueController),
                const SizedBox(height: 30.0),
                _submitButton(taskCreateCubit, tasksCubit),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _nameField(TaskCreateCubit taskCreateCubit) {
    return TextField(
      onChanged: taskCreateCubit.nameChanged,
      decoration: InputDecoration(
        label: const Text('Name'),
        errorText: taskCreateCubit.state.nameInputStatus == InputStatus.invalid
            ? 'Invalid name'
            : null,
      ),
    );
  }

  Widget _descriptionField(TaskCreateCubit taskCreateCubit) {
    return TextField(
      onChanged: taskCreateCubit.descriptionChanged,
      decoration: const InputDecoration(
        label: Text('Description'),
      ),
    );
  }

  Widget _dateDueField(BuildContext context, TaskCreateCubit taskCreateCubit,
      TextEditingController controller) {
    return TextField(
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: taskCreateCubit.state.dateDue ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 5),
        );

        if (date != null) {
          taskCreateCubit.dateDueChanged(date);
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

  Widget _submitButton(TaskCreateCubit taskCreateCubit, TasksCubit tasksCubit) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !taskCreateCubit.formIsValid()
            ? null
            : () {
                taskCreateCubit.resetState();
                tasksCubit.pageChanged(Pages.home);
              },
        child: const Text('Create'),
      ),
    );
  }
}
