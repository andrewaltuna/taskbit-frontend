import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/core/cubit/user_data_cubit.dart';
import 'package:taskbit/widgets/custom_subheader.dart';
import 'package:taskbit/widgets/sprite.dart';

class BattleDisplay extends StatelessWidget {
  const BattleDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        final stage = state.stage!;
        return Column(
          children: [
            Container(
              height: 175.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/stage-backdrop.png'),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomSubheader('Stage ${stage.stage}-${stage.substage}'),
                    if (stage.substage == 4) _bossIndicator(),
                    const _Sprites(),
                  ],
                ),
              ),
            ),
            const _EnemyHealthBar(),
          ],
        );
      },
    );
  }

  Widget _bossIndicator() {
    return Text(
      'BOSS',
      style: GoogleFonts.pressStart2p(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 25.0,
        shadows: [
          const Shadow(color: Colors.black, offset: Offset(2.0, 2.0)),
        ],
      ),
    );
  }
}

class _Sprites extends StatelessWidget {
  const _Sprites();

  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // player sprite
            Expanded(
              child: AnimatedAlign(
                alignment: state.enemyIsVisible
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                duration: const Duration(milliseconds: 500),
                child: Sprite(
                  'avatars/${loginCubit.state.user!.avatar}',
                  height: 70,
                ),
              ),
            ),
            // enemy sprite
            AnimatedOpacity(
              opacity: state.enemyIsVisible ? 1 : 0,
              duration: const Duration(milliseconds: 100),
              child: Sprite(
                'enemies/${state.stage!.enemy.sprite}',
                height: 70,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EnemyHealthBar extends StatelessWidget {
  const _EnemyHealthBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        final stage = state.stage!;
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/stage-backdrop-ground.png'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _enemyInformation(
              name: stage.enemy.name,
              currentHp: stage.enemy.currentHp,
              maxHp: stage.enemy.maxHp,
            ),
          ),
        );
      },
    );
  }

  Widget _enemyInformation({
    required String name,
    required int currentHp,
    required int maxHp,
  }) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          CustomSubheader(name, fontSize: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(
                    begin: 0,
                    end: currentHp / maxHp,
                  ),
                  builder: (_, value, __) => LinearProgressIndicator(
                    value: value,
                    color: Colors.red,
                    backgroundColor: Colors.white.withOpacity(0.4),
                    minHeight: 13,
                  ),
                ),
              ),
              CustomSubheader(
                'HP $currentHp/$maxHp',
                color: Colors.black,
                fontSize: 8,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
