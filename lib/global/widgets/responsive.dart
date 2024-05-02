import 'package:flutter/material.dart';

const int largeScreenSize = 1366;
const int mediumScreenSize = 768;
const int smallScreenSize = 360;
const int customScreenSize = 1100;

class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;
  final Widget? customScreen;

  const ResponsiveWidget({
    super.key,
    required this.largeScreen,
    this.mediumScreen,
    this.smallScreen,
    this.customScreen,
  });

  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width < mediumScreenSize;
  static bool isMediumScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= mediumScreenSize &&
      MediaQuery.of(context).size.width < largeScreenSize;
  static bool isLargeScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= largeScreenSize;
  static bool isCustomScreen(BuildContext context) =>
      MediaQuery.of(context).size.width >= mediumScreenSize &&
      MediaQuery.of(context).size.width <= customScreenSize;

  static double defaultPadding(BuildContext context) {
    if (isLargeScreen(context)) {
      return 64;
    } else if (isMediumScreen(context)) {
      return 32;
    } else {
      return 16;
    }
  }

  static double xLargeWidthPadding(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    if (isLargeScreen(context)) {
      return width * 0.40;
    } else if (isMediumScreen(context)) {
      return width * 0.20;
    } else {
      return width * 0.10;
    }
  }

  static double largePadding(BuildContext context) {
    if (isLargeScreen(context)) {
      return 82;
    } else if (isMediumScreen(context)) {
      return 64;
    } else {
      return 24;
    }
  }

  static double mediumPadding(BuildContext context) {
    if (isLargeScreen(context)) {
      return 32;
    } else if (isMediumScreen(context)) {
      return 24;
    } else {
      return 12;
    }
  }

  static double smallPadding(BuildContext context) {
    if (isLargeScreen(context)) {
      return 12;
    } else if (isMediumScreen(context)) {
      return 12;
    } else {
      return 8;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isLargeScreen(context)) {
          return largeScreen;
        } else if (isMediumScreen(context)) {
          return mediumScreen ?? largeScreen;
        } else if (isCustomScreen(context)) {
          return customScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}
