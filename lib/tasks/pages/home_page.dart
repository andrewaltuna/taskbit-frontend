import 'package:flutter/material.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/widgets/battle_display.dart';
import 'package:taskbit/widgets/custom_header.dart';
import 'package:taskbit/widgets/task_display.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    // required this.tasks,
  });

  static Page page() {
    return const MaterialPage<void>(child: HomePage());
  }

  // final List<Task> tasks;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    TasksCubit tasksCubit = context.read<TasksCubit>();
    String authToken = context.read<LoginCubit>().state.user!.accessToken;

    Future.delayed(
      const Duration(seconds: 1),
      () => tasksCubit.fetchTasksEnemyData(authToken: authToken),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: state.stage == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    const BattleDisplay(),
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CustomHeader('Tasks'),
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
                ),
        );
      },
    );
  }

  Widget _createButton(BuildContext context) {
    return SizedBox(
      height: 25.0,
      child: ElevatedButton(
        onPressed: () {
          context.read<NavigationCubit>().pageChanged(Pages.taskCreate);
        },
        child: Row(
          children: const [
            Text(
              'ADD',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 3.0),
            Icon(
              Icons.add_circle,
              size: 15.0,
            )
          ],
        ),
      ),
    );
  }
}
