import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2), // You can adjust the duration as needed
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}