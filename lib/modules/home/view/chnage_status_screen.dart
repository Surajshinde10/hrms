import 'package:FaceAxis/modules/home/controller/home_controller.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/constant_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/widgets/common_appbar.dart';
import 'package:FaceAxis/widgets/common_button.dart';
import 'package:FaceAxis/widgets/common_dropdown_field.dart';
import 'package:FaceAxis/widgets/common_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChnageStatusScreen extends GetView<HomeController> {
  final int index;
   ChnageStatusScreen({required this.index,super.key});

  @override
  Widget build(BuildContext context) {
    print("Index ::${index}");
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
                              color: ColorUtilities.blackColor,
                              fontFamily: FontFamily.interMedium,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                        Text(
                          "${ controller
                              .attendanceList[index]
                              .employeeDetail
                              ?.name ??
                              ""} is Present"?? "",
                          style: FontUtilities.h16(
                              color: ColorUtilities.blackColor,
                              fontFamily: FontFamily.interLight,
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 20,),
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
              CommonAppBar(isBackOption: false,onTapIcon: (){
                controller.punchOut();
              },),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CommonButton(
                      buttonName: ConstantUtilities.confirm,
                      buttonColor: ColorUtilities.blackColor,
                      textColor: ColorUtilities.whiteColor,
                      onTap: () {
                         if (controller.statusValue.value.isEmpty) {
                          AppSnackBar.customSnackBar(
                              message: "Please Select working status",
                              isError: true);
                        } else {
                           print(controller
                               .attendanceList[index].employeeDetail?.employeeCode ?? "");
                          controller.changeStatus(controller
                              .attendanceList[index].employeeDetail?.employeeCode ?? "");
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
