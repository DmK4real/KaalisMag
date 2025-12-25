import 'package:flutter/material.dart';

double fluid(
  BuildContext context, {
  required double min,
  required double max,
  double minWidth = 360,
  double maxWidth = 1200,
}) {
  final width = MediaQuery.of(context).size.width;
  final t = ((width - minWidth) / (maxWidth - minWidth)).clamp(0.0, 1.0);
  return min + (max - min) * t;
}
