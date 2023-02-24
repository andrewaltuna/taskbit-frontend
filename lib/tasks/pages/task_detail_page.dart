import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/mixins/date_formatter.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';
import 'package:taskbit/widgets/custom_header.dart';

class TaskDetailPage extends StatelessWidget with DateFormatter {
  const TaskDetailPage({
    super.key,
  });

  static Page page() {
    return const MaterialPage<void>(child: TaskDetailPage());
  }

  // final Task task;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        final task = state.selectedTask;
        return WillPopScope(
          onWillPop: () async {
            context.read<NavigationCubit>().pageChanged(Pages.home);
            context.read<TasksCubit>().taskDeselected();
            return true;
          },
          child: task == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHeader('Task'),
                      Text(
                        task.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Text(task.description!.isEmpty
                          ? 'No description.'
                          : task.description!),
                      Text(
                        task.dateDue == null
                            ? 'No due date given.'
                            : 'Date Due: ${formatDate(task.dateDue!)}',
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
