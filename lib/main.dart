import 'package:flutter/material.dart';
import 'screens/main_navigation_screen.dart';

// SafeHer - Girls' Safety Application
//
// Entry point for the application.
// In Flutter, execution starts with the `main()` function, which calls `runApp()`.
//
// Highlights:
// - Material 3 Modern Design System
// - Accessible typography & high-contrast red SOS actions
// - Clean structure with zero fake alerts or automatic SOS calls

void main() {
  // Ensures all Flutter engine bindings are initialized before app startup
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SafeHerApp());
}

class SafeHerApp extends StatelessWidget {
  const SafeHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeHer',
      debugShowCheckedModeBanner: false,

      // Modern Material 3 Theme with a thoughtful, accessible palette
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD81B60), // Protective Rose / Magenta
          primary: const Color(0xFFD81B60),
          secondary: const Color(0xFF8E24AA), // Deep Purple
          surface: const Color(0xFFFAFAFA),
        ),

        // Accessible, legible typography
        fontFamily: null, // Uses standard Android system font (Roboto)
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.15,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
          ),
          bodyLarge: TextStyle(fontSize: 15, letterSpacing: 0.25),
          bodyMedium: TextStyle(fontSize: 14, letterSpacing: 0.25),
        ),

        // Consistent AppBar styling
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Accessible button target styling
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFD81B60),
            foregroundColor: Colors.white,
            minimumSize: const Size(88, 48), // Accessible touch target
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Card theme
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // The root screen with bottom navigation tabs
      home: const MainNavigationScreen(),
    );
  }
}
