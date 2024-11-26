import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/modules/home/controller/home_controller.dart';
import 'package:FaceAxis/modules/home/model/find_face_model.dart';
import 'package:FaceAxis/modules/home/view/RegistrationScreen.dart';
import 'package:FaceAxis/routes/app_routes.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/widgets/common_appbar.dart';
import 'package:FaceAxis/widgets/common_button.dart';
import 'package:FaceAxis/widgets/common_textfield.dart';

class AddEmployeeScreen extends GetView<HomeController> {
   AddEmployeeScreen({super.key});
   final HomeController homeController = Get.put(HomeController()); // Initialize here

  @override
  Widget build(BuildContext context) {
    return Obx(()=>Stack(
      children: [
        Image.asset(
          AssetUtilities.splash,
          height: Get.height,
          width: Get.width,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.29,
                      ),
                      Text(
                        "Add Employee",
                        style: FontUtilities.h24(
                            color: ColorUtilities.whiteColor,
                            fontFamily: FontFamily.interRegular,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CommonTextField(
                        hintText: "Employee Id",
                        controller: homeController.employeeIdController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      (homeController.isLoading.value)?Center(child: CircularProgressIndicator(color: ColorUtilities.whiteColor,),):CommonButton(
                        buttonName: "Add Employye",
                        onTap: () {
                         controller.uploadImage(controller.employeeIdController.text);
                        },
                      ),
                      SizedBox(height: 15,),
                      if(homeController.findFaceModel.value.userId != null)Text(
                        "Result",
                        style: FontUtilities.h20(
                            color: ColorUtilities.whiteColor,
                            fontFamily: FontFamily.interRegular,
                            fontWeight: FontWeight.w400),
                      ),
                      if(controller.findFaceModel.value.userId != null)Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.findFaceModel.value.name ?? "",
                                style: FontUtilities.h18(
                                    color: ColorUtilities.whiteColor.withOpacity(0.70),
                                    fontFamily: FontFamily.interMedium,
                                    fontWeight: FontWeight.w500),
                              ),
                              (controller.findFaceModel.value.faceRecogId == null)?Text(
                                "Face ID not available",
                                style: FontUtilities.h12(
                                    color: ColorUtilities.redD41616,
                                    fontFamily: FontFamily.interLight,
                                    fontWeight: FontWeight.w300),
                              ):Text(
                                "Face ID available",
                                style: FontUtilities.h12(
                                    color: ColorUtilities.blueACC3FF,
                                    fontFamily: FontFamily.interLight,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if(controller.findFaceModel.value.faceRecogId == null)CommonButton(
                            buttonName: "Add FaceID",
                            width: Get.width * 0.3,
                            onTap: () {
                              Get.toNamed(Routes.recognition,arguments: {
                                "isHome":false,
                                "isAdd":true,
                                "emp_id":controller.employeeIdController.text
                              });
                            },
                            buttonColor: ColorUtilities.blueACC3FF,
                            textColor: ColorUtilities.blackColor,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
               CommonAppBar(
                isBackOption: true,
                onTapIcon: (){
                  controller.punchOut();
                },
              )
            ],
          ),
        ),
      ],
    ));
  }
}
