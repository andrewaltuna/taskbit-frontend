import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/constants.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/logo-scroll.png'),
          Text(
            appName,
            style: GoogleFonts.pressStart2p(
              fontSize: 15,
              shadows: [
                const Shadow(
                    color: Color.fromRGBO(203, 156, 211, 1.0),
                    offset: Offset(2.0, 2.0))
              ],
            ),
          )
        ],
      ),
    );
  }
}
