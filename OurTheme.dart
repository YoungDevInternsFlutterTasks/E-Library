import 'package:flutter/material.dart';

class OurTheme {
  Color const_DarkGreen = Color.fromARGB(255, 1, 195, 204);

  ThemeData buildTheme() {
    return ThemeData(
      canvasColor: const_DarkGreen,
    );
  }

  InputDecoration inputDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(
          color: Theme.of(context).canvasColor,
          width: 2.0,
        ),
      ),
    );
  }
}
