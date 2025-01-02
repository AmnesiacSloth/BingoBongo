import 'package:flutter/material.dart';

// Shows a tooltip in a fixed position for a brief period then removes it
class FloatingTooltip {
  static void showFloatingTooltip({
    required BuildContext context,
    required String messages,
  }) {
    bool isRemoved = false;
    // get flutter's overlay
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (BuildContext overlayContext) {
      return GestureDetector(
        onTap: () {
          if (!isRemoved) {
            isRemoved = true;
            overlayEntry.remove();
          }
        },
        // this container wraps the whole screen for gesture detector including appbar
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  messages,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    });

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      if (!isRemoved) {
        isRemoved = true;
        overlayEntry.remove();
      }
    });
  }
}
