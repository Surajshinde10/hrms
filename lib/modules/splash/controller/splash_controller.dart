import 'dart:async';
import 'package:FaceAxis/routes/app_routes.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../home/controller/home_controller.dart';

class SplashController extends GetxController {
  late final HomeController homeController;

  splashTime() {
    Timer(
      const Duration(seconds: 3),
          () => VariableUtilities.storage.read(KeyUtilitiess.userToken) == null
          ? Get.offNamed(Routes.login)
          : VariableUtilities.storage.read(KeyUtilities.endShift) == null?Get.offNamed(Routes.punch):Get.offNamed(Routes.home),
    );
  }

  @override
  void onInit() {
    splashTime();
    super.onInit();
  }
}
