import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/modules/home/controller/home_controller.dart';
import 'package:FaceAxis/modules/home/view/add_employee_screen.dart';
import 'package:FaceAxis/modules/home/view/add_face_screen.dart';
import 'package:FaceAxis/modules/home/view/absent_screen.dart';
import 'package:FaceAxis/modules/home/view/camera_view_add_employee.dart';
import 'package:FaceAxis/modules/home/view/camera_view_home_screen.dart';
import 'package:FaceAxis/modules/home/view/chnage_status_screen.dart';
import 'package:FaceAxis/modules/home/view/project_screen.dart';
import 'package:FaceAxis/modules/punch/controller/punching_controller.dart';
import 'package:FaceAxis/routes/app_routes.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/constant_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:FaceAxis/widgets/common_appbar.dart';
import 'package:FaceAxis/widgets/common_button.dart';
import 'package:FaceAxis/widgets/common_snackbar.dart';
import 'package:intl/intl.dart';

class HomeScreen extends GetView<HomeController> {
   HomeScreen({super.key});
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
              bottomNavigationBar: (controller.isLoading.value)
                  ? Container(
                height: Get.height * 0.055,
              )
                  : (controller.isSelectTabOpen.value == false)
                  ? Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5),
                child: Container(
                  height: Get.height * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: ColorUtilities.whiteColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            controller.selectedIndex.value = 0;
                          },
                          child: Image.asset(
                            controller.selectedIndex.value == 0
                                ? AssetUtilities.selectedHome
                                : AssetUtilities.unSelectedHome,
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                          )),
                      GestureDetector(
                          onTap: () {
                            controller.selectedIndex.value = 1;
                          },
                          child: Image.asset(
                            controller.selectedIndex.value == 1
                                ? AssetUtilities.selectedMenu
                                : AssetUtilities.unSelectedMenu,
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                          )),
                      GestureDetector(
                          onTap: () {
                            controller.selectedIndex.value = 2;
                            controller.isSelectTabOpen.value = false;
                          },
                          child: Image.asset(
                            controller.selectedIndex.value == 2
                                ? AssetUtilities.selectedUser
                                : AssetUtilities.unselectedUser,
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                          )),
                      GestureDetector(
                          onTap: () {
                            controller.selectedIndex.value = 3;
                            // controller.isSelectTabOpen.value = false;
                          },
                          child: Image.asset(
                            controller.selectedIndex.value == 3
                                ? AssetUtilities.selectedEmp
                                : AssetUtilities.unSelectedEmp,
                            height: 25,
                            width: 25,
                            fit: BoxFit.fill,
                          )),
                    ],
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 5),
                child: Container(
                  height: Get.height * 0.055,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.transparent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              if (controller.punchingId.isNotEmpty) {
                                controller.multiplePunchOutEmployee();
                              } else {
                                AppSnackBar.customSnackBar(
                                    message:
                                    "Please Select Employee");
                              }
                            },
                            child: CommonButton(
                              buttonName: ConstantUtilities.punchOut,
                              buttonColor: ColorUtilities.redD41616,
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              controller.isSelectTabOpen.value =
                              false;
                            },
                            child: CommonButton(
                              buttonName: ConstantUtilities.cancel,
                              buttonColor: Colors.transparent,
                              borderColor: ColorUtilities.whiteColor
                                  .withOpacity(0.15),
                              textColor: ColorUtilities.whiteColor
                                  .withOpacity(0.90),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              body: (controller.isLoading.value)
                  ? Center(
                child: CircularProgressIndicator(
                    color: ColorUtilities.whiteColor),
              )
                  : Stack(
                children: [
                  if (controller.selectedIndex.value == 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    BorderRadius.circular(8),
                                    color: ColorUtilities.colorB9DC7B),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Image.asset(
                                            AssetUtilities.startShift,
                                            height: 29,
                                            width: 29,
                                            fit: BoxFit.fill,
                                          )),
                                      Spacer(),
                                      Text(
                                        "${VariableUtilities.storage.read(KeyUtilities.startTime)}",
                                        style: FontUtilities.h20(
                                            color:
                                            ColorUtilities.color404A4A,
                                            fontFamily:
                                            FontFamily.interMedium,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        "Start Shift",
                                        style: FontUtilities.h14(
                                            color: ColorUtilities
                                                .color404A4A,
                                            fontFamily:
                                            FontFamily.interRegular,
                                            fontWeight: FontWeight.w400),
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
                                    BorderRadius.circular(8),
                                    border: Border.all(
                                        color: ColorUtilities.whiteColor
                                            .withOpacity(0.10),
                                        width: 0.5),
                                    color: ColorUtilities.whiteColor
                                        .withOpacity(0.05)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: Image.asset(
                                            AssetUtilities.endShift,
                                            height: 29,
                                            width: 29,
                                            fit: BoxFit.fill,
                                          )),
                                      Spacer(),
                                      Text(
                                        "${VariableUtilities.storage.read(KeyUtilities.endTime)}",
                                        style: FontUtilities.h20(
                                            color:
                                            ColorUtilities.whiteColor,
                                            fontFamily:
                                            FontFamily.interMedium,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        "end Shift",
                                        style: FontUtilities.h14(
                                            color: ColorUtilities
                                                .whiteColor,
                                            fontFamily:
                                            FontFamily.interRegular,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                  controller.tageList.length,
                                      (index) => Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        controller.selectedTagIndex
                                            .value = index;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                20),
                                            border: Border.all(
                                                color: controller
                                                    .selectedTagIndex
                                                    .value ==
                                                    index
                                                    ? Colors
                                                    .transparent
                                                    : ColorUtilities
                                                    .whiteColor
                                                    .withOpacity(
                                                    0.5)),
                                            color: (controller
                                                .selectedTagIndex
                                                .value ==
                                                index)
                                                ? ColorUtilities
                                                .whiteColor
                                                : Colors.transparent),
                                        child: Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              horizontal: 10,
                                              vertical: 5),
                                          child: Text(
                                            controller
                                                .tageList[index],
                                            style: FontUtilities.h14(
                                                color: (controller
                                                    .selectedTagIndex
                                                    .value ==
                                                    index)
                                                    ? ColorUtilities
                                                    .color404A4A
                                                    : ColorUtilities
                                                    .whiteColor,
                                                fontFamily: (controller
                                                    .selectedTagIndex
                                                    .value ==
                                                    index)
                                                    ? FontFamily
                                                    .interSemiBold
                                                    : FontFamily
                                                    .interLight),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          // Row(
                          //   children: [
                          //     Text(
                          //       ConstantUtilities.departments,
                          //       style: FontUtilities.h20(
                          //         color: ColorUtilities.blackColor,
                          //         fontFamily: FontFamily.interMedium,
                          //       ),
                          //     ),
                          //     const Spacer(),
                          //     GestureDetector(
                          //       onTap: () {
                          //         Get.to(() => const ProjectScreen());
                          //       },
                          //       child: Text(
                          //         ConstantUtilities.viewAll,
                          //         style: FontUtilities.h14(
                          //             color: ColorUtilities.blackColor
                          //                 .withOpacity(0.40),
                          //             fontFamily:
                          //                 FontFamily.interMedium,
                          //             fontWeight: FontWeight.w500),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 20,
                          ),
                          if (controller.selectedTagIndex.value == 0)
                            GestureDetector(
                              onTap: () {
                                Get.to(const AddFaceScreen());
                              },
                              child: Container(
                                height: 50,
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(25),
                                    color: ColorUtilities.whiteColor
                                        .withOpacity(0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      "Take Attendance",
                                      style: FontUtilities.h16(
                                        color: ColorUtilities.whiteColor,
                                        fontFamily: FontFamily.interBold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (controller.selectedTagIndex.value == 0)
                            const SizedBox(
                              height: 15,
                            ),
                          if (controller.selectedTagIndex.value == 0)
                            Container(
                              height: Get.height * 0.3,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: controller.projectData.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final departmentData =
                                      controller.projectData;
                                  return GestureDetector(
                                    onTap: () {
                                      // if (VariableUtilities.storage
                                      //         .read(KeyUtilities
                                      //             .departmentId) ==
                                      //     departmentData[index].id) {
                                      //   Get.to(const AddFaceScreen());
                                      // }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          border: Border.all(
                                              color: ColorUtilities
                                                  .whiteColor
                                                  .withOpacity(0.10)),
                                          gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                ColorUtilities.whiteColor
                                                    .withOpacity(0.0),
                                                ColorUtilities.blackColor
                                                    .withOpacity(0.2),
                                              ]),
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 21,
                                                backgroundColor:
                                                ColorUtilities
                                                    .whiteColor
                                                    .withOpacity(
                                                    0.10),
                                                child: Icon(
                                                  Icons.settings,
                                                  color: ColorUtilities
                                                      .whiteColor,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Container(
                                                    width:
                                                    Get.width * 0.6,
                                                    height: 30,
                                                    child: Text(
                                                      departmentData[
                                                      index]
                                                          .projectName ??
                                                          "",
                                                      style: VariableUtilities
                                                          .storage
                                                          .read(KeyUtilities
                                                          .departmentId) ==
                                                          departmentData[
                                                          index]
                                                              .id
                                                          ? FontUtilities.h16(
                                                          color: ColorUtilities
                                                              .whiteColor,
                                                          fontFamily:
                                                          FontFamily
                                                              .interRegular,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400)
                                                          : FontUtilities.h16(
                                                          color:
                                                          ColorUtilities
                                                              .whiteColor,
                                                          fontFamily:
                                                          FontFamily
                                                              .interRegular,
                                                          fontWeight:
                                                          FontWeight
                                                              .w400),
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                        "MMM dd, hh:mm a")
                                                        .format(departmentData[
                                                    index]
                                                        .createdAt ??
                                                        DateTime
                                                            .now()),
                                                    style: FontUtilities.h14(
                                                        color: ColorUtilities
                                                            .whiteColor
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
                                              Spacer(),
                                              VariableUtilities.storage
                                                  .read(KeyUtilities
                                                  .departmentId) ==
                                                  departmentData[
                                                  index]
                                                      .id
                                                  ? Image.asset(
                                                AssetUtilities
                                                    .remove,
                                                height: 30,
                                                width: 30,
                                                fit: BoxFit.fill,
                                              )
                                                  : Image.asset(
                                                AssetUtilities.done,
                                                height: 30,
                                                width: 30,
                                                fit: BoxFit.fill,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (controller.selectedTagIndex.value == 0)
                            SizedBox(
                              height: 10,
                            ),
                          if (controller.selectedTagIndex.value == 1)
                            GestureDetector(
                              onTap: (){
                                Get.to(CameraViewHomeScreen());
                              },
                              child: Container(
                                width: Get.width * 0.9,
                                height: Get.height * 0.35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorUtilities.whiteColor
                                        .withOpacity(0.2)),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AssetUtilities.recognitionLogo,
                                      width: Get.width - 150,
                                      height: Get.width - 150,
                                    ),
                                    Text("Tap to take",style: FontUtilities.h12(
                                        color: ColorUtilities
                                            .whiteColor,
                                        fontFamily:
                                        FontFamily.interRegular,
                                        fontWeight: FontWeight.w400),)
                                  ],
                                ),
                              ),
                            ),

                          if (controller.selectedTagIndex.value == 2)
                            (controller.attendanceList.length == 0)
                                ? Center(
                              child: Text(
                                "No Data Found",
                                style: FontUtilities.h16(
                                    color:
                                    ColorUtilities.blackColor,
                                    fontFamily:
                                    FontFamily.interRegular),
                              ),
                            )
                                : Container(
                              height: Get.height * 0.4,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: controller
                                      .attendanceList.length,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      Obx(() => Padding(
                                        padding:
                                        const EdgeInsets
                                            .symmetric(
                                            vertical: 10),
                                        child: Container(
                                          height:
                                          Get.height * 0.08,
                                          decoration:
                                          BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                15),
                                            border: Border.all(
                                                color: ColorUtilities
                                                    .whiteColor
                                                    .withOpacity(
                                                    0.10)),
                                            gradient: LinearGradient(
                                                begin: Alignment
                                                    .centerLeft,
                                                end: Alignment
                                                    .centerRight,
                                                colors: [
                                                  ColorUtilities
                                                      .whiteColor
                                                      .withOpacity(
                                                      0.0),
                                                  ColorUtilities
                                                      .blackColor
                                                      .withOpacity(
                                                      0.2),
                                                ]),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: ColorUtilities
                                                      .blackColor
                                                      .withOpacity(
                                                      0.15),
                                                  blurRadius: 4,
                                                  offset:
                                                  Offset(
                                                      0, 4))
                                            ],
                                            color: (controller
                                                .isSelectTabOpen
                                                .value ==
                                                true)
                                                ? controller
                                                .attendanceList[
                                            index]
                                                .isCheck ==
                                                true
                                                ? ColorUtilities
                                                .blueACC3FF
                                                : Colors
                                                .white
                                                : Colors.white,
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                15),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor: ColorUtilities
                                                      .whiteColor
                                                      .withOpacity(
                                                      0.2),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      controller
                                                          .attendanceList[index]
                                                          .employeeDetail
                                                          ?.name ??
                                                          "",
                                                      style: FontUtilities.h18(
                                                          color: ColorUtilities
                                                              .whiteColor,
                                                          fontFamily: FontFamily
                                                              .interMedium,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                    Text(
                                                      controller
                                                          .attendanceList[index]
                                                          .workingStatus
                                                          .toString() ??
                                                          "",
                                                      style: FontUtilities.h12(
                                                          color: ColorUtilities
                                                              .whiteColor,
                                                          fontFamily: FontFamily
                                                              .interLight,
                                                          fontWeight:
                                                          FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                                // const Spacer(),
                                                // (controller.isSelectTabOpen
                                                //     .value ==
                                                //     true)
                                                //     ? CheckboxTheme(
                                                //   data: CheckboxThemeData(
                                                //       fillColor: controller.attendanceList[index].isCheck == true
                                                //           ? MaterialStateProperty.all(ColorUtilities.blackColor)
                                                //           : MaterialStateProperty.all(ColorUtilities.whiteColor)),
                                                //   child: Checkbox(
                                                //       value: controller.attendanceList[index].isCheck,
                                                //       onChanged: (val) {
                                                //         controller.attendanceList[index].isCheck = val ?? false;
                                                //         controller.attendanceList[index] = controller.attendanceList[index];
                                                //         if (controller.attendanceList[index].isCheck) {
                                                //           controller.punchingId.add(controller.attendanceList[index].id ?? 0);
                                                //         } else if (controller.attendanceList[index].isCheck == false) {
                                                //           controller.punchingId.remove(controller.attendanceList[index].id);
                                                //           controller.selectedTap.value = 0;
                                                //         }
                                                //
                                                //         print(index);
                                                //         if (controller.punchingId.length == controller.attendanceList.length) {
                                                //           controller.selectedTap.value = 1;
                                                //         }
                                                //         print(controller.punchingId);
                                                //       }),
                                                // )
                                                //     : PopupMenuButton(
                                                //   onSelected:
                                                //       (value) {
                                                //     if (value ==
                                                //         "select") {
                                                //       controller.isSelectTabOpen.value =
                                                //       true;
                                                //     } else if (value ==
                                                //         "status") {
                                                //       Get.to(ChnageStatusScreen(
                                                //         index: index,
                                                //       ));
                                                //     } else if (value ==
                                                //         "absent") {
                                                //       Get.to(const AbsentScreen());
                                                //     }
                                                //   },
                                                //   itemBuilder:
                                                //       (BuildContext
                                                //   bc) {
                                                //     return const [
                                                //       PopupMenuItem(
                                                //         child: Text("Change Status"),
                                                //         value: 'status',
                                                //       ),
                                                //       PopupMenuItem(
                                                //         child: Text("Select"),
                                                //         value: 'select',
                                                //       ),
                                                //       PopupMenuItem(
                                                //         child: Text("Mark As absent"),
                                                //         value: 'absent',
                                                //       )
                                                //     ];
                                                //   },
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))),
                            ),
                          // Text(
                          //   ConstantUtilities.recentActivities,
                          //   style: FontUtilities.h20(
                          //       color: ColorUtilities.blackColor,
                          //       fontFamily: FontFamily.interMedium,
                          //       fontWeight: FontWeight.w400),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          if (controller.selectedTagIndex.value == 3)
                            Container(
                              height: Get.height * 0.37,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: controller
                                    .recentActivitiesData.length,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                        color: ColorUtilities.whiteColor
                                            .withOpacity(0.05)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 43/2,
                                            backgroundColor: ColorUtilities.whiteColor.withOpacity(0.10),
                                            child: Image.asset(
                                              AssetUtilities.startShiftWhite,
                                              height: Get.width * 0.085,
                                              width: Get.width * 0.085,
                                              fit: BoxFit.fill,
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Start Shift",
                                                style: FontUtilities.h20(
                                                    color: ColorUtilities
                                                        .whiteColor
                                                        .withOpacity(
                                                        0.80),
                                                    fontFamily: FontFamily
                                                        .interRegular,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                              Text(
                                                DateFormat("dd MMM yyyy")
                                                    .format(controller
                                                    .recentActivitiesData[
                                                index]
                                                    .date ??
                                                    DateTime.now()),
                                                style: FontUtilities.h14(
                                                    color: ColorUtilities
                                                        .whiteColor
                                                        .withOpacity(
                                                        0.30),
                                                    fontFamily: FontFamily
                                                        .interRegular,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                controller
                                                    .recentActivitiesData[
                                                index]
                                                    .clockIn ??
                                                    "",
                                                style: FontUtilities.h18(
                                                    color: ColorUtilities
                                                        .whiteColor
                                                        .withOpacity(
                                                        0.800),
                                                    fontFamily: FontFamily
                                                        .interMedium,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                              Text(
                                                controller
                                                    .recentActivitiesData[
                                                index]
                                                    .late!
                                                    .isNotEmpty
                                                    ? "Late"
                                                    : "Late",
                                                style: FontUtilities.h14(
                                                    color: ColorUtilities
                                                        .whiteColor
                                                        .withOpacity(
                                                        0.30),
                                                    fontFamily: FontFamily
                                                        .interRegular,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  if (controller.selectedIndex.value == 1)
                    AddFaceScreen(),
                  if (controller.selectedIndex.value == 2)
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
                              ConstantUtilities.attendanceList,
                              style: FontUtilities.h20(
                                  color: ColorUtilities.whiteColor,
                                  fontFamily: FontFamily.interRegular,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: CommonButton(
                                      buttonName: "Add Absent",
                                      buttonColor: ColorUtilities.colorB9DC7B,
                                      textColor: ColorUtilities.blackColor,
                                      height: Get.height * 0.055,
                                      onTap: () {
                                        Get.to(const AbsentScreen());
                                      },
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: CommonButton(
                                      buttonName:
                                      ConstantUtilities.addEmployee,
                                      height: Get.height * 0.055,
                                      buttonColor: Colors.transparent,
                                      textColor: ColorUtilities.whiteColor,
                                      borderColor: ColorUtilities.whiteColor
                                          .withOpacity(0.50),
                                      onTap: () {
                                        Get.to(CameraViewAddEmployeeScreen());
                                      },
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (controller.isSelectTabOpen.value == true)
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: CommonButton(
                                    buttonName:
                                    (controller.selectedTap.value ==
                                        0)
                                        ? "Mark All"
                                        : "UnMark All",
                                    height: Get.height * 0.045,
                                    width: Get.width * 0.25,
                                    borderColor: ColorUtilities.blackColor
                                        .withOpacity(0.15),
                                    buttonColor: ColorUtilities.blackColor
                                        .withOpacity(0.05),
                                    textColor: ColorUtilities.whiteColor,
                                    fontStyle: FontUtilities.h12(color: ColorUtilities.whiteColor),
                                    onTap: () {
                                      controller.punchingId.clear();
                                      if (controller.selectedTap.value ==
                                          0) {
                                        controller.attendanceList
                                            .forEach((element) {
                                          element.isCheck = true;
                                          controller.attendanceList =
                                              controller.attendanceList;
                                          controller.punchingId
                                              .add(element.id ?? 0);
                                          controller.punchingId
                                              .toSet()
                                              .toList();
                                          print(
                                              "IDD ::${controller.punchingId}");
                                          controller.selectedTap.value =
                                          1;
                                        });
                                      } else {
                                        controller.attendanceList
                                            .forEach((element) {
                                          element.isCheck = false;
                                          controller.selectedTap.value =
                                          0;
                                          controller.punchingId.clear();
                                          controller.isSelectTabOpen
                                              .value = false;
                                          controller.attendanceList =
                                              controller.attendanceList;
                                        });
                                      }
                                    },
                                  )),
                            const SizedBox(
                              height: 10,
                            ),
                            (controller.attendanceList.length == 0)
                                ? Center(
                              child: Text(
                                "No Data Found",
                                style: FontUtilities.h16(
                                    color:
                                    ColorUtilities.blackColor,
                                    fontFamily:
                                    FontFamily.interRegular),
                              ),
                            )
                                : Container(
                              height: Get.height * 0.55,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: controller
                                      .attendanceList.length,
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      Obx(() => Padding(
                                        padding:
                                        const EdgeInsets
                                            .symmetric(
                                            vertical: 10),
                                        child: Container(
                                          height:
                                          Get.height * 0.08,
                                          decoration:
                                          BoxDecoration(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                15),
                                            border: Border.all(
                                                color: ColorUtilities
                                                    .whiteColor
                                                    .withOpacity(
                                                    0.10)),
                                            gradient: LinearGradient(
                                                begin: Alignment
                                                    .topLeft,
                                                end: Alignment
                                                    .bottomRight,
                                                colors: [
                                                  ColorUtilities
                                                      .whiteColor
                                                      .withOpacity(
                                                      0.0),
                                                  ColorUtilities
                                                      .blackColor
                                                      .withOpacity(
                                                      0.2),
                                                ]),
                                            color: (controller
                                                .isSelectTabOpen
                                                .value ==
                                                true)
                                                ? controller
                                                .attendanceList[
                                            index]
                                                .isCheck ==
                                                true
                                                ? ColorUtilities
                                                .blueACC3FF
                                                : Colors
                                                .white
                                                : Colors.white,
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                15),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              children: [
                                                CircleAvatar(
                                                  radius: 16,
                                                  backgroundColor:
                                                  ColorUtilities
                                                      .whiteColor.withOpacity(0.20),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      controller
                                                          .attendanceList[index]
                                                          .employeeDetail
                                                          ?.name ??
                                                          "",
                                                      style: FontUtilities.h18(
                                                          color: ColorUtilities
                                                              .whiteColor,
                                                          fontFamily: FontFamily
                                                              .interMedium,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                    ),
                                                    Text(
                                                      controller
                                                          .attendanceList[index]
                                                          .workingStatus
                                                          .toString() ??
                                                          "",
                                                      style: FontUtilities.h12(
                                                          color: ColorUtilities
                                                              .whiteColor,
                                                          fontFamily: FontFamily
                                                              .interLight,
                                                          fontWeight:
                                                          FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                (controller.isSelectTabOpen
                                                    .value ==
                                                    true)
                                                    ? CheckboxTheme(
                                                  data: CheckboxThemeData(
                                                      fillColor: controller.attendanceList[index].isCheck == true
                                                          ? MaterialStateProperty.all(ColorUtilities.blackColor)
                                                          : MaterialStateProperty.all(ColorUtilities.whiteColor)),
                                                  child: Checkbox(
                                                      value: controller.attendanceList[index].isCheck,
                                                      onChanged: (val) {
                                                        controller.attendanceList[index].isCheck = val ?? false;
                                                        controller.attendanceList[index] = controller.attendanceList[index];
                                                        if (controller.attendanceList[index].isCheck) {
                                                          controller.punchingId.add(controller.attendanceList[index].id ?? 0);
                                                        } else if (controller.attendanceList[index].isCheck == false) {
                                                          controller.punchingId.remove(controller.attendanceList[index].id);
                                                          controller.selectedTap.value = 0;
                                                        }

                                                        print(index);
                                                        if (controller.punchingId.length == controller.attendanceList.length) {
                                                          controller.selectedTap.value = 1;
                                                        }
                                                        print(controller.punchingId);
                                                      }),
                                                )
                                                    : PopupMenuButton(
                                                  iconColor:
                                                  ColorUtilities.whiteColor,
                                                  onSelected:
                                                      (value) {
                                                    if (value ==
                                                        "select") {
                                                      controller.isSelectTabOpen.value =
                                                      true;
                                                    } else if (value ==
                                                        "status") {
                                                      Get.to(ChnageStatusScreen(
                                                        index: index,
                                                      ));
                                                    } else if (value ==
                                                        "absent") {
                                                      Get.to(const AbsentScreen());
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext
                                                  bc) {
                                                    return const [
                                                      PopupMenuItem(
                                                        child: Text("Change Status"),
                                                        value: 'status',
                                                      ),
                                                      PopupMenuItem(
                                                        child: Text("Select"),
                                                        value: 'select',
                                                      ),
                                                      PopupMenuItem(
                                                        child: Text("Mark As absent"),
                                                        value: 'absent',
                                                      )
                                                    ];
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))),
                            )
                          ],
                        ),
                      ),
                    ),
                  if(controller.selectedIndex.value == 3)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: Get.height*0.08,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "My Profile",
                                        style: FontUtilities.h24(
                                            color: ColorUtilities.whiteColor,
                                            fontFamily: FontFamily.interRegular,
                                            fontWeight: FontWeight.w200),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                          onTap: (){
                                            controller.punchOut();
                                          },
                                          child: Container(
                                              height: Get.width * 0.12,
                                              width: Get.width * 0.12,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: ColorUtilities.whiteColor.withOpacity(0.15)),
                                              child: Center(
                                                  child: Image.asset(AssetUtilities.logout,
                                                      height: Get.width * 0.07,
                                                      width: Get.width * 0.045,
                                                      fit: BoxFit.fill)))),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Row(
                                  children: [
                                    CircleAvatar(radius: 2,backgroundColor: ColorUtilities.whiteColor.withOpacity(0.50),),
                                    Expanded(child: Container(height: 0.5,color: ColorUtilities.whiteColor.withOpacity(0.50),)),
                                    CircleAvatar(radius: 2,backgroundColor: ColorUtilities.whiteColor.withOpacity(0.50),),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: Get.height*0.05,),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: Get.width * 0.13,
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: Get.width*0.6,
                                      child: Text(
                                        VariableUtilities.storage.read(KeyUtilities.name) ?? "",
                                        style: FontUtilities.h32(
                                            color: ColorUtilities.colorEDFFCD,
                                            fontFamily: FontFamily.interRegular,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Text("Manager",
                                      style: FontUtilities.h14(
                                        color: ColorUtilities.whiteColor,
                                        fontFamily: FontFamily.interLight,
                                      ),
                                    ),
                                    Text(
                                      VariableUtilities.storage.read(KeyUtilities.employeeCode) ??
                                          "",
                                      style: FontUtilities.h14(
                                        color: ColorUtilities.whiteColor.withOpacity(0.80),
                                        fontFamily: FontFamily.interLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: Get.height*0.05,),
                            Container(
                              height: Get.height * 0.52,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: controller
                                    .recentActivitiesData.length,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                        color: ColorUtilities.whiteColor
                                            .withOpacity(0.05)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 43/2,
                                            backgroundColor: ColorUtilities.whiteColor.withOpacity(0.10),
                                            child: Image.asset(
                                              AssetUtilities.startShiftWhite,
                                              height: Get.width * 0.085,
                                              width: Get.width * 0.085,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Start Shift",
                                                style: FontUtilities.h20(
                                                    color: ColorUtilities
                                                        .whiteColor
                                                        .withOpacity(
                                                        0.80),
                                                    fontFamily: FontFamily
                                                        .interRegular,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                              Text(
                                                DateFormat("dd MMM yyyy")
                                                    .format(controller
                                                    .recentActivitiesData[
                                                index]
                                                    .date ??
                                                    DateTime.now()),
                                                style: FontUtilities.h14(
                                                    color: ColorUtilities
                                                        .whiteColor
                                                        .withOpacity(
                                                        0.30),
                                                    fontFamily: FontFamily
                                                        .interRegular,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                controller
                                                    .recentActivitiesData[
                                                index]
                                                    .clockIn ??
                                                    "",
                                                style: FontUtilities.h18(
                                                    color: ColorUtilities
                                                        .whiteColor
                                                        .withOpacity(
                                                        0.80),
                                                    fontFamily: FontFamily
                                                        .interMedium,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                              Text(
                                                controller
                                                    .recentActivitiesData[
                                                index]
                                                    .late!
                                                    .isNotEmpty
                                                    ? "Late"
                                                    : "Late",
                                                style: FontUtilities.h14(
                                                    color: ColorUtilities
                                                        .whiteColor
                                                        .withOpacity(
                                                        0.30),
                                                    fontFamily: FontFamily
                                                        .interRegular,
                                                    fontWeight:
                                                    FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (controller.selectedIndex.value != 3)
                    CommonAppBar(onTapIcon: () {
                      controller.punchOut();
                    }
                    ),
                ],
              ),
            ),
          ],
        )));
  }
}
