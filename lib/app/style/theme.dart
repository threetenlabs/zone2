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

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff046b5c),
      surfaceTint: Color(0xff046b5c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffa0f2df),
      onPrimaryContainer: Color(0xff00201b),
      secondary: Color(0xff4a635d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcde8e0),
      onSecondaryContainer: Color(0xff06201b),
      tertiary: Color(0xff436278),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc9e6ff),
      onTertiaryContainer: Color(0xff001e2f),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff5fbf7),
      onSurface: Color(0xff171d1b),
      onSurfaceVariant: Color(0xff3f4946),
      outline: Color(0xff6f7976),
      outlineVariant: Color(0xffbec9c5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3230),
      inversePrimary: Color(0xff84d6c3),
      primaryFixed: Color(0xffa0f2df),
      onPrimaryFixed: Color(0xff00201b),
      primaryFixedDim: Color(0xff84d6c3),
      onPrimaryFixedVariant: Color(0xff005045),
      secondaryFixed: Color(0xffcde8e0),
      onSecondaryFixed: Color(0xff06201b),
      secondaryFixedDim: Color(0xffb1ccc4),
      onSecondaryFixedVariant: Color(0xff334b46),
      tertiaryFixed: Color(0xffc9e6ff),
      onTertiaryFixed: Color(0xff001e2f),
      tertiaryFixedDim: Color(0xffabcae4),
      onTertiaryFixedVariant: Color(0xff2b4a5f),
      surfaceDim: Color(0xffd5dbd8),
      surfaceBright: Color(0xfff5fbf7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f2),
      surfaceContainer: Color(0xffe9efec),
      surfaceContainerHigh: Color(0xffe3eae6),
      surfaceContainerHighest: Color(0xffdee4e1),
    );
  }

  static ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004c41),
      surfaceTint: Color(0xff046b5c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2c8272),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2f4742),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff607a73),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff27465b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5a788f),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fbf7),
      onSurface: Color(0xff171d1b),
      onSurfaceVariant: Color(0xff3b4542),
      outline: Color(0xff57615e),
      outlineVariant: Color(0xff737d79),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3230),
      inversePrimary: Color(0xff84d6c3),
      primaryFixed: Color(0xff2c8272),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00685a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff607a73),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff48615b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5a788f),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff415f76),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd5dbd8),
      surfaceBright: Color(0xfff5fbf7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f2),
      surfaceContainer: Color(0xffe9efec),
      surfaceContainerHigh: Color(0xffe3eae6),
      surfaceContainerHighest: Color(0xffdee4e1),
    );
  }

  static ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002821),
      surfaceTint: Color(0xff046b5c),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004c41),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff0d2621),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff2f4742),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002539),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff27465b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5fbf7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1c2623),
      outline: Color(0xff3b4542),
      outlineVariant: Color(0xff3b4542),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3230),
      inversePrimary: Color(0xffa9fce9),
      primaryFixed: Color(0xff004c41),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00332b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff2f4742),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff19312c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff27465b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff0d3044),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd5dbd8),
      surfaceBright: Color(0xfff5fbf7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f2),
      surfaceContainer: Color(0xffe9efec),
      surfaceContainerHigh: Color(0xffe3eae6),
      surfaceContainerHighest: Color(0xffdee4e1),
    );
  }

  static ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff84d6c3),
      surfaceTint: Color(0xff84d6c3),
      onPrimary: Color(0xff00382f),
      primaryContainer: Color(0xff005045),
      onPrimaryContainer: Color(0xffa0f2df),
      secondary: Color(0xffb1ccc4),
      onSecondary: Color(0xff1c352f),
      secondaryContainer: Color(0xff334b46),
      onSecondaryContainer: Color(0xffcde8e0),
      tertiary: Color(0xffabcae4),
      onTertiary: Color(0xff123348),
      tertiaryContainer: Color(0xff2b4a5f),
      onTertiaryContainer: Color(0xffc9e6ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1513),
      onSurface: Color(0xffdee4e1),
      onSurfaceVariant: Color(0xffbec9c5),
      outline: Color(0xff89938f),
      outlineVariant: Color(0xff3f4946),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e1),
      inversePrimary: Color(0xff046b5c),
      primaryFixed: Color(0xffa0f2df),
      onPrimaryFixed: Color(0xff00201b),
      primaryFixedDim: Color(0xff84d6c3),
      onPrimaryFixedVariant: Color(0xff005045),
      secondaryFixed: Color(0xffcde8e0),
      onSecondaryFixed: Color(0xff06201b),
      secondaryFixedDim: Color(0xffb1ccc4),
      onSecondaryFixedVariant: Color(0xff334b46),
      tertiaryFixed: Color(0xffc9e6ff),
      onTertiaryFixed: Color(0xff001e2f),
      tertiaryFixedDim: Color(0xffabcae4),
      onTertiaryFixedVariant: Color(0xff2b4a5f),
      surfaceDim: Color(0xff0e1513),
      surfaceBright: Color(0xff343b38),
      surfaceContainerLowest: Color(0xff090f0e),
      surfaceContainerLow: Color(0xff171d1b),
      surfaceContainer: Color(0xff1b211f),
      surfaceContainerHigh: Color(0xff252b29),
      surfaceContainerHighest: Color(0xff303634),
    );
  }

  static ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff88dac8),
      surfaceTint: Color(0xff84d6c3),
      onPrimary: Color(0xff001a15),
      primaryContainer: Color(0xff4c9e8e),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffb5d1c9),
      onSecondary: Color(0xff021a16),
      secondaryContainer: Color(0xff7c968f),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffafcfe9),
      onTertiary: Color(0xff001827),
      tertiaryContainer: Color(0xff7694ad),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1513),
      onSurface: Color(0xfff6fcf9),
      onSurfaceVariant: Color(0xffc3cdc9),
      outline: Color(0xff9ba5a1),
      outlineVariant: Color(0xff7b8582),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e1),
      inversePrimary: Color(0xff005246),
      primaryFixed: Color(0xffa0f2df),
      onPrimaryFixed: Color(0xff001510),
      primaryFixedDim: Color(0xff84d6c3),
      onPrimaryFixedVariant: Color(0xff003e35),
      secondaryFixed: Color(0xffcde8e0),
      onSecondaryFixed: Color(0xff001510),
      secondaryFixedDim: Color(0xffb1ccc4),
      onSecondaryFixedVariant: Color(0xff223b35),
      tertiaryFixed: Color(0xffc9e6ff),
      onTertiaryFixed: Color(0xff001320),
      tertiaryFixedDim: Color(0xffabcae4),
      onTertiaryFixedVariant: Color(0xff19394e),
      surfaceDim: Color(0xff0e1513),
      surfaceBright: Color(0xff343b38),
      surfaceContainerLowest: Color(0xff090f0e),
      surfaceContainerLow: Color(0xff171d1b),
      surfaceContainer: Color(0xff1b211f),
      surfaceContainerHigh: Color(0xff252b29),
      surfaceContainerHighest: Color(0xff303634),
    );
  }

  static ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffecfff8),
      surfaceTint: Color(0xff84d6c3),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff88dac8),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffecfff8),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb5d1c9),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff9fbff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffafcfe9),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1513),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff3fdf9),
      outline: Color(0xffc3cdc9),
      outlineVariant: Color(0xffc3cdc9),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee4e1),
      inversePrimary: Color(0xff003029),
      primaryFixed: Color(0xffa4f6e3),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff88dac8),
      onPrimaryFixedVariant: Color(0xff001a15),
      secondaryFixed: Color(0xffd1ede4),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb5d1c9),
      onSecondaryFixedVariant: Color(0xff021a16),
      tertiaryFixed: Color(0xffd2eaff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffafcfe9),
      onTertiaryFixedVariant: Color(0xff001827),
      surfaceDim: Color(0xff0e1513),
      surfaceBright: Color(0xff343b38),
      surfaceContainerLowest: Color(0xff090f0e),
      surfaceContainerLow: Color(0xff171d1b),
      surfaceContainer: Color(0xff1b211f),
      surfaceContainerHigh: Color(0xff252b29),
      surfaceContainerHighest: Color(0xff303634),
    );
  }

  static ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
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
