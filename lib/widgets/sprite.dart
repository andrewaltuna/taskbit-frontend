import 'package:flutter/material.dart';

class Sprite extends StatelessWidget {
  const Sprite(
    this.path, {
    super.key,
    required this.height,
  });

  final String path;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          filterQuality: FilterQuality.none,
          fit: BoxFit.contain,
          image: AssetImage('assets/sprites/${path}_idle.gif'),
        ),
      ),
    );
  }
}
