import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/modules/punch/controller/punching_controller.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/widgets/common_button.dart';
import 'dart:math' as math;

import '../../home/controller/home_controller.dart';


class CamerViewPunchScreen extends GetView<PunchingController> {
   CamerViewPunchScreen({super.key});



   @override
  Widget build(BuildContext context) {
    return Obx(()=>Stack(
      children: [
        Image.asset(AssetUtilities.splash,height: Get.height,width: Get.width,fit: BoxFit.fill,),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: (controller.isInitializedCamera.value)
              ? (controller.cameraController.value.isInitialized)
              ? SizedBox(
            height: Get.height,
            width: Get.width,
            child: buildCameraPreview(),
          )
              : Container()
              : Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Get.width*0.9,
                height: Get.height*0.32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorUtilities.whiteColor.withOpacity(0.2)
                ),
                margin: const EdgeInsets.only(top: 100),
                child: Image.asset(
                  AssetUtilities.recognitionLogo,
                  width: Get.width - 100,
                  height: Get.width - 100,
                ),
              ),
              Container(
                height: 50,
              ),
              //TODO section which displays buttons for choosing and capturing images
              (controller.isLoading.value == true)
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Text(
                    "Loading....",
                    style: FontUtilities.h18(
                        color: ColorUtilities.whiteColor,
                        fontFamily: FontFamily.interBold),
                  ),
                ),
              )
                  : (controller.isFaceDetect.value==true)
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: CommonButton(
                  onTap: () {
                    controller.initializeCamera();
                  },
                  buttonName: "Add Facee",
                  width: Get.width * 0.8,
                ),
              )
                  : Container(
                margin: const EdgeInsets.only(bottom: 100),
                child: InkWell(
                  onTap: () {
                    controller.initializeCamera();
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                          radius: 35,
                          backgroundColor: ColorUtilities.whiteColor.withOpacity(0.05),
                          child:Image.asset(AssetUtilities.unSelectedMenu,height: 35,width: 35,fit: BoxFit.fill,)
                      ),
                      SizedBox(height: 10,),
                      Text("Tap here to scan face",style: FontUtilities.h16(color: ColorUtilities.whiteColor.withOpacity(0.7),fontFamily: FontFamily.interMedium),)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    ));
  }
  Widget buildCameraPreview() {
    final isFrontCamera =
        controller.cameraController.value.description.lensDirection ==
            CameraLensDirection.front;

    // If it's the front camera, apply a flip transformation to avoid mirror effect.
    return isFrontCamera
        ? Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(math.pi), // Flip horizontally
      child: CameraPreview(controller.cameraController),
    )
        : CameraPreview(controller.cameraController);
  }
}



