import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_reader_app/common/utils/colors.dart';


class CustomStyles {
  // font Weights
  static const thinFontWeight = FontWeight.w100;
  static const extraLightFontWeight = FontWeight.w200;
  static const lightFontWeight = FontWeight.w300;
  static const regularFontWeight = FontWeight.w400;
  static const mediumFontWeight = FontWeight.w500;
  static const semiboldFontWeight = FontWeight.w600;
  static const boldFontWeight = FontWeight.w700;
  static const extraBoldFontWeight = FontWeight.w800;
  static const blackFontWeight = FontWeight.w900;

  // fonts
  static const primaryFont = 'Urbanist';

  // font sizes
  static const size10 = 10.0;
  static const size11 = 11.0;
  static const size12 = 12.0;
  static const size13 = 13.0;
  static const size14 = 14.0;
  static const size15 = 15.0;
  static const size16 = 16.0;
  static const size17 = 17.0;
  static const size18 = 18.0;
  static const size19 = 19.0;
  static const size20 = 20.0;
  static const size21 = 21.0;
  static const size22 = 22.0;
  static const size23 = 23.0;
  static const size24 = 24.0;
  static const size25 = 25.0;
  static const size26 = 26.0;
  static const size27 = 27.0;
  static const size28 = 28.0;
  static const size29 = 29.0;
  static const size30 = 30.0;
  static const size31 = 31.0;
  static const size32 = 32.0;
  static const size33 = 33.0;
  static const size34 = 34.0;
  static const size35 = 35.0;
  static const size36 = 36.0;
  static const size37 = 37.0;
  static const size38 = 38.0;
  static const size39 = 39.0;
  static const size40 = 40.0;

  // font styles

  static TextStyle lightTextStyle({
    double fontSize = CustomStyles.size12,
    FontWeight fontWeight = CustomStyles.lightFontWeight,
    Color color = AppColor.backgroundColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.2,
  }) {
    return GoogleFonts.getFont(
      fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle regularTextStyle({
    double fontSize = CustomStyles.size14,
    FontWeight fontWeight = CustomStyles.regularFontWeight,
    Color color = AppColor.backgroundColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.2,
  }) {
    return GoogleFonts.getFont(
      fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle mediumTextStyle({
    double fontSize = size14,
    FontWeight fontWeight = CustomStyles.mediumFontWeight,
    Color color = AppColor.backgroundColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.2,
  }) {
    return GoogleFonts.getFont(
      fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle semiboldTextStyle({
    double fontSize = size18,
    FontWeight fontWeight = CustomStyles.semiboldFontWeight,
    Color color = AppColor.textPrimaryColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.2,
  }) {
    return GoogleFonts.getFont(
      fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle boldTextStyle({
    double fontSize = size18,
    FontWeight fontWeight = CustomStyles.boldFontWeight,
    Color color = AppColor.textPrimaryColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.2,
  }) {
    return GoogleFonts.getFont(
      fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle buttonTextStyle({
    double fontSize = size14,
    FontWeight fontWeight = CustomStyles.semiboldFontWeight,
    Color color = AppColor.backgroundColor,
    String fontFamily = primaryFont,
    double letterSpacing = 0,
    double height = 1.2,
  }) {
    return GoogleFonts.getFont(
      fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
}
