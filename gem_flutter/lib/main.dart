import 'package:flutter/material.dart';
import 'package:gem_flutter/utils/app_router.dart';
import 'package:gem_flutter/utils/global_variables.dart';
import 'package:google_fonts/google_fonts.dart';

/// The main entry point of the application.
void main() {
  runApp(const GemApp());
}

/// The root widget of the application.
class GemApp extends StatelessWidget {
  const GemApp({super.key});

  /// The background color of the app's surface.
  static const surface = Color(0xFFFFFFF3);

  /// The primary color used in MainContainer and FloatingActionButton.
  static const primary = Color(0xFFD9D9D9);

  /// The text color used on primary colored elements.
  static const onPrimary = Color(0xFFFFFFF3);

  /// The secondary color used in CardContainer and FloatingActionButton.
  static const secondary = Color(0xFF647AA3);

  /// The text color used on secondary colored elements.
  static const onSecondary = Color(0xFFFFFFF3);

  /// The fill color used in TextField and InputQuantity.
  static const tertiary = Color(0xFFFFFFF3);

  /// The text color used on tertiary colored elements.
  static const onTertiary = Color(0xFF0A0908);

  // Root of application
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: AppConfiguration.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          surface: surface,
          primary: primary,
          onPrimary: onPrimary,
          secondary: secondary,
          onSecondary: onSecondary,
          tertiary: tertiary,
          onTertiary: onTertiary,
        ),
        textTheme: TextTheme(
          displaySmall: GoogleFonts.barlow(fontSize: 16, height: 1.5),
          displayMedium: GoogleFonts.barlow(fontSize: 20, height: 1.5),
          titleSmall: GoogleFonts.barlow(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.barlow(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.barlow(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
