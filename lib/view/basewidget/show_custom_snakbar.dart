import 'package:flutter/material.dart';
import 'package:mechatronia_app/utill/color_resources.dart';

void showCustomSnackBar(String message, BuildContext context, {bool isError = true, Color color = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: isError ? ColorResources.RED : Colors.green,
    duration: Duration(seconds: 6),
    content: Text(message),
  ));
}
