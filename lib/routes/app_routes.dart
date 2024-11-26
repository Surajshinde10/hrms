import 'package:FaceAxis/modules/splash/binding/splash_binding.dart';
import 'package:FaceAxis/modules/splash/view/splash_screen.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/modules/home/binding/home_binding.dart';
import 'package:FaceAxis/modules/home/view/home_screen.dart';
import 'package:FaceAxis/modules/login/binding/login_binding.dart';
import 'package:FaceAxis/modules/login/view/login_screen.dart';
import 'package:FaceAxis/modules/punch/binding/punching_binding.dart';
import 'package:FaceAxis/modules/punch/view/punching_screen.dart';

class Routes{
  static String splash = '/splash';
  static String home = "/home";
  static String login = '/login';
  static String punch = "/punch";
  static String recognition = "/recognition";


  static List<GetPage> getPages = [
    GetPage(name: splash, page: ()=>const SplashScreen(),binding: SplashBinding()),
    GetPage(name: login, page: ()=>LoginScreen(),binding: LoginBinding()),
    GetPage(name: punch, page: ()=>PunchingScreen(),binding: PunchingBinding()),
    GetPage(name: home, page: ()=>HomeScreen(),binding: HomeBinding()),
    //GetPage(name: recognition, page: ()=>RecognitionScreen(),binding: RecognitionBinding())
  ];
}