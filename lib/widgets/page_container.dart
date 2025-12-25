import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../responsive/responsive.dart';

class PageContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? maxWidth;
  final bool useSafeArea;

  const PageContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 36),
    this.maxWidth = 1220,
    this.useSafeArea = false,
  });

  double _clampHorizontal(BuildContext context, double inset) {
    if (isMobile(context)) {
      return math.min(inset, 20);
    }
    if (isTablet(context)) {
      return math.min(inset, 28);
    }
    return inset;
  }

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = padding.resolve(Directionality.of(context));
    final effectivePadding = EdgeInsets.fromLTRB(
      _clampHorizontal(context, resolvedPadding.left),
      resolvedPadding.top,
      _clampHorizontal(context, resolvedPadding.right),
      resolvedPadding.bottom,
    );

    Widget content = Align(
      alignment: Alignment.center,
      child: Container(
        constraints: maxWidth != null
            ? BoxConstraints(maxWidth: maxWidth!)
            : const BoxConstraints(),
        padding: effectivePadding,
        child: child,
      ),
    );

    if (!useSafeArea) return content;
    return SafeArea(
      left: true,
      right: true,
      top: false,
      bottom: false,
      child: content,
    );
  }
}
