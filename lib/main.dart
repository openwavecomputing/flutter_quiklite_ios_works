import 'package:flutter/material.dart';

import 'constants/word_constants.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: WordConstants.wAppName,
      debugShowCheckedModeBanner: false,
      home: const SafeArea(
          child: Scaffold(
            body: HomeScreen(), //LeaveRequestListScreen
          )),
    );
  }
}
