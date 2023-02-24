import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/auth/models/enemy.dart';
import 'package:taskbit/auth/models/user.dart';
import 'package:taskbit/tasks/cubit/tasks_cubit.dart';
import 'package:taskbit/tasks/models/stage.dart';
import 'package:taskbit/widgets/sprite.dart';

class BattleDisplay extends StatelessWidget {
  const BattleDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        Stage stage = state.stage!;
        return BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            User user = state.user!;
            String userSprite = user.avatar;
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
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 40.0, right: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _stageLabel('${stage.stage}-${stage.substage}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // player sprite
                            Sprite('avatars/$userSprite', height: 70),
                            // enemy sprite
                            Transform.scale(
                              scaleX: 1,
                              child: Sprite('enemies/${stage.enemy.sprite}',
                                  height: 70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image:
                          AssetImage('assets/images/stage-backdrop-ground.png'),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _enemyInformation(
                        name: stage.enemy.name,
                        currentHp: stage.enemy.currentHp,
                        maxHp: stage.enemy.maxHp),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _stageLabel(String stageInfo) {
    return Text(
      'Stage $stageInfo',
      style: GoogleFonts.pressStart2p(
        color: Colors.white,
      ),
    );
  }

  Widget _enemyInformation(
      {required String name, required int currentHp, required int maxHp}) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          Text(
            name,
            style: GoogleFonts.pressStart2p(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
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
              Text(
                'HP $currentHp/$maxHp',
                style: GoogleFonts.pressStart2p(
                  color: Colors.black,
                  fontSize: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
