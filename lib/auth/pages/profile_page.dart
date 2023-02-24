import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/auth/models/user.dart';
import 'package:taskbit/navigation/cubit/navigation_cubit.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Text('Profile', style: GoogleFonts.pressStart2p()),
              const SizedBox(height: 10.0),
              const _PlayerCard(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    loginCubit.resetState();
                    tasksCubit.resetState();
                    navigationCubit.pageChanged(Pages.login);
                  },
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard();

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = context.read<LoginCubit>();
    User user = loginCubit.state.user!;
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
                  _playerAvatar(user.avatar),
                  // Player stats
                  Expanded(
                    child: _playerStats(user.username),
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
    return Container(
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

  Widget _playerStats(String username) {
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
        child: _cardText(username),
      ),
    );
  }

  Widget _cardText(String username) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: GoogleFonts.pressStart2p(color: Colors.white),
        ),
        const Divider(thickness: 3.0),
        const Text(
          'Bosses Slain:',
          style: TextStyle(color: Colors.white),
        ),
        const Text(
          'Enemies Slain:',
          style: TextStyle(color: Colors.white),
        ),
        const Text(
          'Tasks Completed:',
          style: TextStyle(color: Colors.white),
        ),
        const Text(
          'Stages Completed:',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
