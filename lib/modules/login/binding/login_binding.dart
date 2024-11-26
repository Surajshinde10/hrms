import 'package:get/get.dart';
import 'package:FaceAxis/modules/login/controller/login_controller.dart';

class LoginBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}