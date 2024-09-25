import 'package:app/app/extensions/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.scaledPercent});

  final double scaledPercent;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          'ThreeTen Labs Template',
          style: GoogleFonts.quicksand(),
        ).scaled(context, scalePercent: scaledPercent),
      ),
    );
  }
}
