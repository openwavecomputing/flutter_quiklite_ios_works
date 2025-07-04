import 'package:flutter/material.dart';
import 'package:quiklite_ios_works/services/quiklite_service.dart';

import 'constants/word_constants.dart';
import 'home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
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
