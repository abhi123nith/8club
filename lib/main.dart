import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF151515), // base2
          titleTextStyle: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFFFFFF),
            height: 36 / 28,
            letterSpacing: -0.84,
          ),
        ),
        // Use Space Grotesk as the base text theme across the app
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const ExperienceSelectionScreen(),
    );
  }
}
