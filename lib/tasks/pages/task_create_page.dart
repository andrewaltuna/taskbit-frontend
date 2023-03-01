import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/task_cubit.dart';
import 'package:taskbit/tasks/widgets/task_create_form.dart';
import 'package:taskbit/widgets/custom_header.dart';

class TaskCreatePage extends StatelessWidget {
  const TaskCreatePage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: TaskCreatePage());
  }

  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);
    final taskCubit = BlocProvider.of<TaskCubit>(context);
    return WillPopScope(
      onWillPop: () async {
        taskCubit.resetState();
        navigationCubit.pageDeselected();
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomHeader(
                '${taskCubit.state.isCreate ? 'Create' : 'Update'} a Task'),
            const TaskCreateForm(),
          ],
        ),
      ),
    );
  }
}
