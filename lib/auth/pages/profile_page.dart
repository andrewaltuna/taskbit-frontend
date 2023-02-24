import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/auth/models/user.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/stats.dart';
import 'package:taskbit/widgets/custom_header.dart';
import 'package:taskbit/widgets/sprite.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    TasksCubit tasksCubit = context.read<TasksCubit>();
    NavigationCubit navigationCubit = context.read<NavigationCubit>();
    LoginCubit loginCubit = context.read<LoginCubit>();

    return WillPopScope(
      onWillPop: () async {
        navigationCubit.pageChanged(Pages.home);
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 20.0),
            const CustomHeader('Profile'),
            const SizedBox(height: 10.0),
            const _PlayerCard(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 211, 76, 66),
                    ),
                    onPressed: () {
                      loginCubit.resetState();
                      tasksCubit.resetState();
                      navigationCubit.pageChanged(Pages.login);
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard();

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    final user = loginCubit.state.user!;
    final tasksCubit = context.read<TasksCubit>();
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Player avatar
                  Material(
                    child: InkWell(
                      onTap: () {},
                      child: _playerAvatar(user.avatar),
                    ),
                  ),
                  // Player stats
                  Expanded(
                    child: _playerStats(
                      user.username,
                      tasksCubit.state.stats!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _playerAvatar(String sprite) {
    return Ink(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/profile_background.png'),
        ),
      ),
      child: Sprite('avatars/$sprite', height: 70),
    );
  }

  Widget _playerStats(String username, Stats stats) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Colors.grey,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/stats_background.png'),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.black.withOpacity(0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: GoogleFonts.pressStart2p(color: Colors.white),
            ),
            const Divider(thickness: 3.0),
            Text(
              'Bosses Slain: ${stats.bossesSlain}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Enemies Slain: ${stats.enemiesSlain}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Tasks Completed: ${stats.tasksCompleted}',
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              'Stages Completed: ${stats.stagesCompleted}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
