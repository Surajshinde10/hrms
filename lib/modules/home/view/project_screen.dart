import 'package:FaceAxis/modules/home/controller/home_controller.dart';
import 'package:FaceAxis/modules/home/view/add_face_screen.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/constant_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:FaceAxis/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProjectScreen extends GetView<HomeController> {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtilities.whiteColor,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height * 0.21,
                  ),
                  Text(
                    ConstantUtilities.department,
                    style: FontUtilities.h20(
                        color: ColorUtilities.blackColor,
                        fontFamily: FontFamily.interRegular,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller
                        .projectData
                        .length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      final departmentData =
                          controller.projectData;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            if (VariableUtilities.storage
                                .read(KeyUtilities.departmentId) ==
                                departmentData[index].id) {
                              Get.to(const AddFaceScreen());
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: ColorUtilities.textFieldFillColor),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    departmentData[index].projectName ?? "",
                                    style: VariableUtilities.storage.read(
                                        KeyUtilities
                                            .departmentId) ==
                                        departmentData[index].id
                                        ? FontUtilities.h20(
                                        color: ColorUtilities
                                            .blackColor
                                            .withOpacity(0.80),
                                        fontFamily:
                                        FontFamily.interRegular,
                                        fontWeight: FontWeight.w400)
                                        : FontUtilities.h20(
                                        color: ColorUtilities
                                            .blackColor
                                            .withOpacity(0.30),
                                        fontFamily:
                                        FontFamily.interRegular,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    DateFormat("MMM dd, hh:mm a").format(
                                        departmentData[index].createdAt ??
                                            DateTime.now()),
                                    style: FontUtilities.h14(
                                        color: ColorUtilities.blackColor
                                            .withOpacity(0.30),
                                        fontFamily:
                                        FontFamily.interRegular,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
    );
  }
}
