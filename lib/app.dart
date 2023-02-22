import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/pages/login_page.dart';
import 'package:taskbit/auth/pages/profile_page.dart';
import 'package:taskbit/auth/pages/signup_page.dart';
import 'package:taskbit/constants.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/pages/home_page.dart';
import 'package:taskbit/tasks/pages/task_create_page.dart';
import 'package:taskbit/tasks/pages/task_detail_page.dart';
import 'package:taskbit/widgets/logo.dart';

class App extends StatelessWidget {
  const App({super.key});

  List<Page> onGeneratePages(TasksState state, List<Page> pages) {
    final selectedTask = state.selectedTask;
    final selectedPage = state.selectedPage;
    return [
      selectedPage < 0 ? LoginPage.page() : HomePage.page(tasks: state.tasks),
      if (selectedPage == -2) SignupPage.page(),
      if (selectedPage == 1) ProfilePage.page(),
      if (selectedPage == 3) TaskCreatePage.page(),
      if (selectedTask != null) TaskDetailPage.page(task: state.selectedTask!),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tasksCubit = context.read<TasksCubit>();
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(color: Color.fromRGBO(197, 84, 84, 1.0)),
      ),
      home: Scaffold(
        appBar: tasksCubit.state.selectedPage < 0 // selectedPage is LoginPage
            ? null
            : AppBar(
                title: const Logo(),
                elevation: 10.0,
                shadowColor: Colors.black,
              ),
        body: SafeArea(
          child: FlowBuilder(
              state: context.watch<TasksCubit>().state,
              onGeneratePages: onGeneratePages),
        ),
        bottomNavigationBar: tasksCubit.state.selectedPage < 0
            ? null
            : NavigationBar(
                onDestinationSelected: (int index) {
                  // if (index == 0)
                  tasksCubit.pageChanged(index);
                },
                selectedIndex: tasksCubit.state.selectedPage == 0 ||
                        tasksCubit.state.selectedPage == 1
                    ? tasksCubit.state.selectedPage
                    : 0,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
      ),
    );
  }
}
