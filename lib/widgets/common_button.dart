import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';

import '../utilities/font_utilities.dart';

class CommonButton extends StatelessWidget {
  final String? buttonName;
  final Color? buttonColor;
  final Color? textColor;
  final double? height;
  final Color? borderColor;
  final GestureTapCallback? onTap;
  final double? width;
  final TextStyle? fontStyle;
  const CommonButton({this.fontStyle,this.width,this.height,this.onTap,this.borderColor,this.textColor,this.buttonColor,this.buttonName,super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width,
        decoration: BoxDecoration(
            color: buttonColor ?? ColorUtilities.colorB9DC7B,
            borderRadius: BorderRadius.circular(30),
          border: Border.all(color: borderColor ?? Colors.transparent,width: 1)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(buttonName ?? "",style: fontStyle ?? FontUtilities.h14(color: textColor ?? ColorUtilities.blackColor,fontFamily: FontFamily.interRegular,fontWeight: FontWeight.w400),),
          ),
        ),
      ),
    );
  }
}
