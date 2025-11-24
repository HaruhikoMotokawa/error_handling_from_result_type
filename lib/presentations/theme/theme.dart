import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ThemeData createThemeData(Color seedColor, Brightness brightness) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
    // INFO: パキッとさせたいから、surfaceは白にしている
    surface: brightness == Brightness.light ? Colors.white : null,
    // INFO: パキッとさせたいから、primaryはseedColorにしている
    primary: brightness == Brightness.light ? seedColor : null,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: brightness,
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: brightness,
      primaryColor: CupertinoColors.activeBlue,
    ),
    typography: Typography.material2021(
      platform: defaultTargetPlatform,
      colorScheme: colorScheme,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surface,
    ),
  );
}
