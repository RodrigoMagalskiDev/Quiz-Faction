import 'package:flutter/material.dart';

class MyTextStyle extends TextStyle {
  final Color color;
  final FontWeight fontWeight;
  final double size;

  const MyTextStyle({
    this.color = Colors.teal,
    this.fontWeight = FontWeight.bold,
    this.size = 18,
  })  : assert(color != null && fontWeight != null),
        super(
        color: Colors.teal,
        fontWeight: fontWeight,
        fontSize: 18,
      );
}