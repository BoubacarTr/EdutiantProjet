import 'package:flutter/material.dart';
import 'HomePage.dart';

void main() {
  runApp(const MyApp()); // ✅ ajouter const
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // ✅ constructeur const ajouté

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion des Etudiants',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
      ),
      home: const HomePage(), // ✅ ajouter const
    );
  }
}