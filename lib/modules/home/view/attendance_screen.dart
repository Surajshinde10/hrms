import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/modules/home/controller/home_controller.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/constant_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/widgets/common_appbar.dart';
import 'package:FaceAxis/widgets/common_button.dart';
import 'package:FaceAxis/widgets/common_dropdown_field.dart';
import 'package:FaceAxis/widgets/common_snackbar.dart';
import 'package:FaceAxis/widgets/common_textfield.dart';

// ignore: must_be_immutable
class AttendanceScreen extends GetView<HomeController> {
  bool isRecognition;
  String? userId;
  String? userName;
  AttendanceScreen(
      {required this.isRecognition, this.userId, this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
      children: [
        Image.asset(
          AssetUtilities.splash,
          height: Get.height,
          width: Get.width,
          fit: BoxFit.fill,
        ),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: Get.height * 0.25,
                                ),
                                (isRecognition)
                                    ? Container()
                                    : controller.selectedImagePath.value.isEmpty
                                        ? const SizedBox(
                                            height: 150,
                                            width: 400,
                                            child: Center(
                                                child: Text('No image selected.')))
                                        : Center(
                                            child: Image.file(
                                              File(controller
                                                  .selectedImagePath.value),
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                if (isRecognition)
                                  Image.asset(
                                    AssetUtilities.successfully,
                                    height: Get.height * 0.1,
                                    width: Get.height * 0.1,
                                    fit: BoxFit.fill,
                                  ),
                                if (isRecognition)
                                  Container(
                                    width: Get.width * 0.7,
                                    child: Text(
                                      "Attendance Marked",
                                      style: FontUtilities.h28(
                                          color: ColorUtilities.colorE8E9E9,
                                          fontFamily: FontFamily.interMedium,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                if (isRecognition)
                                  Text(
                                    "$userName is Present"?? "",
                                    style: FontUtilities.h16(
                                        color: ColorUtilities.colorE8E9E9,
                                        fontFamily: FontFamily.interLight,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.center,
                                  ),
                                if (isRecognition == false)
                                  CommonTextField(
                                      textFieldName: "Employee Id",
                                      hintText: "Employee Id",
                                      controller: controller.employeeIdController),
                                const SizedBox(
                                  height: 10,
                                ),
                                CommonDropDownField(
                                  onTileTap: (val) {
                                    controller.statusValue.value =
                                        controller.statusList[val];
                                    controller.isStatusDropDownOpen.value =
                                        !controller.isStatusDropDownOpen.value;
                                  },
                                  onIconTap: () {
                                    controller.isStatusDropDownOpen.value =
                                        !controller.isStatusDropDownOpen.value;
                                  },
                                  dataList: controller.statusList,
                                  title: "Working Status",
                                  isValueSelected:
                                      controller.isStatusDropDownOpen.value,
                                  selectedValue: controller.statusValue.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                        CommonAppBar(
                          isBackOption: false,
                          onTapIcon: () {
                            controller.punchOut();
                          },
                        ),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: CommonButton(
                                buttonName: ConstantUtilities.confirm,
                                buttonColor: ColorUtilities.whiteColor.withOpacity(0.9),
                                textColor: ColorUtilities.blackColor,
                                onTap: () {
                                  if (isRecognition == false) {
                                    if (controller.selectedImagePath.isEmpty) {
                                      AppSnackBar.customSnackBar(
                                          message: "Please Select Image",
                                          isError: true);
                                    } else if (controller
                                        .employeeIdController.text.isEmpty) {
                                      AppSnackBar.customSnackBar(
                                          message: "Please Employee ID",
                                          isError: true);
                                    } else {
                                      controller.punchInAll(userId.toString());
                                    }
                                  } else {
                                    controller.punchInAll(userId.toString());
                                    // controller.punchIn(userId ?? "");
                                  }
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
