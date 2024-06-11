// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/presentation/widgets/Pages/welcome_page.dart';
import 'presentation/widgets/Pages/quiz_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quiz App',
        theme: ThemeData(
          dialogTheme: const DialogTheme(
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
            contentTextStyle: TextStyle(color: Colors.white, fontSize: 18),

            backgroundColor: Color(0xFFE91E63), // Pink
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF3F51B5), // Indigo
            secondary: const Color(0xFFE91E63), // Pink
          ),
          scaffoldBackgroundColor: const Color(0xFFFAFAFA), // White
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Color(0xFF212121)), // Dark Gray
            bodyMedium: TextStyle(color: Color(0xFF212121)), // Dark Gray
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF3F51B5), // Text color
            ),
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
            backgroundColor: Color(0xFF3F51B5), // Indigo
          ),
        ),
        home: const WelcomePage());
  }
}
