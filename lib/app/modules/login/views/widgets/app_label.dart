import 'package:zone2/app/extensions/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLabel extends StatelessWidget {
  const AppLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
            child: Text('ThreeTen Labs Template',
                style: GoogleFonts.quicksand().copyWith(
                  color: Colors.white,
                )).scaled(context, scalePercent: 0.07))
        .animate()
        .scaleXY(begin: 0, end: 1, duration: const Duration(milliseconds: 2000))
        .slideY(begin: 2, end: -0.2, duration: const Duration(milliseconds: 2000));
  }
}
