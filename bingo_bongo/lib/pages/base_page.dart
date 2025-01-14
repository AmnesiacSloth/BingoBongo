import 'package:flutter/material.dart';
import 'package:bingo_bongo/widgets/BingoBoard.dart';
import 'package:bingo_bongo/widgets/CustomAppBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      backgroundColor: const Color.fromARGB(221, 36, 32, 32),
      body: BingoBoard(context),
    );
  }
}
