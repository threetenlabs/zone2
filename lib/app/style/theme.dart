import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";

class MaterialTheme {
  static TextTheme textTheme = const TextTheme();
  MaterialTheme() {
    TextTheme baseTextTheme = Theme.of(Get.context!).textTheme;
    TextTheme bodyTextTheme = GoogleFonts.getTextTheme('ABeeZee', baseTextTheme);
    TextTheme displayTextTheme = GoogleFonts.getTextTheme('ABeeZee', baseTextTheme);
    textTheme = displayTextTheme.copyWith(
      bodyLarge: bodyTextTheme.bodyLarge,
      bodyMedium: bodyTextTheme.bodyMedium,
      bodySmall: bodyTextTheme.bodySmall,
      labelLarge: bodyTextTheme.labelLarge,
      labelMedium: bodyTextTheme.labelMedium,
      labelSmall: bodyTextTheme.labelSmall,
    );
  }

  static ThemeData light() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff627D98), // Muted blue-gray
      onPrimary: Color(0xffffffff), // Soft white
      primaryContainer: Color(0xffD9E2EB), // Pale blue-gray
      onPrimaryContainer: Color(0xff1C3A53), // Deep blue-gray
      secondary: Color(0xff598381), // Muted teal
      onSecondary: Color(0xffffffff), // Soft white
      secondaryContainer: Color(0xffBEE0DD), // Light teal
      onSecondaryContainer: Color(0xff2C5250), // Dark teal
      tertiary: Color(0xffE38983), // Soft coral
      onTertiary: Color(0xffffffff), // Soft white
      tertiaryContainer: Color(0xffF8D9D8), // Pale coral
      onTertiaryContainer: Color(0xffA14442), // Deep coral
      error: Color(0xffB00020), // Default error color
      onError: Color(0xffffffff), // White for error text
      errorContainer: Color(0xfffcd8df), // Light error container
      onErrorContainer: Color(0xff370b1e), // Dark error text
      surface: Color(0xffF8F9FA), // Off-white
      onSurface: Color(0xff23272A), // Deep gray
      surfaceTint: Color(0xffE1E5E9), // Light gray
      outline: Color(0xff627D98), // Muted blue-gray for outlines
      outlineVariant: Color(0xffD9E2EB), // Pale blue-gray for variant outlines
      shadow: Color(0xff000000), // Black for shadows
      scrim: Color(0xff000000), // Black for scrims
      inverseSurface: Color(0xff23272A), // Deep gray for inverse surfaces
      inversePrimary: Color(0xff1C3A53), // Deep blue-gray for inverse primary
      primaryFixed: Color(0xffD9E2EB), // Pale blue-gray for fixed primary
      onPrimaryFixed: Color(0xff1C3A53), // Deep blue-gray for fixed primary text
      primaryFixedDim: Color(0xff627D98), // Muted blue-gray for dim fixed primary
      onPrimaryFixedVariant: Color(0xff1C3A53), // Deep blue-gray for fixed variant text
      secondaryFixed: Color(0xffBEE0DD), // Light teal for fixed secondary
      onSecondaryFixed: Color(0xff2C5250), // Dark teal for fixed secondary text
      secondaryFixedDim: Color(0xff598381), // Muted teal for dim fixed secondary
      onSecondaryFixedVariant: Color(0xff2C5250), // Dark teal for fixed variant text
      tertiaryFixed: Color(0xffF8D9D8), // Pale coral for fixed tertiary
      onTertiaryFixed: Color(0xffA14442), // Deep coral for fixed tertiary text
      tertiaryFixedDim: Color(0xffE38983), // Soft coral for dim fixed tertiary
      onTertiaryFixedVariant: Color(0xffA14442), // Deep coral for fixed variant text
      surfaceDim: Color(0xffE1E5E9), // Light gray for dim surfaces
      surfaceBright: Color(0xffF8F9FA), // Off-white for bright surfaces
      surfaceContainerLowest: Color(0xffffffff), // White for lowest container
      surfaceContainerLow: Color(0xffFAFBFC), // Very pale gray for low container
      surfaceContainer: Color(0xffF8F9FA), // Off-white for container
      surfaceContainerHigh: Color(0xffE1E5E9), // Light gray for high container
      surfaceContainerHighest: Color(0xffD9E2EB), // Pale blue-gray for highest container
    );
  }

  static ThemeData dark() {
    return theme(darkHighContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffA1B4C5), // Muted blue-gray
      onPrimary: Color(0xff1C3A53), // Dark slate
      primaryContainer: Color(0xff3B4F62), // Deep blue-gray
      onPrimaryContainer: Color(0xffD9E2EB), // Muted white
      secondary: Color(0xff8AA8A5), // Muted teal
      onSecondary: Color(0xff2C5250), // Deep teal
      secondaryContainer: Color(0xff4D6664), // Dark teal-gray
      onSecondaryContainer: Color(0xffBEE0DD), // Light teal-gray
      tertiary: Color(0xffD38885), // Soft coral
      onTertiary: Color(0xff5A2C2A), // Deep coral
      tertiaryContainer: Color(0xff6F3F3E), // Dark coral
      onTertiaryContainer: Color(0xffE3B1AF), // Muted coral
      error: Color(0xffCF6679), // Default error color
      onError: Color(0xff1C1C1C), // Dark for error text
      errorContainer: Color(0xffB00020), // Dark error container
      onErrorContainer: Color(0xffFCD8DF), // Light error text
      surface: Color(0xff262F3A), // Deep slate blue-gray
      onSurface: Color(0xffD9E2EB), // Muted white
      surfaceTint: Color(0xff313C48), // Slightly lighter slate blue-gray
      outline: Color(0xffA1B4C5), // Muted blue-gray for outlines
      outlineVariant: Color(0xff3B4F62), // Deep blue-gray for variant outlines
      shadow: Color(0xff000000), // Black for shadows
      scrim: Color(0xff000000), // Black for scrims
      inverseSurface: Color(0xffD9E2EB), // Muted white for inverse surfaces
      inversePrimary: Color(0xff3B4F62), // Deep blue-gray for inverse primary
      primaryFixed: Color(0xff3B4F62), // Deep blue-gray for fixed primary
      onPrimaryFixed: Color(0xffD9E2EB), // Muted white for fixed primary text
      primaryFixedDim: Color(0xffA1B4C5), // Muted blue-gray for dim fixed primary
      onPrimaryFixedVariant: Color(0xffD9E2EB), // Muted white for fixed variant text
      secondaryFixed: Color(0xff4D6664), // Dark teal-gray for fixed secondary
      onSecondaryFixed: Color(0xffBEE0DD), // Light teal-gray for fixed secondary text
      secondaryFixedDim: Color(0xff8AA8A5), // Muted teal for dim fixed secondary
      onSecondaryFixedVariant: Color(0xffBEE0DD), // Light teal-gray for fixed variant text
      tertiaryFixed: Color(0xff6F3F3E), // Dark coral for fixed tertiary
      onTertiaryFixed: Color(0xffE3B1AF), // Muted coral for fixed tertiary text
      tertiaryFixedDim: Color(0xffD38885), // Soft coral for dim fixed tertiary
      onTertiaryFixedVariant: Color(0xffE3B1AF), // Muted coral for fixed variant text
      surfaceDim: Color(0xff313C48), // Slightly lighter slate blue-gray for dim surfaces
      surfaceBright: Color(0xff262F3A), // Deep slate blue-gray for bright surfaces
      surfaceContainerLowest:
          Color.fromARGB(255, 145, 185, 225), // Dark slate gray for lowest container
      surfaceContainerLow: Color(0xff262F3A), // Deep slate blue-gray for low container
      surfaceContainer: Color(0xff313C48), // Slightly lighter slate blue-gray for container
      surfaceContainerHigh: Color(0xff3B4F62), // Deep blue-gray for high container
      surfaceContainerHighest: Color(0xff4D6664), // Dark teal-gray for highest container
    );
  }

  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        cardTheme: CardTheme(
          color: colorScheme.surfaceContainerHigh,
        ),
      );

  /// Cool Blue
  static const coolBlue = ExtendedColor(
    seed: Color(0xff00b0ff),
    value: Color(0xff00b0ff),
    light: ColorFamily(
      color: Color(0xff28638a),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffcae6ff),
      onColorContainer: Color(0xff001e30),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff28638a),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffcae6ff),
      onColorContainer: Color(0xff001e30),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff28638a),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffcae6ff),
      onColorContainer: Color(0xff001e30),
    ),
    dark: ColorFamily(
      color: Color(0xff96ccf8),
      onColor: Color(0xff00344f),
      colorContainer: Color(0xff004b70),
      onColorContainer: Color(0xffcae6ff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff96ccf8),
      onColor: Color(0xff00344f),
      colorContainer: Color(0xff004b70),
      onColorContainer: Color(0xffcae6ff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff96ccf8),
      onColor: Color(0xff00344f),
      colorContainer: Color(0xff004b70),
      onColorContainer: Color(0xffcae6ff),
    ),
  );

  /// Cool Red
  static const coolRed = ExtendedColor(
    seed: Color(0xfff50057),
    value: Color(0xfff50057),
    light: ColorFamily(
      color: Color(0xff8f4953),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffd9dc),
      onColorContainer: Color(0xff3b0713),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff8f4953),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffd9dc),
      onColorContainer: Color(0xff3b0713),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff8f4953),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffd9dc),
      onColorContainer: Color(0xff3b0713),
    ),
    dark: ColorFamily(
      color: Color(0xffffb2ba),
      onColor: Color(0xff561d26),
      colorContainer: Color(0xff72333c),
      onColorContainer: Color(0xffffd9dc),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffffb2ba),
      onColor: Color(0xff561d26),
      colorContainer: Color(0xff72333c),
      onColorContainer: Color(0xffffd9dc),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffffb2ba),
      onColor: Color(0xff561d26),
      colorContainer: Color(0xff72333c),
      onColorContainer: Color(0xffffd9dc),
    ),
  );

  /// Cool Orange
  static const coolOrange = ExtendedColor(
    seed: Color(0xfff9a826),
    value: Color(0xfff9a826),
    light: ColorFamily(
      color: Color(0xff815511),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffddb5),
      onColorContainer: Color(0xff2a1800),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff815511),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffddb5),
      onColorContainer: Color(0xff2a1800),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff815511),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffddb5),
      onColorContainer: Color(0xff2a1800),
    ),
    dark: ColorFamily(
      color: Color(0xfff6bc70),
      onColor: Color(0xff462b00),
      colorContainer: Color(0xff643f00),
      onColorContainer: Color(0xffffddb5),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xfff6bc70),
      onColor: Color(0xff462b00),
      colorContainer: Color(0xff643f00),
      onColorContainer: Color(0xffffddb5),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xfff6bc70),
      onColor: Color(0xff462b00),
      colorContainer: Color(0xff643f00),
      onColorContainer: Color(0xffffddb5),
    ),
  );

  /// Cool Purple
  static const coolPurple = ExtendedColor(
    seed: Color(0xff6c63ff),
    value: Color(0xff6c63ff),
    light: ColorFamily(
      color: Color(0xff5a5891),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffe3dfff),
      onColorContainer: Color(0xff16134a),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff5a5891),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffe3dfff),
      onColorContainer: Color(0xff16134a),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff5a5891),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffe3dfff),
      onColorContainer: Color(0xff16134a),
    ),
    dark: ColorFamily(
      color: Color(0xffc4c0ff),
      onColor: Color(0xff2c2960),
      colorContainer: Color(0xff434078),
      onColorContainer: Color(0xffe3dfff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffc4c0ff),
      onColor: Color(0xff2c2960),
      colorContainer: Color(0xff434078),
      onColorContainer: Color(0xffe3dfff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffc4c0ff),
      onColor: Color(0xff2c2960),
      colorContainer: Color(0xff434078),
      onColorContainer: Color(0xffe3dfff),
    ),
  );

  List<ExtendedColor> get extendedColors => [
        coolBlue,
        coolRed,
        coolOrange,
        coolPurple,
      ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
