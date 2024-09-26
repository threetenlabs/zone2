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

  Color get guacamole => const Color(0xff98A77D);
  Color get avocado => const Color(0xff568203);
  Color get onion => const Color(0xffA3A948);
  Color get cilantro => const Color(0xff3F9B6B);
  Color get lime => const Color(0xffCDEA80);
  Color get tomato => const Color(0xff9B1B30);
  Color get jalapeno => const Color(0xff006E44);
  Color get sourCream => const Color.fromARGB(255, 242, 242, 227);

  MaterialColor get meccaPrimaryColor => inkFullOpacity.toMaterialColor();
  MaterialColor get meccaAccentColor => avocado.toMaterialColor();
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

  ButtonStyle get textButtonStyle => TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16), // Text size
      );

  ThemeData get meccaPrimaryTheme => ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: meccaPrimaryColor, accentColor: meccaOnSecondaryColor),
      );

  ThemeData get primaryTheme => ThemeData(
        useMaterial3: false,
        visualDensity: VisualDensity.standard,
        dialogBackgroundColor: darkBackGround,
        appBarTheme: AppBarTheme(backgroundColor: darkBackGround, foregroundColor: smokyWhite),
        canvasColor: reallyDarkBackGround,

        colorScheme: ColorScheme(
          primary: appPrimary,
          onPrimary: smokyWhite,
          error: appError,
          onError: smokyWhite,
          surface: smokyWhite,
          onSurface: darkBackGround,
          onSecondary: smokyWhite,
          secondary: appSecondary,
          brightness: Brightness.light,
        ),
        // bottoJsonpBarTheme: BottoJsonpBarTheme(surfaceTintColor: darkBackGround, color: smokyWhite),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0.7,
          backgroundColor: appPrimary,
          selectedItemColor: smokyWhite,
          unselectedItemColor: smokyWhite,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            side: WidgetStateProperty.all<BorderSide>(BorderSide(color: appPrimary)),
            backgroundColor: WidgetStateProperty.all<Color>(darkBackGround),
            foregroundColor: WidgetStateProperty.all<Color>(smokyWhite),
          ),
        ),
        buttonTheme: ButtonThemeData(
            focusColor: Colors.blue,
            buttonColor: Colors.blue, // Default color for all RaisedButton (Deprecated).
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textTheme: ButtonTextTheme.normal),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue, // Background color for TextButtons.

            foregroundColor: Colors.white, // Text color for TextButtons.
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Text color for TextButtons.
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        dialogTheme: ThemeData().dialogTheme.copyWith(
              backgroundColor: reallyDarkBackGround,
              titleTextStyle: GoogleFonts.quicksand().copyWith(color: smokyWhite),
              contentTextStyle: GoogleFonts.quicksand().copyWith(color: smokyWhite),
            ),
        textTheme: TextTheme(
          bodySmall: GoogleFonts.roboto().copyWith(color: trueWhite, fontSize: 14),
          bodyMedium: GoogleFonts.roboto().copyWith(color: trueWhite, fontSize: 16),
          bodyLarge: GoogleFonts.roboto().copyWith(color: trueWhite, fontSize: 18),
          titleSmall: GoogleFonts.quicksand().copyWith(color: trueWhite, fontSize: 20),
          titleMedium: GoogleFonts.quicksand().copyWith(color: trueWhite, fontSize: 24),
          titleLarge: GoogleFonts.quicksand().copyWith(color: trueWhite, fontSize: 28),
          // Add other text styles as needed
        ),
      );

  // Scribology colors & theme
  Color get scribologyBlue => const Color(0xff06558e);
  Color get scribologyGreen => const Color(0xffa9c9cb);
  Color get scribologyTan => const Color(0xfffaf9e6);
  Color get scribologyDarkText => const Color.fromARGB(255, 17, 16, 16);
  Color get scribologyWhite => const Color.fromARGB(255, 255, 255, 255);

  Color get scribologyPrimary => const Color(0xff4b94af);
  Color get scribologySecondary => const Color(0xffa9c9cb);
  Color get scribologyTeritary => const Color.fromARGB(255, 223, 19, 118);

  ThemeData get scribologyTheme => ThemeData(
        useMaterial3: false,
        visualDensity: VisualDensity.standard,
        scaffoldBackgroundColor: scribologyGreen,
        appBarTheme: AppBarTheme(backgroundColor: darkBackGround, foregroundColor: smokyWhite),
        canvasColor: scribologyBlue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          hintStyle: TextStyle(color: appDisabled),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        textTheme: TextTheme(
          bodySmall: GoogleFonts.schoolbell().copyWith(color: trueWhite, fontSize: 14),
          bodyMedium: GoogleFonts.schoolbell().copyWith(color: trueWhite, fontSize: 16),
          bodyLarge: GoogleFonts.schoolbell().copyWith(color: trueWhite, fontSize: 18),
          titleSmall: GoogleFonts.schoolbell().copyWith(color: trueWhite, fontSize: 20),
          titleMedium: GoogleFonts.schoolbell().copyWith(color: trueWhite, fontSize: 24),
          titleLarge: GoogleFonts.schoolbell().copyWith(color: trueWhite, fontSize: 28),
          // Add other text styles as needed
        ),
        colorScheme: ColorScheme(
          primary: scribologyGreen,
          onPrimary: darkBackGround,
          error: appError,
          onError: smokyWhite,
          surface: scribologyGreen,
          onSurface: darkBackGround,
          secondary: scribologyPrimary,
          onSecondary: darkBackGround,
          brightness: Brightness.light,
        ),
        bottomAppBarTheme: ThemeData().bottomAppBarTheme.copyWith(
              color: scribologyBlue,
              elevation: 5,
            ),
        dialogTheme: ThemeData().dialogTheme.copyWith(
              backgroundColor: scribologyGreen,
              titleTextStyle: GoogleFonts.schoolbell().copyWith(color: scribologyDarkText),
              contentTextStyle: GoogleFonts.schoolbell().copyWith(color: scribologyDarkText),
            ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0.7,
          backgroundColor: scribologyBlue,
          selectedItemColor: scribologyBlue,
          unselectedItemColor: scribologyBlue,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            side: WidgetStateProperty.all<BorderSide>(BorderSide(color: scribologyBlue)),
            backgroundColor: WidgetStateProperty.all<Color>(darkBackGround),
            foregroundColor: WidgetStateProperty.all<Color>(smokyWhite),
          ),
        ),
        buttonTheme: ButtonThemeData(
            focusColor: Colors.blue,
            buttonColor: Colors.blue, // Default color for all RaisedButton (Deprecated).
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textTheme: ButtonTextTheme.normal),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue, // Background color for TextButtons.

            foregroundColor: Colors.white, // Text color for TextButtons.
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 5,
            foregroundColor: Colors.white, // Text color for TextButtons.
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: scribologyBlue,
          ),
        ),
      );
}
