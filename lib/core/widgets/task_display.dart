import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/core/cubit/user_data_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';
import 'package:taskbit/core/widgets/task_list.dart';

class TaskDisplay extends StatelessWidget {
  const TaskDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final userDataCubit = BlocProvider.of<UserDataCubit>(context);
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        List<Task> ongoingTasks = userDataCubit.state.ongoingTasks;
        List<Task> completedTasks = userDataCubit.state.completedTasks;
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
                      emptyText:
                          'You have no ongoing tasks.\nHooray! =(^._.^)=',
                    ),
                    TaskList(
                      tabIndex: 1,
                      tasks: completedTasks,
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
