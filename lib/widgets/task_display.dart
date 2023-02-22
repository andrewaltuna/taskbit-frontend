import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';

class TaskDisplay extends StatelessWidget {
  const TaskDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        List<Task> ongoingTasks = context.read<TasksCubit>().ongoingTasks();
        List<Task> completedTasks = context.read<TasksCubit>().completedTasks();
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
        : ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemBuilder: (BuildContext context, int index) {
              final Task task = tasks[index];
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _TaskItem(task: task),
                );
              }
              return _TaskItem(task: task);
            },
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 10.0),
            itemCount: tasks.length,
          );
  }
}

class _TaskItem extends StatelessWidget {
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
              context.read<TasksCubit>().taskSelected(task);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 15.0, right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.name,
                    // style: TextStyle(),
                  ),
                  if (task.dateCompleted == null) _completeButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _completeButton(BuildContext context) {
    final TasksCubit tasksCubit = context.read<TasksCubit>();
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
                onPressed: () {
                  tasksCubit.taskCompleted(task);
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
