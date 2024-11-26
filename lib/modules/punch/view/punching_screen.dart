import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:FaceAxis/widgets/common_appbar.dart';
import 'package:FaceAxis/widgets/common_button.dart';
import 'package:FaceAxis/widgets/common_dropdown_field.dart';
import 'package:FaceAxis/widgets/common_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/modules/punch/controller/punching_controller.dart';
import 'package:FaceAxis/modules/punch/view/camera_view_punch_screen.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/constant_utilities.dart';

class PunchingScreen extends GetView<PunchingController> {
   PunchingScreen({super.key});

  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final isExitWarning = lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2);

        if (isExitWarning) {
          lastPressed = now;
          AppSnackBar.customSnackBar(
              message:
              "Double Click to Exit from App");
          return false;
        }
        return true;
      },
      child:
      Stack(
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
                ? (controller.isPunchOut.value == true)
                ? Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  AssetUtilities.splash,
                  height: Get.height,
                  width: Get.width,
                  fit: BoxFit.fill,
                ),
                Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Image.asset(
                      AssetUtilities.splashLogo,
                      height: Get.height * 0.08,
                      width: Get.width * 0.45,
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20),
                      child: Text(
                        ConstantUtilities.splashConstant,
                        style: FontUtilities.h10(
                            color: Colors.white,
                            fontFamily:
                            FontFamily.interMedium,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
              ],
            )
                : Center(
              child: CircularProgressIndicator(
                color: ColorUtilities.whiteColor,
              ),
            )
                : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.29,
                        ),
                        Row(
                          children: [
                            Container(
                              height: Get.height * 0.14,
                              width: Get.width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      8),
                                  color: ColorUtilities
                                      .colorB9DC7B),
                              child: Padding(
                                padding:
                                const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Align(
                                        alignment: Alignment
                                            .topRight,
                                        child: Image.asset(
                                          AssetUtilities
                                              .startShift,
                                          height: 29,
                                          width: 29,
                                          fit: BoxFit.fill,
                                        )),
                                    Spacer(),
                                    Text(
                                      "${VariableUtilities.storage.read(KeyUtilities.startTime)}",
                                      style: FontUtilities.h20(
                                          color:
                                          ColorUtilities
                                              .blackColor,
                                          fontFamily: FontFamily
                                              .interRegular,
                                          fontWeight:
                                          FontWeight
                                              .w400),
                                    ),
                                    Text(
                                      "Start Shift",
                                      style: FontUtilities.h14(
                                          color: ColorUtilities
                                              .blackColor
                                              .withOpacity(
                                              0.30),
                                          fontFamily: FontFamily
                                              .interRegular,
                                          fontWeight:
                                          FontWeight
                                              .w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: Get.height * 0.14,
                              width: Get.width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      8),
                                  border: Border.all(
                                      color: ColorUtilities
                                          .whiteColor
                                          .withOpacity(0.10),
                                      width: 0.5),
                                  color: ColorUtilities
                                      .whiteColor
                                      .withOpacity(0.05)),
                              child: Padding(
                                padding:
                                const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Align(
                                        alignment: Alignment
                                            .topRight,
                                        child: Image.asset(
                                          AssetUtilities
                                              .endShift,
                                          height: 29,
                                          width: 29,
                                          fit: BoxFit.fill,
                                        )),
                                    Spacer(),
                                    Text(
                                      "${VariableUtilities.storage.read(KeyUtilities.endTime)}",
                                      style: FontUtilities.h20(
                                          color:
                                          ColorUtilities
                                              .blackColor,
                                          fontFamily: FontFamily
                                              .interRegular,
                                          fontWeight:
                                          FontWeight
                                              .w400),
                                    ),
                                    Text(
                                      "end Shift",
                                      style: FontUtilities.h14(
                                          color: ColorUtilities
                                              .blackColor
                                              .withOpacity(
                                              0.30),
                                          fontFamily: FontFamily
                                              .interRegular,
                                          fontWeight:
                                          FontWeight
                                              .w400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text("Division",
                            style: FontUtilities.h14(
                              color: ColorUtilities.whiteColor
                                  .withOpacity(0.7),
                              fontFamily:
                              FontFamily.interRegular,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          width: Get.width,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: ColorUtilities.whiteColor
                                .withOpacity(0.05),
                            borderRadius:
                            BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Text(
                              VariableUtilities.storage.read(
                                  KeyUtilities
                                      .divisionName) ??
                                  "",
                              style: FontUtilities.h16(
                                color: ColorUtilities
                                    .whiteColor
                                    .withOpacity(0.7),
                                fontFamily:
                                FontFamily.interRegular,
                              ),
                            ),
                          ),
                        ),
// CommonDropDownField(
//   onTileTap: (val) {
//     controller.selectedDivisionValue.value =
//         controller.divisionNameList[val];
//     controller.isDivisionDropDown.value =
//         !controller.isDivisionDropDown.value;
//     controller.selectedDivisionIndex.value = val;
//     controller.selectedDivisionId.value =
//         controller.divisionIdList[
//             controller.selectedDivisionIndex.value];
//     print(
//         "DIVION INDEX  :${controller.selectedDivisionIndex.value}");
//     print(
//         "DIVION ID INDEX  :${controller.selectedDivisionId.value}");
//   },
//   onIconTap: () {
//     controller.isDivisionDropDown.value =
//         !controller.isDivisionDropDown.value;
//   },
//   dataList: controller.divisionNameList,
//   title: ConstantUtilities.divisions,
//   isValueSelected:
//       controller.isDivisionDropDown.value,
//   selectedValue:
//       controller.selectedDivisionValue.value,
//   isValueInDialog:
//       controller.isDivisionDropDown.value,
// ),
                        SizedBox(
                          height: 10,
                        ),
// Container(
//   width: Get.width,
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Container(
//         height: 50,
//         child: TextFormField(
//           controller: controller.projectController,
//           onChanged: (val){
//             if(val.isEmpty){
//               controller.departmentSearchList.value = controller.departmentNameList;
//             }else{
//               controller.departmentNameList.forEach((element) {
//                 if(element.contains(val)){
//                   controller.departmentSearchList.add(element);
//                 }
//               });
//             }
//           },
//           decoration: InputDecoration(
//             enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
//             filled: true,
//             fillColor: ColorUtilities.textFieldFillColor
//           ),
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//      if(controller.departmentSearchList.isEmpty) Container(
//         decoration: BoxDecoration(
//           color: ColorUtilities.textFieldFillColor,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: ListView.builder(
//           shrinkWrap: true,
//           //physics: const NeverScrollableScrollPhysics(),
//           padding: const EdgeInsets.only(
//             top: 7,
//           ),
//           itemBuilder: (context, index) {
//             return InkWell(
//               onTap: () {
//                 controller.projectController.text = controller.departmentSearchList[index];
//                 controller.selectedDepartmentValue.value = controller.departmentSearchList[index];
//                 controller.departmentSearchList.clear();
//               },
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 15, top: 10, right: 15),
//                     child: Text(
//                       controller.departmentSearchList[index] ?? "",
//                       style: FontUtilities.h18(
//                         color: ColorUtilities.blackColor,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                 ],
//               ),
//             );
//           },
//           itemCount: controller.departmentSearchList.length,
//         ),
//       )
//     ],
//   ),
// ),
                        CommonDropDownField(
                          onTileTap: (val) {
                            controller.selectedDepartmentValue
                                .value =
                            controller
                                .departmentNameList[val];
                            controller.isDepartmentDropDown
                                .value =
                            !controller
                                .isDepartmentDropDown
                                .value;
                            controller.selectedDepartmentIndex
                                .value = val;
                            controller.selectedDepartmentId
                                .value = controller
                                .departmentIdList[
                            controller
                                .selectedDepartmentIndex
                                .value];
                            print(
                                "DEPARTMENT INDEX  :${controller.selectedDepartmentIndex.value}");
                            print(
                                "Department Value  :${controller.selectedDepartmentValue.value}");
                            print(
                                "ID : ${controller.selectedDepartmentId.value}");
                          },
                          onIconTap: () {
                            controller.isDepartmentDropDown
                                .value =
                            !controller
                                .isDepartmentDropDown
                                .value;
                          },
                          dataList:
                          controller.departmentNameList,
                          title: "Projects",
                          isValueSelected: controller
                              .isDepartmentDropDown.value,
                          selectedValue: controller
                              .selectedDepartmentValue.value,
                        ),
                      ],
                    ),
                  ),
                ),
                CommonAppBar(
                  onTapIcon: () {
                    controller.punchOut();
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CommonButton(
                      onTap: () {
                        if (controller
                            .selectedDepartmentId.value ==
                            0) {
                          AppSnackBar.customSnackBar(
                              message:
                              "please select department",
                              isError: true);
                        } else if (controller
                            .latitude.value ==
                            0) {
                          AppSnackBar.customSnackBar(
                              message:
                              "please wait some times!",
                              isError: true);
                        } else if (controller
                            .longitude.value ==
                            0) {
                          AppSnackBar.customSnackBar(
                              message:
                              "please wait some times!",
                              isError: true);
                        } else if (controller
                            .address.value.isEmpty) {
                          AppSnackBar.customSnackBar(
                              message:
                              "please wait some times!",
                              isError: true);
                        } else {
// Get.offNamed(Routes.recognition,arguments: {"isHome":true,"isAdd":false,"emp_id":""});
// // controller.getFindFaces();
                          Get.to(CamerViewPunchScreen());
                          VariableUtilities.storage.write(
                              KeyUtilities.departmentName,
                              controller
                                  .selectedDepartmentValue
                                  .value);
                          VariableUtilities.storage.write(
                              KeyUtilities.departmentId,
                              controller.selectedDepartmentId
                                  .value);
                          print(
                              "Department Value  :${VariableUtilities.storage.read(KeyUtilities.departmentName)}");
                        }
                      },
                      buttonName: ConstantUtilities.punchIn,
                      buttonColor: ColorUtilities.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

    )));
  }
}
