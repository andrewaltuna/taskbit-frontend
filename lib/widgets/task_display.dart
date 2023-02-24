import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/mixins/date_formatter.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/task_create_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';

class TaskDisplay extends StatelessWidget {
  const TaskDisplay({
    super.key,
  });

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
                      tasks: ongoingTasks,
                      condition: ongoingTasks.isEmpty,
                      emptyText:
                          'You have no ongoing tasks.\nHooray! =(^._.^)=',
                    ),
                    _TaskList(
                      tasks: completedTasks,
                      emptyText: 'Get to work!',
                      condition: completedTasks.isEmpty,
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
    required this.tasks,
    required this.emptyText,
    required this.condition,
  });

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
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemBuilder: (BuildContext context, int index) {
                final Task task = tasks[index];
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: _TaskItem(task: task),
                  );
                }

                if (index == tasks.length - 1) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: _TaskItem(task: task),
                  );
                }
                return _TaskItem(task: task);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 10.0),
              itemCount: tasks.length,
              physics: const AlwaysScrollableScrollPhysics(),
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
        child: AnimatedContainer(
          constraints: const BoxConstraints(minHeight: 60.0),
          duration: const Duration(milliseconds: 200),
          color: Colors.black.withOpacity(0.04),
          child: InkWell(
            onTap: () {
              context.read<NavigationCubit>().pageChanged(Pages.taskDetail);
              context.read<TasksCubit>().taskSelected(task);
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.name,
                    // style: TextStyle(),
                  ),
                  task.dateCompleted == null
                      ? Row(
                          children: [
                            _completeButton(context),
                            _popupMenuButton(context),
                          ],
                        )
                      : Text(formatDate(task.dateCompleted!)),
                ],
              ),
            ),
          ),
        ),
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
        const PopupMenuItem(value: Pages.taskUpdate, child: Text('Update')),
        const PopupMenuItem(value: Pages.taskDelete, child: Text('Delete')),
      ],
    );
  }

  Widget _completeButton(BuildContext context) {
    final tasksCubit = context.read<TasksCubit>();
    final authToken = context.read<LoginCubit>().state.user!.accessToken;
    return IconButton(
      icon: const Icon(Icons.check),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
          ),
        );
      },
    );
  }
}
