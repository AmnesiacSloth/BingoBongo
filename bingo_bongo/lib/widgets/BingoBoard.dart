import 'package:flutter/material.dart';

import 'Tile.dart';

class BingoBoard extends StatefulWidget {
  final String gamename;
  final List<int> plays;
  final List<int> layout;
  const BingoBoard({
    Key? key,
    required this.gamename,
    required this.plays,
    required this.layout,
  }) : super(key: key);

  @override
  State<BingoBoard> createState() => _BingoBoardState();
}

class _BingoBoardState extends State<BingoBoard> {
  @override
  Widget build(BuildContext) {
    return Center(
      child: GridView.count(
        shrinkWrap: true,
        padding: EdgeInsets.all(4),
        childAspectRatio: .5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        crossAxisCount: 5,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(25, (index) {
          return Tile(index: index);
        }),
      ),
    );
  }
}
