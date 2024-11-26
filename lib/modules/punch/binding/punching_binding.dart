import 'package:get/get.dart';
import 'package:FaceAxis/modules/punch/controller/punching_controller.dart';

class PunchingBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PunchingController());
  }
}