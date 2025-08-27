import 'package:flutter/material.dart';

import 'features/crisis_card/presentation/pages/crisis_card.dart';
import 'features/setting/settings.dart';
// Make sure this import path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorryMate - Crisis Card Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: SettingsPage(), // This is our new demo screen
    );
  }}
