import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';

class AppSnackBar{
 static SnackbarController customSnackBar(
      {bool? isError = false, required String message}) {
    return Get.showSnackbar(
      GetSnackBar(
        message: message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isError == false ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}