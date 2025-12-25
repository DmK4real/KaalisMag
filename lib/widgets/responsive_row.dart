import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';

class ResponsiveRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double gap;
  final CrossAxisAlignment crossAxisAlignment;
  final int leftFlex;
  final int rightFlex;
  final double collapseBelow;

  const ResponsiveRow({
    super.key,
    required this.left,
    required this.right,
    this.gap = 16,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.collapseBelow = Breakpoints.tablet,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final collapse = width < collapseBelow;

    if (collapse) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          left,
          SizedBox(height: gap),
          right,
        ],
      );
    }

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Expanded(flex: leftFlex, child: left),
        SizedBox(width: gap),
        Expanded(flex: rightFlex, child: right),
      ],
    );
  }
}
