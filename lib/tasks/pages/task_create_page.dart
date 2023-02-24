import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/mixins/date_formatter.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/task_create_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';

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
        navigationCubit.pageChanged(Pages.home);
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _TaskCreateForm(
          loginCubit: loginCubit,
          taskCreateCubit: taskCreateCubit,
          tasksCubit: tasksCubit,
          navigationCubit: navigationCubit,
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
    TextEditingController dateDueController = TextEditingController();
    return BlocBuilder<TaskCreateCubit, TaskCreateState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30.0),
            _nameField(),
            _descriptionField(),
            _dateDueField(context, dateDueController),
            const SizedBox(height: 30.0),
            _submitButton(),
          ],
        );
      },
    );
  }

  Widget _nameField() {
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

  Widget _descriptionField() {
    return TextField(
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

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !taskCreateCubit.formIsValid()
            ? null
            : () async {
                String authToken = loginCubit.state.user!.accessToken;
                if (await taskCreateCubit.createTask(authToken: authToken)) {
                  await tasksCubit.fetchTasksEnemyData(authToken: authToken);
                  navigationCubit.pageChanged(Pages.home);
                }
              },
        child: const Text('Create'),
      ),
    );
  }
}
