import 'package:FaceAxis/modules/home/controller/home_controller.dart';
import 'package:FaceAxis/modules/home/view/camera_view_home_screen.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFaceScreen extends GetView<HomeController> {
  const AddFaceScreen({super.key});

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Get.height * 0.29,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Get.to(CameraViewHomeScreen());
                            // Get.toNamed(Routes.recognition,arguments: {
                            //   "isHome":false,
                            //   "isAdd":false,
                            //   "emp_id":"",
                            // });
                            // controller.getImageFromCamera();
                          },
                          child: Container(
                            width: Get.width * 0.42,
                            height: Get.height * 0.23,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ColorUtilities.colorB9DC7B,
                                border: Border.all(
                                    color: ColorUtilities.blackColor
                                        .withOpacity(0.05))),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AssetUtilities.selectedMenu,
                                  height: Get.width * 0.09,
                                  width: Get.width * 0.09,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    width: Get.width * 0.2,
                                    child: Text(
                                      "Face Recognition",
                                      style: FontUtilities.h14(
                                          color:
                                          ColorUtilities.blackColor,
                                          fontFamily:
                                          FontFamily.interMedium,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                             controller.getImageFromCamera();
                          },
                          child: Container(
                            width: Get.width * 0.42,
                            height: Get.height * 0.23,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: ColorUtilities.whiteColor.withOpacity(0.05),
                                border: Border.all(
                                    color: ColorUtilities.whiteColor
                                        .withOpacity(0.1),width: 0.5)),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AssetUtilities.gallery,
                                  height: Get.width * 0.09,
                                  width: Get.width * 0.09,
                                  fit: BoxFit.fill,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                    width: Get.width * 0.2,
                                    child: Text(
                                      "Click Image",
                                      style: FontUtilities.h14(
                                          color:
                                          ColorUtilities.whiteColor,
                                          fontFamily:
                                          FontFamily.interMedium,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
