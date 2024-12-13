import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
  const NoAnimationPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class MaterialTheme {
  static TextTheme textTheme = const TextTheme();

  static final pageTransitionsTheme = const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.macOS: NoAnimationPageTransitionsBuilder(),
      TargetPlatform.windows: NoAnimationPageTransitionsBuilder(),
    },
  );
  MaterialTheme() {
    TextTheme baseTextTheme = GoogleFonts.notoSansTextTheme();
    textTheme = baseTextTheme.copyWith(
      bodyLarge: baseTextTheme.bodyLarge,
      bodyMedium: baseTextTheme.bodyMedium,
      bodySmall: baseTextTheme.bodySmall,
      labelLarge: baseTextTheme.labelLarge,
      labelMedium: baseTextTheme.labelMedium,
      labelSmall: baseTextTheme.labelSmall,
    );
  }

  static ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff8e0028),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8e0028),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffa53846),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffff8c95),
      onSecondaryContainer: Color(0xff4e0012),
      tertiary: Color(0xff8e0028),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffF8D9D8),
      onTertiaryContainer: Color(0xffA14442),
      error: Color(0xffB00020),
      onError: Color(0xffffffff),
      errorContainer: Color(0xfffcd8df),
      onErrorContainer: Color(0xff370b1e),
      surface: Color(0xffEDEEEF),
      onSurface: Color(0xff23272A),
      surfaceTint: Color(0xffC6C6CB),
      outline: Color(0xff906f70),
      outlineVariant: Color(0xffe4bdbe),
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
      surfaceDim: Color(0xffEDEEEF),
      surfaceBright: Color(0xffEDEEEF),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffFAFBFC),
      surfaceContainer: Color(0xffEDEEEF),
      surfaceContainerHigh: Color(0xffffffff),
      surfaceContainerHighest: Color(0xffffffff),
    );
  }

  static ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb2b7),
      onPrimary: Color(0xff67001b),
      primaryContainer: Color(0xffffb2b7),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffffb2b7),
      onSecondary: Color(0xff67001b),
      secondaryContainer: Color(0xffc24e5b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xffffb2b7),
      onTertiary: Color(0xff67001b),
      tertiaryContainer: Color(0xff005252),
      onTertiaryContainer: Color(0xffE3B1AF),
      error: Color(0xffCF6679),
      onError: Color(0xff1C1C1C),
      errorContainer: Color(0xffB00020),
      onErrorContainer: Color(0xffFCD8DF),
      surface: Color(0xff454654),
      onSurface: Color(0xffffffff),
      surfaceTint: Color(0xff454654),
      outline: Color(0xffab8889),
      outlineVariant: Color(0xff5b3f41),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffffffff),
      inversePrimary: Color(0xff454654),
      primaryFixed: Color(0xff454654),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xffA1B4C5),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4D6664),
      onSecondaryFixed: Color(0xffBEE0DD),
      secondaryFixedDim: Color(0xff8AA8A5),
      onSecondaryFixedVariant: Color(0xffBEE0DD),
      tertiaryFixed: Color(0xff6F3F3E),
      onTertiaryFixed: Color(0xffE3B1AF),
      tertiaryFixedDim: Color(0xffD38885),
      onTertiaryFixedVariant: Color(0xffE3B1AF),
      surfaceDim: Color(0xff313C48),
      surfaceBright: Color(0xff454654),
      surfaceContainerLowest: Color(0xff454654),
      surfaceContainerLow: Color(0xff454654),
      surfaceContainer: Color(0xff454654),
      surfaceContainerHigh: Color(0xff1F202C),
      surfaceContainerHighest: Color(0xff454654),
    );
  }

  static ShapeBorder get shapeMedium => RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      );

  static CardTheme cardTheme(ColorScheme scheme) {
    return CardTheme(
      elevation: 0,
      shape: shapeMedium,
      clipBehavior: Clip.antiAlias,
      color: scheme.surfaceContainerHigh,
    );
  }

  static ListTileThemeData listTileTheme(ColorScheme scheme) {
    return ListTileThemeData(
      shape: shapeMedium,
      selectedColor: scheme.secondary,
    );
  }

  static AppBarTheme appBarTheme(ColorScheme scheme) {
    return AppBarTheme(
      elevation: 0,
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
    );
  }

  static TabBarTheme tabBarTheme(ColorScheme scheme) {
    return TabBarTheme(
      labelColor: scheme.secondary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          return states.contains(WidgetState.focused) ? null : Colors.transparent;
        },
      ),
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: scheme.secondary,
            width: 2,
          ),
        ),
      ),
    );
  }

  static BottomAppBarTheme bottomAppBarTheme(ColorScheme scheme) {
    return BottomAppBarTheme(
      color: scheme.surface,
      elevation: 0,
    );
  }

  // static BottomNavigationBarThemeData bottomNavigationBarTheme(ColorScheme scheme) {
  //   return BottomNavigationBarThemeData(
  //     type: BottomNavigationBarType.fixed,
  //     backgroundColor: scheme.surfaceContainerHighest,
  //     selectedItemColor: scheme.onSurface,
  //     unselectedItemColor: scheme.onSurfaceVariant,
  //     elevation: 0,
  //     landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
  //   );
  // }

  static NavigationRailThemeData navigationRailTheme(ColorScheme scheme) {
    return const NavigationRailThemeData();
  }

  static DrawerThemeData drawerTheme(ColorScheme scheme) {
    return DrawerThemeData(
      backgroundColor: scheme.surface,
    );
  }

  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: pageTransitionsTheme,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        cardTheme: cardTheme(colorScheme),
        listTileTheme: listTileTheme(colorScheme),
        appBarTheme: appBarTheme(colorScheme),
        tabBarTheme: tabBarTheme(colorScheme),
        bottomAppBarTheme: bottomAppBarTheme(colorScheme),
        navigationRailTheme: navigationRailTheme(colorScheme),
        drawerTheme: drawerTheme(colorScheme),
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
  static const activityColor = ExtendedColor(
    seed: Color(0xff940200),
    value: Color(0xff940200),
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
      color: Color(0xffff6361),
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
  static const weightColor = ExtendedColor(
    seed: Color(0xffca5200),
    value: Color(0xffca5200),
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
      color: Color(0xffff8531),
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
  static const stepColor = ExtendedColor(
    seed: Color(0xff4b2b4e),
    value: Color(0xff4b2b4e),
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
      color: Color(0xff8a508f),
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
        activityColor,
        weightColor,
        stepColor,
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
