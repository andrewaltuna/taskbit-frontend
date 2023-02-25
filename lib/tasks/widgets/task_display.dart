import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/mixins/date_formatter.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/task_create_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';

class TaskDisplay extends StatelessWidget {
  const TaskDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    TasksCubit tasksCubit = context.read<TasksCubit>();
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        List<Task> ongoingTasks = tasksCubit.ongoingTasks();
        List<Task> completedTasks = tasksCubit.completedTasks();
        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Ongoing'),
                  Tab(text: 'Completed'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _TaskList(
                      tabIndex: 0,
                      tasks: ongoingTasks,
                      condition: ongoingTasks.isEmpty,
                      emptyText:
                          'You have no ongoing tasks.\nHooray! =(^._.^)=',
                    ),
                    _TaskList(
                      tabIndex: 1,
                      tasks: completedTasks,
                      condition: completedTasks.isEmpty,
                      emptyText: 'Get to work!',
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tabIndex,
    required this.tasks,
    required this.emptyText,
    required this.condition,
  });

  final int tabIndex;
  final List<Task> tasks;
  final String emptyText;
  final bool condition;

  @override
  Widget build(BuildContext context) {
    return condition
        ? Center(
            child: Text(
              emptyText,
              textAlign: TextAlign.center,
            ),
          )
        : RefreshIndicator(
            onRefresh: refreshList(context),
            child: Scrollbar(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: tabIndex == 0 ? 10.0 : 20.0,
                      ),
                      child: tabIndex == 0
                          ? const SizedBox.shrink()
                          : const Text(
                              'Most Recent (Up to 10)',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                    );
                  }
                  final Task task = tasks[index - 1];
                  // if (index == 1) {
                  //   return Padding(
                  //     padding: const EdgeInsets.only(top: 20.0),
                  //     child: _TaskItem(task: task),
                  //   );
                  // }

                  if (index == tasks.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _TaskItem(task: task),
                    );
                  }
                  return _TaskItem(task: task);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 10.0),
                itemCount: tasks.length + 1,
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
          );
  }

  Future<void> Function() refreshList(BuildContext context) {
    return () {
      return Future.delayed(
        const Duration(seconds: 1),
        () {
          final String authToken =
              context.read<LoginCubit>().state.user!.accessToken;
          context.read<TasksCubit>().fetchTasksEnemyData(authToken: authToken);
        },
      );
    };
  }
}

class _TaskItem extends StatelessWidget with DateFormatter {
  const _TaskItem({required this.task});

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
                builder: (context) => _taskDetail(task),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: task.isCompleted() ? 20.0 : 5.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!task.isCompleted()) _completeButton(context),
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
                            if (task.isLate()) _lateTaskIndicator(),
                            _popupMenuButton(context),
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

  Widget _lateTaskIndicator() {
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

  AlertDialog _taskDetail(Task task) {
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
              if (task.isLate() && !task.isCompleted()) _lateTaskIndicator(),
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

  Widget _popupMenuButton(BuildContext context) {
    final tasksCubit = context.read<TasksCubit>();
    final taskCreateCubit = context.read<TaskCreateCubit>();
    final navigationCubit = context.read<NavigationCubit>();
    final authToken = context.read<LoginCubit>().state.user!.accessToken;
    return PopupMenuButton(
      onSelected: (value) async {
        if (value == Pages.taskUpdate) {
          taskCreateCubit.copyDetails(task);
          navigationCubit.pageChanged(value);
          return;
        }
        await tasksCubit.taskDeleted(authToken: authToken, task: task);
        tasksCubit.fetchTasksEnemyData(authToken: authToken);
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

  Widget _completeButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.playlist_add_check_circle),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => completeTaskDialog(context),
        );
      },
    );
  }

  AlertDialog completeTaskDialog(BuildContext context) {
    final tasksCubit = context.read<TasksCubit>();
    final authToken = context.read<LoginCubit>().state.user!.accessToken;

    return AlertDialog(
      title: const Text('Confirmation'),
      content: const Text(
          'Are you sure you want to complete this task? It cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Back'),
        ),
        TextButton(
          onPressed: () async {
            if (await tasksCubit.taskCompleted(
              authToken: authToken,
              task: task,
            )) {
              tasksCubit.fetchTasksEnemyData(authToken: authToken);
            }
            if (context.mounted) {}
            Navigator.of(context).pop();
          },
          child: const Text('Complete'),
        ),
      ],
    );
  }
}
