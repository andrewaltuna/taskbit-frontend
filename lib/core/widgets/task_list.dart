import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/core/cubit/user_data_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';
import 'package:taskbit/core/widgets/task_list_item.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.tabIndex,
    required this.tasks,
    required this.emptyText,
  });

  final int tabIndex;
  final List<Task> tasks;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final userDataCubit = BlocProvider.of<UserDataCubit>(context);
    return tasks.isEmpty
        ? Center(
            child: Text(
              emptyText,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withOpacity(0.5)),
            ),
          )
        : RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(
                const Duration(seconds: 1),
                () {
                  userDataCubit.fetchUserData();
                },
              );
            },
            child: Scrollbar(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Padding(
                      padding:
                          EdgeInsets.only(top: tabIndex == 0 ? 10.0 : 20.0),
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

                  if (index == tasks.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TaskItem(task: task),
                    );
                  }
                  return TaskItem(task: task);
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 10.0),
                itemCount: tasks.length + 1,
                physics: const AlwaysScrollableScrollPhysics(),
              ),
            ),
          );
  }
}
