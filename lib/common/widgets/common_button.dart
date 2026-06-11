import 'package:flutter/material.dart';
import 'package:news_reader_app/common/utils/colors.dart';
import 'package:news_reader_app/common/widgets/common_style.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final double? fontSize;
  final double borderRadius;
  final double? height;
  final double? width;
  final Color? borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry? textPadding;

  const CustomButton({
    super.key,
    this.onPressed,
    required this.text,
    this.buttonColor,
    this.textColor,
    this.borderRadius = 7.16,
    this.height,
    this.width,
    this.borderColor,
    this.borderWidth = 1.0,
    this.fontSize,
    this.textPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height ?? 38.0,
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: buttonColor ?? AppColor.softAquaColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth)
              : null,
        ),
        child: Center(
          child: Padding(
            padding: textPadding ?? EdgeInsets.zero,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: CustomStyles.buttonTextStyle(
                color: textColor ?? AppColor.backgroundColor,
                fontSize: fontSize ?? CustomStyles.size12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
