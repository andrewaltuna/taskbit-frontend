import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/mixins/date_formatter.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/task_create_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/widgets/custom_header.dart';

class TaskCreatePage extends StatelessWidget {
  const TaskCreatePage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: TaskCreatePage());
  }

  @override
  Widget build(BuildContext context) {
    TaskCreateCubit taskCreateCubit = context.read<TaskCreateCubit>();
    TasksCubit tasksCubit = context.read<TasksCubit>();
    LoginCubit loginCubit = context.read<LoginCubit>();
    NavigationCubit navigationCubit = context.read<NavigationCubit>();
    return WillPopScope(
      onWillPop: () async {
        taskCreateCubit.resetState();
        navigationCubit.pageDeselected();
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomHeader(
                '${taskCreateCubit.state.isCreate() ? 'Create' : 'Update'} a Task'),
            _TaskCreateForm(
              loginCubit: loginCubit,
              taskCreateCubit: taskCreateCubit,
              tasksCubit: tasksCubit,
              navigationCubit: navigationCubit,
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskCreateForm extends StatelessWidget with DateFormatter {
  const _TaskCreateForm({
    required this.loginCubit,
    required this.taskCreateCubit,
    required this.tasksCubit,
    required this.navigationCubit,
  });

  final LoginCubit loginCubit;
  final TaskCreateCubit taskCreateCubit;
  final TasksCubit tasksCubit;
  final NavigationCubit navigationCubit;

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateDueController = TextEditingController();

    return BlocBuilder<TaskCreateCubit, TaskCreateState>(
      builder: (context, state) {
        if (!state.isCreate()) {
          nameController.text = state.name;
          descriptionController.text = state.description ?? '';
          dateDueController.text = formatDate(state.dateDue);
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            _nameField(nameController),
            _descriptionField(descriptionController),
            _dateDueField(context, dateDueController),
            const SizedBox(height: 30.0),
            _submitButton(context),
          ],
        );
      },
    );
  }

  Widget _nameField(TextEditingController controller) {
    return TextField(
      controller: controller,
      onChanged: taskCreateCubit.nameChanged,
      decoration: InputDecoration(
        label: const Text('Name'),
        errorText: taskCreateCubit.state.nameInputStatus == InputStatus.invalid
            ? 'Invalid name'
            : null,
      ),
    );
  }

  Widget _descriptionField(TextEditingController controller) {
    return TextField(
      controller: controller,
      onChanged: taskCreateCubit.descriptionChanged,
      decoration: const InputDecoration(
        label: Text('Description'),
      ),
    );
  }

  Widget _dateDueField(BuildContext context, TextEditingController controller) {
    return TextField(
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: taskCreateCubit.state.dateDue ?? DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 5),
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

  Widget _submitButton(BuildContext context) {
    final isCreate = taskCreateCubit.state.isCreate();
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !taskCreateCubit.state.formIsValid()
            ? null
            : () => _submitFunction(context, isCreate),
        child: Text(isCreate ? 'Create' : 'Update'),
      ),
    );
  }

  void _submitFunction(BuildContext context, bool isCreate) async {
    String authToken = loginCubit.state.user!.accessToken;
    if (isCreate
        ? await taskCreateCubit.createTask(authToken: authToken)
        : await taskCreateCubit.updateTask(authToken: authToken)) {
      await tasksCubit.fetchTasksEnemyData(authToken: authToken);
      navigationCubit.pageChanged(Pages.home);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Task successfully ${isCreate ? 'created' : 'updated'}!'),
          ),
        );
      }
    }
  }
}
