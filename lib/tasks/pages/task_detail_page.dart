import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key, required this.task});

  static Page page({required Task task}) {
    return MaterialPage<void>(child: TaskDetailPage(task: task));
  }

  final Task task;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<TasksCubit>().taskDeselected();
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(task.name),
            Text(task.description ?? 'No description.'),
            Text(task.dateCreated),
            Text(task.dateDue ?? 'No due date.'),
          ],
        ),
      ),
    );
  }
}
