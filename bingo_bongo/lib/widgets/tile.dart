import 'package:bingo_bongo/widgets/FloatingTooltip.dart';
import 'package:flutter/material.dart';

class Tile extends StatefulWidget {
  const Tile({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  // instance bool, controls individual tile
  bool _isChecked = false;

  void _toggleColor() {
    setState(() {
      _isChecked = !_isChecked;
    });
  }

  void _showTooltip() {
    FloatingTooltip.showFloatingTooltip(
      context: context,
      messages: 'Tile index: ${widget.index}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: ValueKey("bingo-button-${widget.index}"),
      onLongPress: () => {_toggleColor()},
      onPressed: () => {}, // TODO
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _isChecked ? const Color.fromARGB(255, 94, 201, 96) : Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      child: Text(
        '${widget.index}',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
