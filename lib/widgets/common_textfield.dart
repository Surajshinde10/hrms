import 'package:flutter/material.dart';

import '../utilities/color_utilities.dart';
import '../utilities/font_utilities.dart';

class CommonTextField extends StatelessWidget {
  final String? textFieldName;
  final String? hintText;
  final bool? isReadOnly;
  final TextEditingController? controller;
  const CommonTextField(
      {this.isReadOnly,
      this.hintText,
      this.controller,
      this.textFieldName,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textFieldName ?? "",
          style: FontUtilities.h16(
              color: ColorUtilities.whiteColor.withOpacity(0.9),
              fontFamily: FontFamily.interRegular,
              fontWeight: FontWeight.w400),
        ),
        Container(
          height: 50,
          child: TextFormField(
            readOnly: isReadOnly ?? false,
            controller: controller,
            cursorColor: ColorUtilities.whiteColor.withOpacity(0.70),
            style: FontUtilities.h16(
                color: ColorUtilities.whiteColor.withOpacity(0.70),
                fontFamily: FontFamily.interLight,decoration: TextDecoration.none,),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 4, left: 10),
              hintText: hintText,

              hintStyle: FontUtilities.h16(
                  color: ColorUtilities.whiteColor.withOpacity(0.50),
                  fontFamily: FontFamily.interLight),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: ColorUtilities.whiteColor.withOpacity(0.50),
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignInside)),
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: ColorUtilities.whiteColor.withOpacity(0.50),
                      width: 0.50,
                      strokeAlign: BorderSide.strokeAlignInside)),
            ),
          ),
        )
      ],
    );
  }
}
