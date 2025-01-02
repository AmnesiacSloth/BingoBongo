import 'package:flutter/material.dart';

// Shows a tooltip in a fixed position for a brief period then removes it
class FloatingTooltip {
  static void showFloatingTooltip({
    required BuildContext context,
    required String messages,
  }) {
    // get flutter's overlay
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(builder: (BuildContext overlayContext) {
      return Center(
        child: Material(
          color: const Color.fromARGB(0, 0, 0, 0),
          child: Tooltip(
            message: messages,
            child: Container(
                width: 300,
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  messages,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      );
    });

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
