import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspots_hostes/screens/experience_selection_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotspot Hosts Onboarding',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101010), // base1
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF151515), // base2
          titleTextStyle: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
            height: 1.28, // 36px line height / 28px font size
            letterSpacing: -0.84, // -3% of 28px
          ),
        ),
        textTheme: const TextTheme(
          // Heading/H1-bold
          headlineLarge: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
            height: 1.28, // 36px line height / 28px font size
            letterSpacing: -0.84, // -3% of 28px
          ),
          // Heading/H1-regular
          headlineMedium: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 28,
            fontWeight: FontWeight.normal,
            color: Color(0xFFFFFFFF),
            height: 1.28, // 36px line height / 28px font size
            letterSpacing: -0.84, // -3% of 28px
          ),
          // Heading/H2-bold
          headlineSmall: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
            height: 1.25, // 30px line height / 24px font size
            letterSpacing: -0.48, // -2% of 24px
          ),
          // Heading/H2-regular
          titleLarge: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 24,
            fontWeight: FontWeight.normal,
            color: Color(0xFFFFFFFF),
            height: 1.25, // 30px line height / 24px font size
            letterSpacing: -0.48, // -2% of 24px
          ),
          // Heading/H3-bold
          titleMedium: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
            height: 1.3, // 26px line height / 20px font size
            letterSpacing: -0.2, // -1% of 20px
          ),
          // Heading/H3-regular
          titleSmall: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Color(0xFFFFFFFF),
            height: 1.3, // 26px line height / 20px font size
            letterSpacing: -0.2, // -1% of 20px
          ),
          // Body/B1-bold
          bodyLarge: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
            height: 1.5, // 24px line height / 16px font size
            letterSpacing: 0,
          ),
          // Body/B1-regular
          bodyMedium: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFFFFFFFF),
            height: 1.5, // 24px line height / 16px font size
            letterSpacing: 0,
          ),
          // Body/B2-bold
          bodySmall: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
            height: 1.42, // 20px line height / 14px font size
            letterSpacing: 0,
          ),
          // Body/B2-regular
          labelLarge: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Color(0xFFFFFFFF),
            height: 1.42, // 20px line height / 14px font size
            letterSpacing: 0,
          ),
          // Subtext/S1-bold
          labelMedium: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
            height: 1.33, // 16px line height / 12px font size
            letterSpacing: 0,
          ),
          // Subtext/S1-regular
          labelSmall: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Color(0xFFFFFFFF),
            height: 1.33, // 16px line height / 12px font size
            letterSpacing: 0,
          ),
        ),
      ),
      home: const ExperienceSelectionScreen(),
    );
  }
}
