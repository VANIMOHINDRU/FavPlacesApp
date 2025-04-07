import 'package:fav_places_app/screens/places1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 102, 6, 247),
  brightness: Brightness.dark,
  surface: const Color.fromARGB(255, 36, 32, 40),
);
void main() async {
  await dotenv.load(fileName: ".env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
            scaffoldBackgroundColor: colorScheme.surface,
            textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
              titleSmall: GoogleFonts.ubuntuCondensed(
                fontWeight: FontWeight.bold,
              ),
              titleMedium: GoogleFonts.ubuntuCondensed(
                fontWeight: FontWeight.bold,
              ),
              titleLarge: GoogleFonts.ubuntuCondensed(
                fontWeight: FontWeight.bold,
              ),
            )),
        home: const Places1());
  }
}
