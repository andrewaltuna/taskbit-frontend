import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';
import 'package:taskbit/tasks/widgets/task_list.dart';

class TaskDisplay extends StatelessWidget {
  const TaskDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    TasksCubit tasksCubit = context.read<TasksCubit>();
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        List<Task> ongoingTasks = tasksCubit.state.ongoingTasks();
        List<Task> completedTasks = tasksCubit.state.completedTasks();
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
                    TaskList(
                      tabIndex: 0,
                      tasks: ongoingTasks,
                      condition: ongoingTasks.isEmpty,
                      emptyText:
                          'You have no ongoing tasks.\nHooray! =(^._.^)=',
                    ),
                    TaskList(
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
