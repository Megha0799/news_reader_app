import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_reader_app/common/utils/colors.dart';
import 'package:news_reader_app/common/widgets/common_style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String query)? onChanged;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        // horizontal: 10,
         vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        obscuringCharacter: '*',
        keyboardType: keyboardType,
        readOnly: readOnly,
        autofocus: autofocus,
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        style: CustomStyles.regularTextStyle(
          color: AppColor.listtextColor,
          fontSize: CustomStyles.size16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: CustomStyles.regularTextStyle(
            color: AppColor.unselectTextColor,
            fontSize: CustomStyles.size16,
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColor.softAquaColor ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColor.softAquaColor ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColor.softAquaColor),
          ),
        ),
      
      ),
    );
  }
}
