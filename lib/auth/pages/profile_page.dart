import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return WillPopScope(
      onWillPop: () async {
        tasksCubit.pageChanged(0);
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
                    tasksCubit.logout();
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
                  _playerAvatar(),
                  // Player stats
                  Expanded(
                    child: _playerStats(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _playerAvatar() {
    return Container(
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/profile_background.png'),
        ),
      ),
      child: const Sprite('avatars/knight', height: 70),
    );
  }

  Widget _playerStats() {
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
        child: _cardText(),
      ),
    );
  }

  Widget _cardText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Player 1',
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
