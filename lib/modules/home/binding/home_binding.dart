import 'package:get/get.dart';
import 'package:FaceAxis/modules/home/controller/home_controller.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.put(HomeController());
  }
}