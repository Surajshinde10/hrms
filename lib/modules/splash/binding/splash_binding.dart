import 'package:get/get.dart';
import 'package:FaceAxis/modules/splash/controller/splash_controller.dart';

import '../../home/controller/home_controller.dart';

class SplashBinding implements Bindings{
  @override
  void dependencies() {

    Get.lazyPut(() => SplashController());
  }
}