import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constant.dart';
import '../constants/sizeConstant.dart';

TextFormField getTextField({
  String? hintText,
  String? labelText,
  double labelTextSize = 15,
  TextEditingController? textEditingController,
  Widget? prefixIcon,
  double? borderRadius,
  Widget? suffixIcon,
  double? size = 70,
  Widget? suffix,
  Color? borderColor,
  Color? fillColor,
  Color? hintColor,
  bool isFilled = false,
  Color? labelColor,
  TextInputType textInputType = TextInputType.name,
  TextInputAction textInputAction = TextInputAction.next,
  bool textVisible = false,
  bool readOnly = false,
  VoidCallback? onTap,
  int maxLine = 1,
  int? maxLength,
  String errorText = "",
  // Function(String)? onChange,
  FormFieldValidator<String>? validation,
  double fontSize = 15,
  double hintFontSize = 14,
  bool inlineBorder = false,
  double? topPadding,
  double? leftPadding,
  FocusNode? focusNode,
  void Function(String)? onChanged,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) {
  return TextFormField(
    controller: textEditingController,
    obscureText: textVisible,
    textInputAction: textInputAction,
    keyboardType: textInputType,
    focusNode: focusNode,
    textCapitalization: textCapitalization,
    cursorColor: appTheme.textGreyColor,
    readOnly: readOnly,
    validator: validation,
    onTap: onTap,
    maxLines: maxLine,
    onChanged: onChanged,
    style: TextStyle(
      fontSize: MySize.getHeight(fontSize),
    ),
    maxLength: maxLength ?? null,
    decoration: InputDecoration(
      fillColor: fillColor ?? appTheme.textGreyColor,
      // isDense: inlineBorder,
      filled: isFilled,
      labelText: labelText,
      counterText: "",
      labelStyle: TextStyle(
          color: labelColor ?? (appTheme.textGreyColor),
          fontSize: MySize.getHeight(labelTextSize),
          fontWeight: FontWeight.w600),
      enabledBorder: (inlineBorder)
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ?? Color(0xff262626).withOpacity(0.5)))
          : OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? (appTheme.textGreyColor),
              ),
              borderRadius: BorderRadius.circular(
                  (borderRadius == null) ? MySize.getHeight(30) : borderRadius),
            ),
      focusedBorder: (inlineBorder)
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ?? Color(0xff262626).withOpacity(0.5)))
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  (borderRadius == null) ? MySize.getHeight(30) : borderRadius),
              borderSide: BorderSide(
                color: borderColor ?? (appTheme.textGreyColor),
              ),
            ),
      errorBorder: (inlineBorder)
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ?? Color(0xff262626).withOpacity(0.5)))
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  (borderRadius == null) ? MySize.getHeight(30) : borderRadius),
              borderSide: BorderSide(
                color: borderColor ?? (appTheme.textGreyColor),
              ),
            ),
      border: (inlineBorder)
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ?? Color(0xff262626).withOpacity(0.5)))
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  (borderRadius == null) ? MySize.getHeight(30) : borderRadius),
            ),
      contentPadding: EdgeInsets.only(
        left: (inlineBorder) ? -30 : MySize.getWidth(20),
        right: MySize.getWidth(10),
        bottom: (inlineBorder) ? MySize.getHeight(0) : size! / 2, //
        top: (inlineBorder)
            ? MySize.getHeight(topPadding ?? 0)
            : 0, // HERE THE IMPORTANT PART
      ),
      prefixIconConstraints:
          inlineBorder ? BoxConstraints(minWidth: leftPadding ?? 0) : null,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffix: suffix,
      errorMaxLines: 2,
      errorText: (isNullEmptyOrFalse(errorText)) ? null : errorText,
      hintText: hintText,
      hintStyle: TextStyle(
          fontSize: MySize.getHeight(hintFontSize),
          color: hintColor ?? appTheme.greyColor),
    ),
  );
}
