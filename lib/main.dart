
import 'package:FaceAxis/modules/splash/binding/splash_binding.dart';
import 'package:FaceAxis/routes/app_routes.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
late List<CameraDescription> cameras;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  VariableUtilities.storage = GetStorage("FaceAxis");
  cameras = await availableCameras();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'FaceAxis',
      debugShowCheckedModeBanner: false,
      getPages: Routes.getPages,
      initialRoute: Routes.splash,
      initialBinding: SplashBinding(),
    );
  }
}

///////////////
