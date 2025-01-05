import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8e0028),
      surfaceTint: Color(0xffbe0039),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffce1141),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffa53846),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffff8c95),
      onSecondaryContainer: Color(0xff4e0012),
      tertiary: Color(0xff713300),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa84f00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff281718),
      onSurfaceVariant: Color(0xff5b3f41),
      outline: Color(0xff906f70),
      outlineVariant: Color(0xffe4bdbe),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3e2c2c),
      inversePrimary: Color(0xffffb2b7),
      primaryFixed: Color(0xffffdadb),
      onPrimaryFixed: Color(0xff40000d),
      primaryFixedDim: Color(0xffffb2b7),
      onPrimaryFixedVariant: Color(0xff920029),
      secondaryFixed: Color(0xffffdadb),
      onSecondaryFixed: Color(0xff40000d),
      secondaryFixedDim: Color(0xffffb2b7),
      onSecondaryFixedVariant: Color(0xff852030),
      tertiaryFixed: Color(0xffffdbc8),
      onTertiaryFixed: Color(0xff321300),
      tertiaryFixedDim: Color(0xffffb68a),
      onTertiaryFixedVariant: Color(0xff743500),
      surfaceDim: Color(0xfff1d3d3),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f0),
      surfaceContainer: Color(0xffffe9e9),
      surfaceContainerHigh: Color(0xffffe1e2),
      surfaceContainerHighest: Color(0xfffadbdc),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8a0027),
      surfaceTint: Color(0xffbe0039),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffce1141),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff801c2d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc24e5b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff6e3200),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa84f00),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff281718),
      onSurfaceVariant: Color(0xff573c3d),
      outline: Color(0xff765759),
      outlineVariant: Color(0xff947274),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3e2c2c),
      inversePrimary: Color(0xffffb2b7),
      primaryFixed: Color(0xffe0244c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xffba0037),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xffc24e5b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xffa23644),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xffb85b10),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff954500),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xfff1d3d3),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f0),
      surfaceContainer: Color(0xffffe9e9),
      surfaceContainerHigh: Color(0xffffe1e2),
      surfaceContainerHighest: Color(0xfffadbdc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff4d0011),
      surfaceTint: Color(0xffbe0039),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8a0027),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff4d0011),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff801c2d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3c1800),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6e3200),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff351d1f),
      outline: Color(0xff573c3d),
      outlineVariant: Color(0xff573c3d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff3e2c2c),
      inversePrimary: Color(0xffffe6e7),
      primaryFixed: Color(0xff8a0027),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff610018),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff801c2d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff600018),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6e3200),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff4c2000),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xfff1d3d3),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0f0),
      surfaceContainer: Color(0xffffe9e9),
      surfaceContainerHigh: Color(0xffffe1e2),
      surfaceContainerHighest: Color(0xfffadbdc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb2b7),
      surfaceTint: Color(0xffffb2b7),
      onPrimary: Color(0xff67001b),
      primaryContainer: Color(0xffc1003a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffffb2b7),
      onSecondary: Color(0xff66051c),
      secondaryContainer: Color(0xff7c192a),
      onSecondaryContainer: Color(0xffffc8ca),
      tertiary: Color(0xffffb68a),
      onTertiary: Color(0xff522300),
      tertiaryContainer: Color(0xff9a4800),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1e0f10),
      onSurface: Color(0xfffadbdc),
      onSurfaceVariant: Color(0xffe4bdbe),
      outline: Color(0xffab8889),
      outlineVariant: Color(0xff5b3f41),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffadbdc),
      inversePrimary: Color(0xffbe0039),
      primaryFixed: Color(0xffffdadb),
      onPrimaryFixed: Color(0xff40000d),
      primaryFixedDim: Color(0xffffb2b7),
      onPrimaryFixedVariant: Color(0xff920029),
      secondaryFixed: Color(0xffffdadb),
      onSecondaryFixed: Color(0xff40000d),
      secondaryFixedDim: Color(0xffffb2b7),
      onSecondaryFixedVariant: Color(0xff852030),
      tertiaryFixed: Color(0xffffdbc8),
      onTertiaryFixed: Color(0xff321300),
      tertiaryFixedDim: Color(0xffffb68a),
      onTertiaryFixedVariant: Color(0xff743500),
      surfaceDim: Color(0xff1e0f10),
      surfaceBright: Color(0xff483435),
      surfaceContainerLowest: Color(0xff190a0b),
      surfaceContainerLow: Color(0xff281718),
      surfaceContainer: Color(0xff2c1b1c),
      surfaceContainerHigh: Color(0xff372526),
      surfaceContainerHighest: Color(0xff433031),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb9bc),
      surfaceTint: Color(0xffffb2b7),
      onPrimary: Color(0xff36000a),
      primaryContainer: Color(0xffff516a),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffffb9bc),
      onSecondary: Color(0xff36000a),
      secondaryContainer: Color(0xffe66975),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffbc94),
      onTertiary: Color(0xff2a0f00),
      tertiaryContainer: Color(0xffdb762d),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1e0f10),
      onSurface: Color(0xfffff9f9),
      onSurfaceVariant: Color(0xffe9c1c2),
      outline: Color(0xffbe9a9b),
      outlineVariant: Color(0xff9d7b7c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffadbdc),
      inversePrimary: Color(0xff94002a),
      primaryFixed: Color(0xffffdadb),
      onPrimaryFixed: Color(0xff2d0007),
      primaryFixedDim: Color(0xffffb2b7),
      onPrimaryFixedVariant: Color(0xff72001e),
      secondaryFixed: Color(0xffffdadb),
      onSecondaryFixed: Color(0xff2d0007),
      secondaryFixedDim: Color(0xffffb2b7),
      onSecondaryFixedVariant: Color(0xff6e0c21),
      tertiaryFixed: Color(0xffffdbc8),
      onTertiaryFixed: Color(0xff220a00),
      tertiaryFixedDim: Color(0xffffb68a),
      onTertiaryFixedVariant: Color(0xff5b2800),
      surfaceDim: Color(0xff1e0f10),
      surfaceBright: Color(0xff483435),
      surfaceContainerLowest: Color(0xff190a0b),
      surfaceContainerLow: Color(0xff281718),
      surfaceContainer: Color(0xff2c1b1c),
      surfaceContainerHigh: Color(0xff372526),
      surfaceContainerHighest: Color(0xff433031),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f9),
      surfaceTint: Color(0xffffb2b7),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffb9bc),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f9),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffffb9bc),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffffaf8),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffbc94),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1e0f10),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9f9),
      outline: Color(0xffe9c1c2),
      outlineVariant: Color(0xffe9c1c2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfffadbdc),
      inversePrimary: Color(0xff5b0017),
      primaryFixed: Color(0xffffdfe0),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb9bc),
      onPrimaryFixedVariant: Color(0xff36000a),
      secondaryFixed: Color(0xffffdfe0),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffffb9bc),
      onSecondaryFixedVariant: Color(0xff36000a),
      tertiaryFixed: Color(0xffffe1d1),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffbc94),
      onTertiaryFixedVariant: Color(0xff2a0f00),
      surfaceDim: Color(0xff1e0f10),
      surfaceBright: Color(0xff483435),
      surfaceContainerLowest: Color(0xff190a0b),
      surfaceContainerLow: Color(0xff281718),
      surfaceContainer: Color(0xff2c1b1c),
      surfaceContainerHigh: Color(0xff372526),
      surfaceContainerHighest: Color(0xff433031),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
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
