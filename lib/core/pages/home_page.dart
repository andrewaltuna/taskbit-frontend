import 'package:flutter/material.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/core/widgets/page_loading_indicator.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/core/cubit/user_data_cubit.dart';
import 'package:taskbit/core/widgets/battle_display.dart';
import 'package:taskbit/widgets/custom_header.dart';
import 'package:taskbit/core/widgets/task_display.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserDataCubit userDataCubit;
  late LoginCubit loginCubit;
  late NavigationCubit navigationCubit;

  @override
  void initState() {
    userDataCubit = context.read<UserDataCubit>();
    navigationCubit = context.read<NavigationCubit>();
    loginCubit = context.read<LoginCubit>();

    final user = loginCubit.state.user;

    if (user != null) {
      Future.delayed(
        const Duration(seconds: 1),
        () => userDataCubit.fetchUserData(),
      );
    } else {
      navigationCubit.resetState();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: state.isLoaded
              ? Column(
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
                              children: const [
                                CustomHeader('Tasks'),
                                _CreateTaskButton(),
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
                )
              : const PageLoadingIndicator(),
        );
      },
    );
  }
}

class _CreateTaskButton extends StatelessWidget {
  const _CreateTaskButton();

  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);
    return SizedBox(
      height: 25.0,
      child: ElevatedButton(
        onPressed: () {
          navigationCubit.pageChanged(Pages.taskCreate);
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
