import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskbit/auth/pages/login_page.dart';
import 'package:taskbit/core/pages/profile_page.dart';
import 'package:taskbit/auth/pages/signup_page.dart';
import 'package:taskbit/constants.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/task_cubit.dart';
import 'package:taskbit/core/pages/home_page.dart';
import 'package:taskbit/tasks/pages/task_create_page.dart';
import 'package:taskbit/widgets/logo.dart';

class App extends StatelessWidget {
  const App({super.key});

  List<Page> onGeneratePages(NavigationState state, List<Page> pages) {
    final selectedPage = state.selectedPage;
    return [
      state.pageIsAuth()
          ? LoginPage.page()
          : state.navIndex == 0
              ? HomePage.page()
              : ProfilePage.page(),
      if (selectedPage == Pages.signUp) SignupPage.page(),
      if (selectedPage == Pages.taskCreate || selectedPage == Pages.taskUpdate)
        TaskCreatePage.page(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final navigationCubit = context.read<NavigationCubit>();
    final taskCubit = context.read<TaskCubit>();
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(color: Color.fromRGBO(197, 84, 84, 1)),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: navigationCubit.state.pageIsAuth()
            ? null
            : AppBar(
                title: const Logo(),
                elevation: 10,
                shadowColor: Colors.black,
              ),
        body: SafeArea(
          child: FlowBuilder(
              state: context.watch<NavigationCubit>().state,
              onGeneratePages: onGeneratePages),
        ),
        bottomNavigationBar: navigationCubit.state.pageIsAuth()
            ? null
            : BottomNavigationBar(
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (int index) {
                  navigationCubit.navChanged(index);
                  taskCubit.resetState();
                },
                currentIndex: navigationCubit.state.navIndex,
                items: const [
                  BottomNavigationBarItem(
                      label: 'Home', icon: Icon(Icons.home)),
                  BottomNavigationBarItem(
                      label: 'Profile', icon: Icon(Icons.person)),
                ],
              ),
      ),
    );
  }
}
