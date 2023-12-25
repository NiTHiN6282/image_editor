import 'package:flutter/material.dart';

void unFocus() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void showSnackBar({
  required BuildContext context,
  required String text,
  Color backgroundColor = Colors.grey,
  Color textColor = Colors.black,
}) {
  if (context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          content: Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ),
      );
  }
}
