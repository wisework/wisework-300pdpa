import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PdpaThemeData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final _lightFocusColor = Colors.black.withOpacity(0.12);
  static final _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData = themeData(
    lightColorScheme,
    _lightFocusColor,
  );
  static ThemeData darkThemeData = themeData(
    darkColorScheme,
    _darkFocusColor,
  );

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),
      canvasColor: colorScheme.background,
      colorScheme: colorScheme,
      focusColor: colorScheme.secondary,
      highlightColor: Colors.transparent,
      iconTheme: IconThemeData(color: colorScheme.primary),
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: colorScheme.background,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
        contentTextStyle: _textTheme.bodyMedium!.apply(
          color: _darkFillColor,
        ),
      ),
      textTheme: _textTheme,
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0172E6), // primary
    onPrimary: Colors.white,
    secondary: Color(0xFF2F3853), // secondary
    onSecondary: Color(0xFFC9DBFC),
    tertiary: Color(0xFFF0F0F0), // disable field
    onTertiary: Color(0xFF96A7AF), // hint text
    error: Color(0xFFF22525), // error
    onError: Color(0xFFF9C132), // warning
    background: Color(0xFFF9F9F9), // background
    onBackground: Colors.white, // app bar | container | cards | drawer
    surface: Colors.white, // card
    onSurface: Colors.black, // text
    outline: Color(0xFFF0F0F0), // outline 1
    outlineVariant: Color(0xFFC4C4C6), // outline 2
    surfaceTint: Color(0xFF3A9FFD), // splash color
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF0172E6), // primary
    onPrimary: Colors.white,
    secondary: Color(0xFF2F3853), // secondary
    onSecondary: Color(0xFFC9DBFC),
    tertiary: Color(0xFF484848), // disable field
    onTertiary: Color(0xFF96A7AF), // hint text
    error: Color(0xFFF22525), // error
    onError: Color(0xFFF9C132), // warning
    background: Color(0xFF242424), // background
    onBackground: Color(0xFF373737), // app bar | container | cards | drawer
    surface: Color(0xFF373737), // card
    onSurface: Colors.white, // text
    outline: Color(0xFF181818), // outline 1
    outlineVariant: Color(0xFF121212), // outline 2
    surfaceTint: Color(0xFF3A9FFD), // splash color
  );

  static const _light = FontWeight.w400;
  static const _regular = FontWeight.w400;
  static const _semiBold = FontWeight.w500;
  // static const _bold = FontWeight.w600;

  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.ibmPlexSansThai(
      fontWeight: _semiBold,
      fontSize: 32.0,
    ),
    displayMedium: GoogleFonts.ibmPlexSansThai(
      fontWeight: _semiBold,
      fontSize: 30.0,
    ),
    displaySmall: GoogleFonts.ibmPlexSansThai(
      fontWeight: _semiBold,
      fontSize: 28.0,
    ),
    headlineLarge: GoogleFonts.ibmPlexSansThai(
      fontWeight: _semiBold,
      fontSize: 24.0,
    ),
    headlineMedium: GoogleFonts.ibmPlexSansThai(
      fontWeight: _semiBold,
      fontSize: 22.0,
    ),
    headlineSmall: GoogleFonts.ibmPlexSansThai(
      fontWeight: _semiBold,
      fontSize: 20.0,
    ),
    titleLarge: GoogleFonts.ibmPlexSansThai(
      fontWeight: _semiBold,
      fontSize: 18.0,
    ),
    titleMedium: GoogleFonts.ibmPlexSansThai(
      fontWeight: _semiBold,
      fontSize: 16.0,
    ),
    titleSmall: GoogleFonts.ibmPlexSansThai(
      fontWeight: _semiBold,
      fontSize: 14.0,
    ),
    bodyLarge: GoogleFonts.ibmPlexSansThai(
      fontWeight: _regular,
      fontSize: 18.0,
    ),
    bodyMedium: GoogleFonts.ibmPlexSansThai(
      fontWeight: _regular,
      fontSize: 16.0,
    ),
    bodySmall: GoogleFonts.ibmPlexSansThai(
      fontWeight: _regular,
      fontSize: 14.0,
    ),
    labelLarge: GoogleFonts.ibmPlexSansThai(
      fontWeight: _light,
      fontSize: 14.0,
    ),
    labelMedium: GoogleFonts.ibmPlexSansThai(
      fontWeight: _light,
      fontSize: 12.0,
    ),
    labelSmall: GoogleFonts.ibmPlexSansThai(
      fontWeight: _light,
      fontSize: 10.0,
    ),
  );
}
