import 'package:FaceAxis/modules/home/controller/home_controller.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/constant_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/widgets/common_appbar.dart';
import 'package:FaceAxis/widgets/common_button.dart';
import 'package:FaceAxis/widgets/common_snackbar.dart';
import 'package:FaceAxis/widgets/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AbsentScreen extends GetView<HomeController> {
  const AbsentScreen({super.key});

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
          body: Obx(()=>(controller.isLoading.value)?Center(child:  CircularProgressIndicator(color: ColorUtilities.whiteColor,),):Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.25,
                      ),
                      Container(
                        width: Get.width * 0.7,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Employee Status",
                          style: FontUtilities.h28(
                              color: ColorUtilities.whiteColor,
                              fontFamily: FontFamily.interMedium,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 15,),
                      CommonTextField(
                          textFieldName: "Employee Id",
                          hintText: "Enter Employee Id",
                          controller: controller.employeeIdController),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonTextField(
                          textFieldName: "Status",
                          hintText: "absent",
                          isReadOnly: true,
                          controller: controller.statusController),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonTextField(
                          textFieldName: "Reason",
                          hintText: "Enter Reason",
                          controller: controller.changeStatusController),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonButton(
                        width: Get.width*0.5,
                        buttonName: "Add SL Certificate",
                        buttonColor: ColorUtilities.colorB9DC7B,
                        textColor: ColorUtilities.blackColor,
                        onTap: (){
                          controller.openFileExplorer();
                        },
                      )
                    ],
                  ),
                ),
              ),
              CommonAppBar(isBackOption: true,
                onTapIcon: (){
                controller.punchOut();
              },),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CommonButton(
                      buttonName: ConstantUtilities.confirm,
                      buttonColor: ColorUtilities.whiteColor.withOpacity(0.90),
                      textColor: ColorUtilities.blackColor,
                      onTap: () {
                        if (controller
                            .employeeIdController.text.isEmpty) {
                          AppSnackBar.customSnackBar(
                              message: "Please Employee ID",
                              isError: true);
                        } else if (controller.changeStatusController.text.isEmpty) {
                          AppSnackBar.customSnackBar(
                              message: "Please Enter Reason",
                              isError: true);
                        } else {
                          controller
                              .markAbsent();
                        }
                      },
                    ),
                  )),
            ],
          )),
        ),
      ],
    );
  }
}
