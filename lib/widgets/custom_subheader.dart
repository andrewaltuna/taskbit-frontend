import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSubheader extends StatelessWidget {
  const CustomSubheader(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.color = Colors.white,
  });

  final String text;
  final double fontSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.pressStart2p(
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}
