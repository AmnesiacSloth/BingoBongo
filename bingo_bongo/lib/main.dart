import 'package:bingo_bongo/api/rest.dart';
import 'package:bingo_bongo/pages/startup_page.dart';
import 'package:flutter/material.dart';

// -- Widgets -- //
import 'widgets/CustomAppBar.dart';
import 'widgets/BingoBoard.dart';

final api = RestApi();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bingo Bongo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: StartupPage(),
    );
  }
}
