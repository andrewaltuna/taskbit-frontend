import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/core/widgets/page_loading_indicator.dart';
import 'package:taskbit/cubit/avatar_select_cubit.dart';
import 'package:taskbit/cubit/navigation_cubit.dart';
import 'package:taskbit/core/cubit/user_data_cubit.dart';
import 'package:taskbit/core/models/stats.dart';
import 'package:taskbit/widgets/avatar_select.dart';
import 'package:taskbit/widgets/custom_header.dart';
import 'package:taskbit/widgets/sprite.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Page page() {
    return const MaterialPage<void>(child: ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, userDataState) {
        return BlocBuilder<AvatarSelectCubit, AvatarSelectState>(
          builder: (context, avatarSelectState) {
            return userDataState.isLoaded
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(height: 20.0),
                        const CustomHeader('Profile'),
                        const SizedBox(height: 10.0),
                        const _PlayerCard(),
                        const SizedBox(height: 10.0),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          child: avatarSelectState.isProfileAvatarSelectVisible
                              ? const _UpdateAvatarWidget()
                              : const SizedBox.shrink(),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: _LogoutButton(),
                          ),
                        ),
                      ],
                    ),
                  )
                : const PageLoadingIndicator();
          },
        );
      },
    );
  }
}

class _UpdateAvatarWidget extends StatelessWidget {
  const _UpdateAvatarWidget();

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    final userDataCubit = BlocProvider.of<UserDataCubit>(context);
    final avatarSelectCubit = BlocProvider.of<AvatarSelectCubit>(context);

    final userAvatar = loginCubit.state.user!.avatar;

    return BlocBuilder<AvatarSelectCubit, AvatarSelectState>(
      builder: (context, state) {
        return Column(
          children: [
            const AvatarSelect(),
            const SizedBox(height: 10.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: userAvatar == state.selectedAvatar
                    ? null
                    : () async {
                        userDataCubit.updateAvatar();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Avatar successfully updated!'),
                            ),
                          );
                        }
                        avatarSelectCubit.toggleProfileAvatarSelectVisibility();
                      },
                child: const Text('Update Avatar'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();
  @override
  Widget build(BuildContext context) {
    final userDataCubit = BlocProvider.of<UserDataCubit>(context);
    final navigationCubit = BlocProvider.of<NavigationCubit>(context);
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    final avatarSelectCubit = BlocProvider.of<AvatarSelectCubit>(context);

    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: () {
          loginCubit.resetState();
          userDataCubit.resetState();
          navigationCubit.resetState();
          avatarSelectCubit.resetState();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 211, 76, 66),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard();
  @override
  Widget build(BuildContext context) {
    final userDataCubit = BlocProvider.of<UserDataCubit>(context);
    final avatarSelectCubit = BlocProvider.of<AvatarSelectCubit>(context);

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final user = state.user!;
        final avatarIndex =
            avatarSelectCubit.state.avatars.indexOf(user.avatar);
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
                          onTap: () {
                            // Update signupCubit to have user avatar pre-selected
                            avatarSelectCubit.avatarSelected(avatarIndex);
                            avatarSelectCubit
                                .toggleProfileAvatarSelectVisibility();
                          },
                          child: _playerAvatar(user.avatar),
                        ),
                      ),
                      // Player stats
                      Expanded(
                        child: _playerStats(
                          user.username,
                          userDataCubit.state.stats!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
            _statText('Bosses Slain: ${stats.bossesSlain}'),
            _statText('Enemies Slain: ${stats.enemiesSlain}'),
            _statText('Tasks Completed: ${stats.tasksCompleted}'),
            _statText('Stages Completed: ${stats.stagesCompleted}'),
          ],
        ),
      ),
    );
  }

  Widget _statText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white),
    );
  }
}
