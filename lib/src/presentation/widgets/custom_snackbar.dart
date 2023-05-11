import 'package:flutter/material.dart';

class CustomSnackBar {
  static buildSnackBar(
    String message,
    Color bgColor,
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: bgColor,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        )));
  }
}
