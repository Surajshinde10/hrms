// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:FaceAxis/ML/Recognition.dart';
// import 'package:FaceAxis/modules/recognition/controller/recognition_controller.dart';
// import 'package:FaceAxis/utilities/asset_utilities.dart';
// import 'package:FaceAxis/utilities/color_utilities.dart';
// import 'package:hrms/utilities/font_utilities.dart';
// import 'package:hrms/widgets/common_button.dart';
//
// class RecognitionScreen extends GetView<RecognitionController> {
//   const RecognitionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<RecognitionController>(
//       builder: (_) {
//         return Stack(
//           children: [
//             Image.asset(AssetUtilities.splash,height: Get.height,width: Get.width,fit: BoxFit.fill,),
//             Scaffold(
//               backgroundColor: Colors.transparent,
//               body: (controller.isInitializedCamera.value)
//                   ? (controller.cameraController.value.isInitialized)
//                   ? SizedBox(
//                 height: Get.height,
//                 width: Get.width,
//                 child: CameraPreview(controller.cameraController),
//               )
//                   : Container()
//                   : Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   controller.shortImage != null
//                       ? Container(
//                     margin: const EdgeInsets.only(
//                         top: 60, left: 30, right: 30, bottom: 0),
//                     child: FittedBox(
//                       child: SizedBox(
//                         width: controller.shortImage.width.toDouble(),
//                         height: controller.shortImage.width.toDouble(),
//                         child: CustomPaint(
//                           painter: FacePainter(
//                               facesList: controller.recognitions,
//                               imageFile: controller.shortImage),
//                         ),
//                       ),
//                     ),
//                   )
//                       : Container(
//                     width: Get.width*0.9,
//                     height: Get.height*0.32,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: ColorUtilities.whiteColor.withOpacity(0.2)
//                     ),
//                     margin: const EdgeInsets.only(top: 100),
//                     child: Image.asset(
//                       AssetUtilities.recognitionLogo,
//                       width: Get.width - 100,
//                       height: Get.width - 100,
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                   ),
//                   //TODO section which displays buttons for choosing and capturing images
//                   (controller.isLoading.value == true)
//                       ? Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 100),
//                       child: Text(
//                         "Loading....",
//                         style: FontUtilities.h18(
//                             color: ColorUtilities.whiteColor,
//                             fontFamily: FontFamily.interBold),
//                       ),
//                     ),
//                   )
//                       : (controller.isFaceDetect.value)
//                       ? Padding(
//                     padding: const EdgeInsets.only(bottom: 100),
//                     child: CommonButton(
//                       onTap: () {
//                         controller.initializeCamera();
//                       },
//                       buttonName: "Add Face",
//                       width: Get.width * 0.8,
//                     ),
//                   )
//                       : Container(
//                     margin: const EdgeInsets.only(bottom: 100),
//                     child: InkWell(
//                       onTap: () {
//                         controller.initializeCamera();
//                       },
//                       child: Column(
//                         children: [
//                           CircleAvatar(
//                             radius: 35,
//                             backgroundColor: ColorUtilities.whiteColor.withOpacity(0.05),
//                             child:Image.asset(AssetUtilities.unSelectedMenu,height: 35,width: 35,fit: BoxFit.fill,)
//                           ),
//                           SizedBox(height: 10,),
//                           Text("Tap here to scan face",style: FontUtilities.h16(color: ColorUtilities.whiteColor.withOpacity(0.7),fontFamily: FontFamily.interMedium),)
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         );
//       }
//     );
//   }
// }
//
// class FacePainter extends CustomPainter {
//   List<Recognition> facesList;
//   dynamic imageFile;
//   FacePainter({required this.facesList, @required this.imageFile});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (imageFile != null) {
//       canvas.drawImage(imageFile, Offset.zero, Paint());
//     }
//
//     Paint p = Paint();
//     p.color = Colors.red;
//     p.style = PaintingStyle.stroke;
//     p.strokeWidth = 3;
//
//     for (Recognition rectangle in facesList) {
//       canvas.drawRect(rectangle.location, p);
//
//       TextSpan span = TextSpan(
//           style: const TextStyle(color: Colors.white, fontSize: 30),
//           text: " ");
//       TextPainter tp = TextPainter(
//           text: span,
//           textAlign: TextAlign.left,
//           textDirection: TextDirection.ltr);
//       tp.layout();
//       tp.paint(canvas, Offset(rectangle.location.left, rectangle.location.top));
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
