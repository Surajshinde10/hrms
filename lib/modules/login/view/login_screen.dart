import 'package:FaceAxis/modules/login/controller/login_controller.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/constant_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/widgets/common_button.dart';
import 'package:FaceAxis/widgets/common_snackbar.dart';
import 'package:FaceAxis/widgets/common_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            Image.asset(AssetUtilities.splash,height: Get.height,width: Get.width,fit: BoxFit.fill,),
            Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: (controller.isLoading.value)
                  ? Center(
                      child: CircularProgressIndicator(color: ColorUtilities.whiteColor,),
                    )
                  : Container(
                      height: Get.height,
                      width: Get.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Get.height * 0.05,
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: Image.asset(
                                  AssetUtilities.appIcon,
                                  height: Get.width * 0.1,
                                  width: Get.width * 0.1,
                                )),
                             SizedBox(
                              height: Get.height*0.05,
                            ),
                            Text(ConstantUtilities.signIn,
                                style: FontUtilities.h40(
                                    color: ColorUtilities.whiteColor,
                                    fontFamily: FontFamily.interExtraLight,
                                    fontWeight: FontWeight.w700)),
                             SizedBox(
                              height: Get.height*0.1,
                            ),
                            CommonTextField(
                              controller: controller.emailController,
                              hintText: "EmployeeId/Username",
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CommonTextField(
                                controller: controller.passwordController,
                                hintText: "Password"),
                             SizedBox(
                              height: Get.height*0.11,
                            ),
                            CommonButton(
                              buttonName: ConstantUtilities.signIn,
                              onTap: () async {
                                if (controller.emailController.text.isEmpty) {
                                  AppSnackBar.customSnackBar(
                                      message: "Email is not Empty",
                                      isError: true);
                                } else if (controller
                                    .passwordController.text.isEmpty) {
                                  AppSnackBar.customSnackBar(
                                      message: "Password Required",
                                      isError: true);
                                } else if (controller
                                        .passwordController.text.length <
                                    2) {
                                  AppSnackBar.customSnackBar(
                                      message: "Password not valid!",
                                      isError: true);
                                } else {
                                  await controller.verifyEmployee();
                                }
                                //Get.toNamed(Routes.punch);
                              },
                            ),
                             SizedBox(
                              height: Get.height*0.035,
                            ),
                            Center(
                              child: Text(ConstantUtilities.forgotPassword,
                                  style: FontUtilities.h12(
                                      color: ColorUtilities.whiteColor,
                                      fontFamily: FontFamily.interRegular,
                                      fontWeight: FontWeight.w400)),
                            ),
                            Spacer(),
                            Center(
                              child: Text("Powered by Jachoos Solution",
                                  style: FontUtilities.h10(
                                      color: ColorUtilities.whiteColor,
                                      fontFamily: FontFamily.interMedium,
                                      )),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ));
  }
}

//else if (!RegExp(
//                         r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
//                         .hasMatch(controller.emailController.text)) {
//                       AppSnackBar.customSnackBar(
//                           message: "Email is not valid!", isError: true);
//                     }
