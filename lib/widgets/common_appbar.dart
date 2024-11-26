import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CommonAppBar extends StatelessWidget {
  final bool? isBackOption;
  final GestureTapCallback? onTapIcon;
  const CommonAppBar({this.onTapIcon, this.isBackOption, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.25,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: FontUtilities.h40(
                            color: ColorUtilities.whiteColor,
                            fontFamily: FontFamily.interExtraLight,
                            fontWeight: FontWeight.w200),
                      ),
                      Row(
                        children: [
                          if (isBackOption ?? false)
                            GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: ColorUtilities.whiteColor,
                                )),
                          if (isBackOption ?? false)
                            SizedBox(
                              width: 10,
                            ),
                          CircleAvatar(
                            radius: Get.width * 0.08,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Text(
                                    VariableUtilities.storage.read(
                                            KeyUtilities.name) ??
                                        "",
                                    maxLines: 2,
                                    style: FontUtilities.h24(
                                        color: ColorUtilities
                                            .colorEDFFCD,
                                        fontFamily:
                                            FontFamily.interRegular,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Text(
                                  VariableUtilities.storage.read(
                                          KeyUtilities
                                              .employeeCode) ??
                                      "",
                                  style: FontUtilities.h14(
                                    color: ColorUtilities.whiteColor
                                        .withOpacity(0.80),
                                    fontFamily: FontFamily.interLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                      onTap: onTapIcon,
                      child: Container(
                          height: Get.width * 0.12,
                          width: Get.width * 0.12,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorUtilities.whiteColor
                                  .withOpacity(0.15)),
                          child: Center(
                              child: Image.asset(
                                  AssetUtilities.logout,
                                  height: Get.width * 0.07,
                                  width: Get.width * 0.045,
                                  fit: BoxFit.fill)))),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                DateFormat("E, dd MMM").format(DateTime.now()),
                style: FontUtilities.h16(
                    color: ColorUtilities.whiteColor,
                    fontFamily: FontFamily.interLight,
                    fontWeight: FontWeight.w300),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 2,
                  backgroundColor:
                      ColorUtilities.whiteColor.withOpacity(0.50),
                ),
                Expanded(
                    child: Container(
                  height: 0.5,
                  color: ColorUtilities.whiteColor.withOpacity(0.50),
                )),
                CircleAvatar(
                  radius: 2,
                  backgroundColor:
                      ColorUtilities.whiteColor.withOpacity(0.50),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
