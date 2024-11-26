import 'package:FaceAxis/routes/app_routes.dart';
import 'package:FaceAxis/services/api_services.dart';
import 'package:FaceAxis/services/api_url.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:FaceAxis/widgets/common_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> verifyEmployee() async {
    isLoading.value = true;
    final response = await API.callAPI(
        url: ApiUrlUtilities.verifyEmployee,
        type: APIType.tPost,
        body: {"userId": emailController.text, "password": passwordController.text});

    print("Response :::${response}");
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        isLoading.value = false;
        VariableUtilities.storage
            .write(KeyUtilities.userToken, response["auth_key"]);
        VariableUtilities.storage
            .write(KeyUtilities.id, response["user_id"]);
        VariableUtilities.storage.write(KeyUtilities.attendanceId, response["id"]);
        VariableUtilities.storage
            .write(KeyUtilities.name, response["name"]);
        VariableUtilities.storage.write(KeyUtilities.empCode, emailController.text);
        VariableUtilities.storage.write(KeyUtilities.divisionName, response["division"]);
        VariableUtilities.storage.write(KeyUtilities.status, response["status"]);
        VariableUtilities.storage.write(KeyUtilities.divisionId, response["division_id"]);
        VariableUtilities.storage.write(KeyUtilities.employeeCode, response["EmployeeCode"]);
        print("TOKEN ::${VariableUtilities.storage.read(KeyUtilities.userToken)}");
        Get.offNamed(Routes.punch,arguments: {"isAdd":false});
        AppSnackBar.customSnackBar(
          message: "User login successfully",
        );
      }
    }else if(response == null){
      isLoading.value = false;
      AppSnackBar.customSnackBar(
          message: response.toString(), isError: true);
    }
  }
}
