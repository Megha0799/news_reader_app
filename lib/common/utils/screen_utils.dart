import 'package:flutter/material.dart';

class ScreenUtils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getHorizontalSize(BuildContext context, double size) {
    return size * (getScreenWidth(context) / 375.0);
  }

  static double getVerticalSize(BuildContext context, double size) {
    return size * (getScreenHeight(context) / 812.0);
  }

  static double getFontSize(BuildContext context, double size) {
    return getHorizontalSize(context, size);
  }

  // Common padding sizes
  static double get paddingXS => 4.0;
  static double get paddingS => 8.0;
  static double get paddingSL => 12.0;
  static double get paddingM => 16.0;
  static double get paddingL => 24.0;
  static double get paddingXL => 32.0;

  // Common heights for spacing
  static double get heightXS => 4.0;
  static double get heightS => 8.0;
  static double get heightM => 16.0;
  static double get heightL => 24.0;
  static double get heightXL => 32.0;
  static double get heightXXL => 48.0;

  // Common widths for spacing
  static double get widthXS => 4.0;
  static double get widthS => 8.0;
  static double get widthM => 16.0;
  static double get widthL => 24.0;
  static double get widthXL => 32.0;

  // Common border radius
  static double get radiusS => 4.0;
  static double get radiusM => 8.0;
  static double get radiusL => 16.0;
  static double get radiusXL => 24.0;
}
