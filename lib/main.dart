import 'package:chat_lipeo/screen/welcome/welcome_screen.dart';
import 'package:chat_lipeo/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Material",
      theme: AppTheme(selectedColor: 4).theme(),
      home: const WelcomeScreen(),
    );
  }
}
