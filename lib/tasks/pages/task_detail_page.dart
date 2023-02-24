import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/mixins/date_formatter.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';

class TaskDetailPage extends StatelessWidget with DateFormatter {
  const TaskDetailPage({
    super.key,
    // required this.task,
  });

  static Page page() {
    return MaterialPage<void>(
        child: TaskDetailPage(
            // task: task,
            ));
  }

  // final Task task;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        Task task = state.selectedTask!;
        return WillPopScope(
          onWillPop: () async {
            context.read<TasksCubit>().taskDeselected();
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Task',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(task.name),
                Text(task.description ?? 'No description.'),
                // Text(task.dateCreated),
                Text(
                  task.dateDue == null
                      ? 'No due date given.'
                      : formatDate(task.dateDue!),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
