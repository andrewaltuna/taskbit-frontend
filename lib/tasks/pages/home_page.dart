import 'package:flutter/material.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/task.dart';
import 'package:taskbit/widgets/battle_display.dart';
import 'package:taskbit/widgets/task_display.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.tasks});

  static Page page({required List<Task> tasks}) {
    return MaterialPage<void>(child: HomePage(tasks: tasks));
  }

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BattleDisplay(),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tasksHeader(),
                    _createButton(context),
                  ],
                ),
              ),
              const Expanded(
                child: TaskDisplay(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _tasksHeader() {
    return const Text(
      'Tasks',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _createButton(BuildContext context) {
    return SizedBox(
      height: 25.0,
      child: ElevatedButton(
        onPressed: () {
          context.read<TasksCubit>().pageChanged(3);
        },
        child: const Text(
          'Create +',
          style: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }
}
