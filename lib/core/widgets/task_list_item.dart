import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/mixins/date_formatter.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/task_cubit.dart';
import 'package:taskbit/core/cubit/user_data_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';

class TaskItem extends StatelessWidget with DateFormatter {
  const TaskItem({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Material(
        color: Colors.black.withOpacity(0.04),
        child: Container(
          constraints: const BoxConstraints(minHeight: 60.0),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => _TaskDetailDialog(task: task),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: task.isCompleted() ? 20.0 : 5.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!task.isCompleted()) _CompleteTaskButton(task: task),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.name,
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (task.dateDue != null)
                          Text(
                            'Due: ${formatDatePretty(task.dateDue)}',
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  task.dateCompleted == null
                      ? Row(
                          children: [
                            if (task.isLate()) const _LateTaskIndicator(),
                            _TaskActionsMenu(task: task),
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              formatDatePretty(task.dateCompleted!),
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12.0,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompleteTaskButton extends StatelessWidget {
  const _CompleteTaskButton({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.playlist_add_check_circle),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _ConfirmationDialog(task),
        );
      },
    );
  }
}

class _TaskActionsMenu extends StatelessWidget {
  const _TaskActionsMenu({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final taskCubit = BlocProvider.of<TaskCubit>(context);
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);
    return PopupMenuButton(
      onSelected: (value) async {
        if (value == Pages.taskUpdate) {
          taskCubit.copyDetails(task);
          navigationCubit.pageChanged(value);
          return;
        }
        // Delete was selected
        showDialog(
          context: context,
          builder: (context) => _ConfirmationDialog(task, isComplete: false),
        );
        return;
      },
      itemBuilder: (context) => <PopupMenuEntry>[
        const PopupMenuItem(value: Pages.taskUpdate, child: Text('Edit')),
        const PopupMenuItem(
          value: Pages.taskDelete,
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

class _TaskDetailDialog extends StatelessWidget with DateFormatter {
  const _TaskDetailDialog({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          task.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            task.description ?? "No description.",
            style: const TextStyle(fontSize: 16.0),
          ),
          const Divider(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                task.dateDue != null
                    ? 'Due: ${formatDatePretty(task.dateDue)}'
                    : "No due date.",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10.0),
              if (task.isLate() && !task.isCompleted())
                const _LateTaskIndicator(),
            ],
          ),
          if (task.isCompleted())
            Text(
              'Completed: ${formatDatePretty(task.dateCompleted)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

class _LateTaskIndicator extends StatelessWidget {
  const _LateTaskIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(50.0)),
      child: const Text(
        'LATE',
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog(this.task, {this.isComplete = true});

  final Task task;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    final taskCubit = BlocProvider.of<TaskCubit>(context);
    final userDataCubit = BlocProvider.of<UserDataCubit>(context);

    return AlertDialog(
      title: const Text('Confirmation'),
      content: Text(
          'Are you sure you want to ${isComplete ? 'complete' : 'delete'} this task? It cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Back'),
        ),
        TextButton(
          onPressed: () async {
            if (isComplete
                ? await taskCubit.taskCompleted(task)
                : await taskCubit.taskDeleted(task)) {
              userDataCubit.fetchUserData();
            }
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            isComplete ? 'Complete' : 'Delete',
            style: TextStyle(color: isComplete ? null : Colors.red),
          ),
        ),
      ],
    );
  }
}
