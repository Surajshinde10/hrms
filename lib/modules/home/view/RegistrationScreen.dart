// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:hrms/ML/Recognition.dart';
// import 'package:hrms/ML/Recognizer.dart';
// import 'package:hrms/modules/home/view/success_screen%20.dart';
// import 'package:hrms/services/api_services.dart';
// import 'package:hrms/services/api_url.dart';
// import 'package:hrms/utilities/asset_utilities.dart';
// import 'package:hrms/utilities/color_utilities.dart';
// import 'package:hrms/utilities/font_utilities.dart';
// import 'package:hrms/utilities/variable_utilities.dart';
// import 'package:hrms/widgets/common_button.dart';
// import 'package:hrms/widgets/common_snackbar.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
//
// class RegistrationScreen extends StatefulWidget {
//   const RegistrationScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RegistrationScreen> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<RegistrationScreen> {
//   //TODO declare variables
//
//   late ImagePicker imagePicker;
//   late Recognition recognition;
//   File? _image;
//   bool isLoading = false;
//   bool isFaceDetect = false;
//
//   //TODO declare detector
//   late FaceDetector faceDetector;
//
//   //TODO declare face recognizer
//   late Recognizer recognizer;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     imagePicker = ImagePicker();
//
//     //TODO initialize face detector
//     final options = FaceDetectorOptions();
//     faceDetector = FaceDetector(options: options);
//
//     //TODO initialize face recognizer
//     recognizer = Recognizer();
//   }
//
//   //TODO capture image using camera
//   _imgFromCamera() async {
//     XFile? pickedFile =
//         await imagePicker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         doFaceDetection();
//       });
//       setState(() {
//         isLoading = true;
//       });
//     }
//   }
//
//   //TODO face detection code here
//   List<Face> faces = [];
//   Future doFaceDetection() async {
//     //TODO remove rotation of camera images
//
//     _image = await removeRotation(_image!);
//     image = await _image?.readAsBytes();
//     image = await decodeImageFromList(image);
//
//     //TODO passing input to face detector and getting detected faces
//
//     InputImage inputImage = InputImage.fromFile(_image!);
//     faces = await faceDetector.processImage(inputImage);
//
//     for (Face face in faces) {
//       Rect faceRect = face.boundingBox;
//       num left = faceRect.left < 0 ? 0 : faceRect.left;
//       num top = faceRect.top < 0 ? 0 : faceRect.top;
//       num right =
//           faceRect.right > image.width ? image.width - 1 : faceRect.right;
//       num bottom =
//           faceRect.bottom > image.height ? image.height - 1 : faceRect.bottom;
//       num width = right - left;
//       num height = bottom - top;
//
//       //TODO crop face
//       final bytes = _image!
//           .readAsBytesSync(); //await File(cropedFace!.path).readAsBytes();
//       img.Image? faceImg = img.decodeImage(bytes!);
//       img.Image faceImg2 = img.copyCrop(faceImg!,
//           x: left.toInt(),
//           y: top.toInt(),
//           width: width.toInt(),
//           height: height.toInt());
//
//       setState(() {
//         recognition = recognizer.recognize(faceImg2, faceRect);
//       });
//
//       log("EMbeddings  :::${recognition.embeddings}");
//     }
//
//     drawRectangleAroundFaces();
//
//     //TODO call the method to perform face recognition on detected faces
//   }
//
//   //TODO remove rotation of camera images
//
//   removeRotation(File inputImage) async {
//     final img.Image? capturedImage =
//         img.decodeImage(await File(inputImage!.path).readAsBytes());
//     final img.Image orientedImage = img.bakeOrientation(capturedImage!);
//     return await File(_image!.path).writeAsBytes(img.encodeJpg(orientedImage));
//   }
//
//   Future<void> uploadFaceId() async {
//     setState(() {
//       isLoading = true;
//     });
//     final response = await API.callAPI(
//         url:
//             "${ApiUrlUtilities.updateFaceId}${VariableUtilities.storage.read(KeyUtilities.id)}",
//         type: APIType.tPost,
//         header: {
//           "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
//         },
//         body: {
//           "face_recog_id":
//               recognition.embeddings.map((e) => e.toString()).join(','),
//
//         });
//     print("Response :${response}");
//     if (response != null) {
//       if (response.runtimeType == String && response.contains("error_")) {
//         if (response.replaceFirst("error_", "") ==
//             "Your account is inactive, please contact admin") {
//           AppSnackBar.customSnackBar(
//               message: response.replaceFirst("error_", ""), isError: true);
//           setState(() {
//             isLoading = false;
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           AppSnackBar.customSnackBar(
//               message: response.replaceFirst("error_", ""), isError: true);
//         }
//       } else {
//         setState(() {
//           Get.back();
//           Get.back();
//           isLoading = false;
//         });
//         recognizer.registerFaceInDB("XXX", recognition.embeddings);
//         Get.off(FaceIDAddedSuccessfullyScreen());
//         AppSnackBar.customSnackBar(
//             message: response["message"], isError: false);
//       }
//     }
//   }
//
//   //TODO perform Face Recognition
//
//   //TODO Face Registration Dialogue
//
//   //TODO draw rectangles
//   var image;
//   drawRectangleAroundFaces() async {
//     image = await _image?.readAsBytes();
//     image = await decodeImageFromList(image);
//     print("${image.width}   ${image.height}");
//     setState(() {
//       image;
//       faces;
//       isLoading = false;
//       isFaceDetect = true;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             image != null
//                 ? Container(
//                     margin: const EdgeInsets.only(
//                         top: 60, left: 30, right: 30, bottom: 0),
//                     child: FittedBox(
//                       child: SizedBox(
//                         width: image.width.toDouble(),
//                         height: image.width.toDouble(),
//                         child: CustomPaint(
//                           painter:
//                               FacePainter(facesList: faces, imageFile: image),
//                         ),
//                       ),
//                     ),
//                   )
//                 : Container(
//                     margin: const EdgeInsets.only(top: 100),
//                     child: Image.asset(
//                       AssetUtilities.faceLogo,
//                       width: screenWidth - 100,
//                       height: screenWidth - 100,
//                     ),
//                   ),
//             Container(
//               height: 50,
//             ),
//             //TODO section which displays buttons for choosing and capturing images
//             (isLoading == true)
//                 ? Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 100),
//                       child: Text(
//                         "Loading....",
//                         style: FontUtilities.h18(
//                             color: ColorUtilities.blackColor,
//                             fontFamily: FontFamily.interBold),
//                       ),
//                     ),
//                   )
//                 : (isFaceDetect)
//                     ? CommonButton(
//                         onTap: () {
//                           uploadFaceId();
//                         },
//                         buttonName: "Confirm",
//                         width: screenWidth * 0.8,
//                       )
//                     : Container(
//                         margin: const EdgeInsets.only(bottom: 50),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Card(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(200))),
//                               child: InkWell(
//                                 onTap: () {
//                                   _imgFromCamera();
//                                 },
//                                 child: SizedBox(
//                                   width: screenWidth / 2 - 70,
//                                   height: screenWidth / 2 - 70,
//                                   child: Icon(Icons.camera,
//                                       color: Colors.blue,
//                                       size: screenWidth / 7),
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class FacePainter extends CustomPainter {
//   List<Face> facesList;
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
//     for (Face face in facesList) {
//       canvas.drawRect(face.boundingBox, p);
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
