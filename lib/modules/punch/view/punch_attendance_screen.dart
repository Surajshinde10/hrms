
import 'package:FaceAxis/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/modules/punch/controller/punching_controller.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/constant_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:FaceAxis/widgets/common_appbar.dart';
import 'package:FaceAxis/widgets/common_button.dart';

// ignore: must_be_immutable
class PunchAttendanceScreen extends GetView<PunchingController> {
  String? userId;
  String? userName;
  PunchAttendanceScreen({this.userName, this.userId,super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(PunchingController());
    final HomeController homeController = Get.put(HomeController());

    final PunchingController punchingController = Get.put(PunchingController());

    return Obx(() => Stack(
      children: [
        Image.asset(AssetUtilities.splash,height: Get.height,width: Get.width,fit: BoxFit.fill,),
        Scaffold(
              backgroundColor: Colors.transparent,
              body: (controller.isLoading.value)
                  ? Center(
                      child: CircularProgressIndicator(
                          color: ColorUtilities.whiteColor),
                    )
                  : Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SingleChildScrollView(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                      "Attendance Marked",
                                      style: FontUtilities.h28(
                                          color: ColorUtilities.whiteColor.withOpacity(0.7),
                                          fontFamily: FontFamily.interMedium,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  if(userName?.isNotEmpty  ?? false)Text("${userName} is Present",
                                    style: FontUtilities.h16(
                                        color: ColorUtilities.whiteColor.withOpacity(0.7),
                                        fontFamily: FontFamily.interLight,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const CommonAppBar(isBackOption: false),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: CommonButton(
                                buttonName: ConstantUtilities.confirm,
                                buttonColor: ColorUtilities.whiteColor.withOpacity(0.9),
                                textColor: ColorUtilities.blackColor,
                                onTap: () {

                                  punchingController.punchInAll(userId.toString());

                                    // controller.punchIn(userId ?? "");
                                },
                              ),
                            )),
                      ],
                    ),
            ),
      ],
    ));
  }
}
