import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/widgets/sprite.dart';

class BattleDisplay extends StatelessWidget {
  const BattleDisplay({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _stageLabel(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // player sprite
                    const Sprite('avatars/knight', height: 70),
                    // enemy sprite
                    Transform.scale(
                      scaleX: 1,
                      child: const Sprite('enemies/slime', height: 70),
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
              image: AssetImage('assets/images/stage-backdrop-ground.png'),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _enemyInformation(),
          ),
        ),
      ],
    );
  }

  Widget _stageLabel() {
    return Text(
      'Stage 1-1',
      style: GoogleFonts.pressStart2p(
        color: Colors.white,
      ),
    );
  }

  Widget _enemyInformation() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        children: [
          Text(
            'Goblin King',
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
                child: LinearProgressIndicator(
                  value: 0.67,
                  color: Colors.red,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  minHeight: 13,
                ),
              ),
              Text(
                'HP 67/100',
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
