import 'package:flutter/material.dart';

import 'breakpoints.dart';

enum DeviceType { mobile, tablet, desktop }

DeviceType deviceType(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < Breakpoints.mobile) return DeviceType.mobile;
  if (width < Breakpoints.tablet) return DeviceType.tablet;
  return DeviceType.desktop;
}

bool isMobile(BuildContext context) => deviceType(context) == DeviceType.mobile;
bool isTablet(BuildContext context) => deviceType(context) == DeviceType.tablet;
bool isDesktop(BuildContext context) => deviceType(context) == DeviceType.desktop;
