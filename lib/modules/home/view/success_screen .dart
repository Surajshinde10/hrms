import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/modules/home/controller/home_controller.dart';
import 'package:FaceAxis/modules/home/view/camera_view_home_screen.dart';
import 'package:FaceAxis/routes/app_routes.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/widgets/common_appbar.dart';
import 'package:FaceAxis/widgets/common_button.dart';

class FaceIDAddedSuccessfullyScreen extends GetView<HomeController> {
  String? userId;
   FaceIDAddedSuccessfullyScreen({this.userId,super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AssetUtilities.splash,
          height: Get.height,
          width: Get.width,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Get.height * 0.29,
                      ),
                      Image.asset(
                        AssetUtilities.successfully,
                        height: Get.height * 0.1,
                        width: Get.height * 0.1,
                        fit: BoxFit.fill,
                      ),
                      Container(
                        width: Get.width * 0.7,
                        child: Text(
                          "Face ID added successfully",
                          style: FontUtilities.h28(
                              color: ColorUtilities.colorE8E9E9,
                              fontFamily: FontFamily.interMedium,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text("Employee : ${userId} data added" ?? "",
                        style: FontUtilities.h16(
                            color: ColorUtilities.colorE8E9E9,
                            fontFamily: FontFamily.interLight,
                            fontWeight: FontWeight.w300),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                      CommonButton(
                        buttonName: "Take Attendance",
                        buttonColor: ColorUtilities.whiteColor.withOpacity(0.90),
                        textColor: ColorUtilities.blackColor,
                        onTap: () {
                          Get.to(CameraViewHomeScreen());

                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonButton(
                        buttonName: "Home",
                        buttonColor: Colors.transparent,
                        textColor: ColorUtilities.whiteColor,
                        borderColor: ColorUtilities.whiteColor.withOpacity(0.50),
                        onTap: () {
                          Get.offNamed(Routes.home);
                        },
                      )
                    ],
                  ),
                ),
              ),
              CommonAppBar(
                isBackOption: true,
                onTapIcon: () {
                  controller.punchOut();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
