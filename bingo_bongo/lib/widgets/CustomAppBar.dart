import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;
  final int gamecode;
  const CustomAppBar({
    Key? key,
    this.height = 80,
    required this.title,
    required this.gamecode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      leadingWidth: 100,
      leading: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text('Game code : $gamecode'),
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
      actions: [
        Icon(size: 35, Icons.leaderboard),
        Icon(size: 35, Icons.person),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
