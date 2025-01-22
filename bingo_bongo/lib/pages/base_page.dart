import 'package:flutter/material.dart';
import 'package:bingo_bongo/widgets/BingoBoard.dart';
import 'package:bingo_bongo/widgets/CustomAppBar.dart';

class BasePage extends StatelessWidget {
  const BasePage({super.key, required this.title, required this.gamecode});

  final String title;
  final int gamecode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,
        gamecode: gamecode,
      ),
      backgroundColor: const Color.fromARGB(221, 36, 32, 32),
      body: BingoBoard(
        gamename: "gamename",
        plays: [],
        layout: [],
      ),
    );
  }
}
