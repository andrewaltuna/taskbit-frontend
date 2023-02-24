import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/pages/login_page.dart';
import 'package:taskbit/auth/pages/profile_page.dart';
import 'package:taskbit/auth/pages/signup_page.dart';
import 'package:taskbit/constants.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/pages/home_page.dart';
import 'package:taskbit/tasks/pages/task_create_page.dart';
import 'package:taskbit/tasks/pages/task_detail_page.dart';
import 'package:taskbit/widgets/logo.dart';

class App extends StatelessWidget {
  const App({super.key});

  List<Page> onGeneratePages(NavigationState state, List<Page> pages) {
    // final selectedTask = state.selectedTask;
    final selectedPage = state.selectedPage;
    return [
      selectedPage == Pages.login || selectedPage == Pages.signUp
          ? LoginPage.page()
          : HomePage.page(),
      if (selectedPage == Pages.signUp) SignupPage.page(),
      if (selectedPage == Pages.profile) ProfilePage.page(),
      if (selectedPage == Pages.taskCreate || selectedPage == Pages.taskUpdate)
        TaskCreatePage.page(),
      if (selectedPage == Pages.taskDetail) TaskDetailPage.page(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final navigationCubit = context.read<NavigationCubit>();
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(color: Color.fromRGBO(197, 84, 84, 1.0)),
      ),
      home: Scaffold(
        appBar: navigationCubit.pageIsAuth() // selectedPage is LoginPage
            ? null
            : AppBar(
                title: const Logo(),
                elevation: 10.0,
                shadowColor: Colors.black,
              ),
        body: SafeArea(
          child: FlowBuilder(
              state: context.watch<NavigationCubit>().state,
              onGeneratePages: onGeneratePages),
        ),
        bottomNavigationBar: navigationCubit.pageIsAuth()
            ? null
            : NavigationBar(
                onDestinationSelected: (int index) {
                  Pages page;
                  if (index == 0) {
                    page = Pages.home;
                  } else {
                    page = Pages.profile;
                  }
                  navigationCubit.pageChanged(page);
                },
                selectedIndex: navigationCubit
                    .getPageNavIndex(navigationCubit.state.selectedPage),
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
