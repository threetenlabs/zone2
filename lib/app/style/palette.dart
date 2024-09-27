// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:app/app/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A palette of colors to be used in the game.
///
/// The reason we're not going with something like Material Design's
/// `Theme` is simply that this is simpler to work with and yet gives
/// us everything we need for a game.
///
/// Games generally have more radical color palettes than apps. For example,
/// every level of a game can have radically different colors.
/// At the same time, games rarely support dark mode.
///
/// Colors taken from this fun palette:
/// https://lospec.com/palette-list/crayola84
///
/// Colors here are implemented as getters so that hot reloading works.
/// In practice, we could just as easily implement the colors
/// as `static const`. But this way the palette is more malleable:
/// we could allow players to customize colors, for example,
/// or even get the colors from the network.
class Palette {
  // Color get pen => const Color(0xff1d75fb);
  // Color get darkPen => const Color(0xFF0050bc);
  // Color get redPen => const Color(0xFFd10841);
  // Color get backgroundLevelSelection => const Color(0xffa2dcc7);
  // Color get backgroundPlaySession => const Color(0xffffebb5);
  // Color get background4 => const Color(0xffffd7ff);
  // Color get backgroundSettings => const Color(0xffbfc8e3);

  Color get inkFullOpacity => const Color(0xff352b42);

  MaterialColor get meccaOnSecondaryColor => inkFullOpacity.toMaterialColor();

  Color get appPrimary => const Color.fromARGB(255, 67, 182, 217);
  Color get appSecondary => const Color.fromARGB(235, 139, 32, 216);
  Color get unselectedButton => const Color.fromARGB(255, 91, 90, 90);

  Color get darkBackGround => const Color.fromARGB(255, 43, 43, 43);
  Color get reallyDarkBackGround => const Color.fromARGB(255, 33, 33, 33);
  Color get trueWhite => const Color(0xffffffff);
  Color get smokyWhite => const Color(0xfff5f5f5);
  Color get appError => const Color.fromARGB(255, 183, 0, 31);
  Color get appDisabled => const Color.fromARGB(255, 110, 110, 110);
  // Animated menu bar colors
  Color get mainMenuGames => const Color.fromARGB(255, 255, 110, 134);
  Color get mainMenuSettings => const Color.fromARGB(255, 67, 182, 217);
  Color get mainMenuStore => const Color.fromARGB(255, 212, 109, 145);
  Color get mainMenuProfile => const Color.fromARGB(255, 213, 252, 159);

  ThemeData get primaryTheme => ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          // ···
          brightness: Brightness.dark,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      );
}
