import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FontUtilities {
  static TextStyle h10(
      {Color? color,
        double? letterSpacing = 1,
        String? fontFamily,
        TextDecoration? decoration,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? Colors.black,
        fontSize: 0.028 * Get.width,
        decoration: decoration,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing);
  }

  static TextStyle? h12(
      {Color? color,
        String? fontFamily,
        double? letterSpacing,
        TextDecoration? decoration,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? Colors.black,
        fontSize: 0.0335 * Get.width,
        decoration: decoration,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        fontWeight: fontWeight);
  }

  static TextStyle h14(
      {Color? color,
        String? fontFamily,
        double? letterSpacing,
        TextDecoration? decoration,
        Color? decorationColor,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color ?? Colors.black,
        fontSize: 0.032 * Get.width,
        letterSpacing: letterSpacing,
        decoration: decoration,
        fontFamily: fontFamily,
        decorationColor: decorationColor,
        fontWeight: fontWeight);
  }

  static TextStyle h16(
      {required Color color,
        String? fontFamily,
        TextDecoration? decoration,
        double? letterSpacing,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color,
        fontSize: 0.04 * Get.width,
        letterSpacing: letterSpacing,
        decorationThickness: 0,
        decoration: decoration,
        fontFamily: fontFamily,
        fontWeight: fontWeight);
  }

  static TextStyle h18(
      {required Color color,
        String? fontFamily,
        TextDecoration? decoration,
        double? letterSpacing,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color,
        fontSize: 0.0425 * Get.width,
        letterSpacing: letterSpacing,
        decoration: decoration,
        fontFamily: fontFamily,
        fontWeight: fontWeight);
  }

  static TextStyle h20(
      {required Color color,
        String? fontFamily,
        double? letterSpacing,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color,
        fontSize: 0.045 * Get.width,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        fontWeight: fontWeight);
  }

  static TextStyle h24(
      {required Color color,
        String? fontFamily,
        double? letterSpacing,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color,
        fontSize: 0.052 * Get.width,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        fontWeight: fontWeight);
  }

  static TextStyle h28(
      {required Color color,
        String? fontFamily,
        double? letterSpacing,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color,
        fontSize: 0.067 * Get.width,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        fontWeight: fontWeight);
  }

  static TextStyle h32(
      {required Color color,
        String? fontFamily,
        double? letterSpacing,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color,
        fontSize: Get.width*0.089,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        fontWeight: fontWeight);
  }

  static TextStyle h40(
      {required Color color,
        String? fontFamily,
        double? letterSpacing,
        FontWeight? fontWeight}) {
    return TextStyle(
        color: color,
        fontSize: Get.width*0.1113,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily,
        fontWeight: fontWeight);
  }
}

class FontFamily {
  static const String interRegular = "InterRegular";
  static const String interBold = "InterBold";
  static const String interMedium = "InterMedium";
  static const String interSemiBold = "InterSemiBold";
  static const String interExtraLight = "InterExtraLight";
  static const String interLight = "InterLight";

}
