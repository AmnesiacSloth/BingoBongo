import 'package:flutter/material.dart';

import 'Tile.dart';

Center BingoBoard(BuildContext context) {
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
