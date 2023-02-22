import 'package:flutter/material.dart';

class CustomSpacer extends StatelessWidget {
  const CustomSpacer(this.size, {super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size, width: size);
  }
}
