import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 1100;
  static Size screenSize(BuildContext context) => MediaQuery.of(context).size;
}
