import 'package:FaceAxis/modules/splash/controller/splash_controller.dart';
import 'package:FaceAxis/utilities/asset_utilities.dart';
import 'package:FaceAxis/utilities/constant_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AssetUtilities.splashBG,height:Get.height,width: Get.width,fit: BoxFit.fill,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset(AssetUtilities.appIcon,height: Get.height*0.08,width: Get.width*0.45,),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(ConstantUtilities.splashConstant,style: FontUtilities.h10(color: Colors.white,fontFamily: FontFamily.interMedium,fontWeight: FontWeight.w500),),
              ),
            ],
          )
        ],
      ),
    );
  }
}
