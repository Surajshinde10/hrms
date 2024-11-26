// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:hrms/ML/Recognition.dart';
// import 'package:hrms/ML/Recognizer.dart';
// import 'package:hrms/main.dart';
// import 'package:hrms/modules/home/model/recognition_model.dart';
// import 'package:hrms/modules/home/view/add_employee_screen.dart';
// import 'package:hrms/modules/home/view/attendance_screen.dart';
// import 'package:hrms/modules/home/view/success_screen%20.dart';
// import 'package:hrms/modules/punch/view/punch_attendance_screen.dart';
// import 'package:hrms/modules/recognition/model/embedding_model.dart';
// import 'package:hrms/modules/recognition/model/recognition_data_face_model.dart';
// import 'package:hrms/routes/app_routes.dart';
// import 'package:hrms/services/api_services.dart';
// import 'package:hrms/utilities/color_utilities.dart';
// import 'package:hrms/utilities/font_utilities.dart';
// import 'package:hrms/utilities/variable_utilities.dart';
// import 'package:hrms/widgets/common_button.dart';
// import 'package:hrms/widgets/common_snackbar.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'dart:ui';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import '../../../services/api_url.dart';
//
// class RecognitionController extends GetxController{
//   late CameraController  _cameraController;
//
//   CameraController get cameraController => _cameraController;
//
//   set cameraController(CameraController value) {
//     _cameraController = value;
//     update();
//   }
//
//   RxBool isInitializedCamera = false.obs;
//
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     dispose();
//     super.dispose();
//   }
//
//   //TODO declare variables
//   late ImagePicker imagePicker;
//   Recognition? _recognition;
//   RxBool isData = false.obs;
//   RxBool isAdd = false.obs;
//   RxString empCode ="".obs;
//   RxList<EmbeddingData> embeddingData = <EmbeddingData>[].obs;
//   CameraImage? frame;
//   Rx<CameraDescription> description = cameras[1].obs;
//   Rx<CameraLensDirection>  camDirec = CameraLensDirection.front.obs;
//   Rx<RecognitionDataFaceModel> recognitionData = RecognitionDataFaceModel().obs;
//   Recognition? get recognition => _recognition;
//
//   set recognition(Recognition? value) {
//     _recognition = value;
//     update();
//   }
//
//   Rx<File> _image = File("").obs;
//   RxBool isLoading = false.obs;
//   RxBool isFaceDetect = false.obs;
//   Rx<RecognitionModel> recognitionModel = RecognitionModel().obs;
//   RxString selectedImagePath = "".obs;
//   // Rx<dynamic>? image;
//
//   //TODO declare detector
//   late FaceDetector faceDetector;
//
//   //TODO declare face recognizer
//   late Recognizer recognizer;
//
//
//   @override
//   void onInit() async{
//     // TODO: implement onInit
//     isData.value = Get.arguments["isHome"];
//     isAdd.value = Get.arguments["isAdd"];
//     empCode.value = Get.arguments["emp_id"];
//
//     print("ADDD:${isAdd.value}");
//     print("DAAT:${isData.value}");
//     print("EMPCODE:${empCode.value}");
//
//
//     //getEmbedding();
//
//     var cameras= await availableCameras();
//     description.value = (isData.value)?cameras[1]:cameras[0];
//     cameraController = CameraController(description.value,ResolutionPreset.high);
//
//     if(isAdd.value == true){
//       isFaceDetect.value = true;
//     }
//     print("DATA VALUEE :${isData.value}");
//     imagePicker = ImagePicker();
//
//     //TODO initialize face detector
//     // final options = FaceDetectorOptions();
//     // faceDetector = FaceDetector(options: options);
//     //
//     // //TODO initialize face recognizer
//     // recognizer = Recognizer();
//     super.onInit();
//   }
//   Future getAvailableCamera() async {
//     final  cameras= await availableCameras();
//     return cameras;
//   }
//   initializeCamera() async{
//     isLoading.value = true;
//     cameraController=CameraController(description.value,ResolutionPreset.high);
//     await cameraController.initialize();
//     isInitializedCamera.value = true;
//     print("Path::${cameraController.description}");
//     // cameraController.setFlashMode(FlashMode.always);
//     Timer(Duration(seconds: 2), () async{
//       XFile? pickedFile = await cameraController.takePicture();
//       if (pickedFile != null) {
//         _image.value = File(pickedFile.path);
//         selectedImagePath.value = pickedFile.path;
//         debugPrint("Image :::${_image.value}");
//          isInitializedCamera.value = false;
//
//         if(isFaceDetect.value && isData.value == true){
//           await uploadImage(VariableUtilities.storage.read(KeyUtilities.employeeCode));
//         }else if(isAdd.value && isData.value == false){
//           await uploadImage(empCode.value);
//         }else if(isData.value && (isAdd.value == false)){
//           await recognitionImage();
//         }else{
//           await recognitionImage();
//         }
//       }else{
//         isLoading.value = false;
//       }
//     });
//     update();
//   }
//
//
//   Future<void> uploadImage(String empCode) async {
//     isLoading.value = true;
//     var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(
//             "${ApiUrlUtilities.baseUrl}uploadImage"));
//     request.files.add(
//         await http.MultipartFile.fromPath('image', selectedImagePath.value??""));
//     request.headers.addAll(
//         {'authkey': VariableUtilities.storage.read(KeyUtilities.userToken)});
//     request.fields['empCode'] = empCode;
//     final response = await http.Response.fromStream(await request.send());
//     print("RESPONSE ::${response.body}");
//     if (response.statusCode == 200) {
//       isLoading.value = false;
//       if(isData.value){
//         isLoading.value = false;
//         Get.off(PunchAttendanceScreen(userId: VariableUtilities.storage.read(KeyUtilities.empCode),userName: VariableUtilities.storage.read(KeyUtilities.name),));
//         AppSnackBar.customSnackBar(
//             message: "Face Added Successfully", isError: false);
//       }else{
//         isLoading.value = false;
//         Get.off(FaceIDAddedSuccessfullyScreen(userId: empCode,));
//         AppSnackBar.customSnackBar(
//             message: "Face Added Successfully", isError: false);
//       }
//     } else {
//       isLoading.value = false;
//       AppSnackBar.customSnackBar(
//           message: "${response.statusCode}", isError: true);
//     }
//   }
//
//   Future<void> recognitionImage() async {
//     isLoading.value = true;
//     var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(
//             "${ApiUrlUtilities.baseUrl}recognize"));
//     request.files.add(
//         await http.MultipartFile.fromPath('image', selectedImagePath.value??""));
//     request.headers.addAll(
//         {'authkey': VariableUtilities.storage.read(KeyUtilities.userToken)});
//     final response = await http.Response.fromStream(await request.send());
//     print(response.runtimeType);
//     print("RESPONSE  ::${response}");
//     if (response.statusCode == 200) {
//       isLoading.value = false;
//        recognitionData.value = recognitionDataFaceModelFromJson(response.body);
//       if(isData.value){
//         isLoading.value = false;
//         Get.off(PunchAttendanceScreen(userName:recognitionData.value.name,userId: recognitionData.value.employeeCode,));
//       }else{
//         Get.back();
//         Get.back();
//         isLoading.value = false;
//         Get.to(AttendanceScreen(isRecognition: true,userName:recognitionData.value.name,userId: recognitionData.value.employeeCode,));
//       }
//     //  Get.offNamed(Routes.home);
//      // AppSnackBar.customSnackBar(message: "Punch In Successfully", isError: false);
//     } else {
//       if(isData.value){
//         Get.back();
//         Get.back();
//         isFaceDetect.value = true;
//         isLoading.value = false;
//         //Get.offNamed(Routes.punch);
//         AppSnackBar.customSnackBar(message: "Your Face not Match",isError: true);
//       }else{
//         isLoading.value = false;
//         isFaceDetect.value = true;
//         Get.dialog(Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Dialog(
//             child: Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(height: 10,),
//                     Text("Your Face not Match",style: FontUtilities.h16(color: ColorUtilities.blackColor,fontFamily: FontFamily.interMedium)),
//                     SizedBox(height: 60
//                       ,),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: CommonButton(buttonName: "Add Face",onTap: (){
//                             Get.off(AddEmployeeScreen());
//                           },height: 40,),
//                         ),
//                         SizedBox(width: 5,),
//                         Expanded(
//                           child: CommonButton(buttonName: "Retry",onTap: (){
//                             Get.offNamed(Routes.home);
//                           },height: 40,),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 10,),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//       }
//       // AppSnackBar.customSnackBar(
//       //     message: "${response.statusCode}", isError: true);
//     }
//   }
//
//
//   Future<void> getEmbedding() async {
//     embeddingData.clear();
//     final response = await API.callAPI(
//         url: ApiUrlUtilities.getEmbeddings,
//         type: APIType.tGet,
//         header: {
//           "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
//         });
//     print("Response :$response");
//
//     if (response != null) {
//       if (response.runtimeType == String && response.contains("error_")) {
//         if (response.replaceFirst("error_", "") ==
//             "Your account is inactive, please contact admin") {
//           AppSnackBar.customSnackBar(
//               message: response.replaceFirst("error_", ""), isError: true);
//           isLoading.value = false;
//         } else {
//           isLoading.value = false;
//           AppSnackBar.customSnackBar(
//               message: response.replaceFirst("error_", ""), isError: true);
//         }
//       } else {
//         response.forEach((element) {
//           embeddingData.add(EmbeddingData.fromJson(element));
//         });
//
//       }
//     }
//   }
//
//
//   //TODO capture image using camera
//   imgFromCamera() async {
//     isLoading.value = true;
//     XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//         _image.value = File(pickedFile.path);
//         debugPrint("Image :::${_image.value}");
//         await doFaceDetection();
//     }else{
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> toggleCameraDirection() async {
//     if (camDirec == CameraLensDirection.back) {
//       camDirec.value = CameraLensDirection.front;
//       description.value = cameras[1];
//     } else {
//       camDirec.value = CameraLensDirection.back;
//       description.value = cameras[0];
//     }
//     // await cameraController.stopImageStream().then((value){
//     //   isInitializedCamera.value = true;
//     //   cameraController = CameraController(description.value, ResolutionPreset.high);
//     //   update();
//     //
//     // }
//     // );
//     await initializeCamera();
//     update();
//   }
//
//   // //TODO choose image using gallery
//   // _imgFromGallery() async {
//   //   XFile? pickedFile =
//   //   await imagePicker.pickImage(source: ImageSource.camera);
//   //   if (pickedFile != null) {
//   //     setState(() {
//   //       _image = File(pickedFile.path);
//   //       doFaceDetection();
//   //     });
//   //   }
//   // }
//
//   var _shortImage;
//
//   get shortImage => _shortImage;
//
//   set shortImage(value) {
//     _shortImage = value;
//     update();
//   }
//
//   //TODO face detection code here
//   RxList<Face> faces = <Face>[].obs;
//   Future doFaceDetection() async {
//
//     recognitions.clear();
//     //TODO remove rotation of camera images
//     _image.value = await removeRotation(_image.value);
//     shortImage = await decodeImageFromList(await _image.value.readAsBytes());
//
//     //TODO passing input to face detector and getting detected faces
//     InputImage inputImage = InputImage.fromFile(_image.value);
//     faces.value = await faceDetector.processImage(inputImage);
//
//     if(faces.isNotEmpty){
//       for (Face face in faces) {
//         Rect faceRect = face.boundingBox;
//         num left = faceRect.left < 0 ? 0 : faceRect.left;
//         num top = faceRect.top < 0 ? 0 : faceRect.top;
//         num right =
//         faceRect.right > shortImage.width ? shortImage.width - 1 : faceRect.right;
//         num bottom =
//         faceRect.bottom > shortImage.height ? shortImage.height - 1 : faceRect.bottom;
//         num width = right - left;
//         num height = bottom - top;
//
//         //TODO crop face
//         final bytes = _image!.value.readAsBytesSync(); //await File(cropedFace!.path).readAsBytes();
//         img.Image? faceImg = img.decodeImage(bytes!);
//         img.Image faceImg2 = img.copyCrop(faceImg!,
//             x: left.toInt(),
//             y: top.toInt(),
//             width: width.toInt(),
//             height: height.toInt());
//         recognition = recognizer.recognize(faceImg2, faceRect);
//           if(recognition != null && faces.isNotEmpty){
//             recognitions.add(recognition!);
//             if(isAdd.value == true){
//               uploadFaceId();
//             }
//             else {
//               if(recognition!.distance < 1.25){
//                 print("EMPLOYYE IDD::${recognition?.name}${recognition?.distance}");
//                 if(isData.value){
//                   isLoading.value = false;
//                   Get.off(PunchAttendanceScreen(userName: recognition?.id,userId: recognition?.name,));
//                 }else{
//                   Get.back();
//                   Get.back();
//                   isLoading.value = false;
//                   Get.to(AttendanceScreen(isRecognition: true,userId: recognition?.name,userName: recognition?.id,));
//                 }
//                 // (isAdd.value == true)?await uploadFaceId(): await detectFaceId();
//               }else{
//                 isLoading.value = false;
//                 if(isData.value){
//                   isLoading.value = false;
//                   Get.offNamed(Routes.punch);
//                   AppSnackBar.customSnackBar(message: "Your Face not Match",isError: true);
//                 }else{
//                   isLoading.value = false;
//                   Get.dialog(Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Dialog(
//                       child: Container(
//
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               SizedBox(height: 10,),
//                               Text("Your Face not Match",style: FontUtilities.h16(color: ColorUtilities.blackColor,fontFamily: FontFamily.interMedium)),
//                               SizedBox(height: 60
//                                 ,),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: CommonButton(buttonName: "Add Face",onTap: (){
//                                       faces.clear();
//                                        Get.off(AddEmployeeScreen());
//                                     },height: 40,),
//                                   ),
//                                   SizedBox(width: 5,),
//                                   Expanded(
//                                     child: CommonButton(buttonName: "Retry",onTap: (){
//                                       faces.clear();
//                                       Get.offNamed(Routes.home);
//                                     },height: 40,),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 10,),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ));
//                 }
//               }
//             }
//           }else{
//             if(isData.value){
//               isLoading.value = false;
//               Get.offNamed(Routes.punch);
//               AppSnackBar.customSnackBar(message: "Your Face is not valid",isError: true);
//             }else{
//               Get.back();
//               Get.back();
//               isLoading.value = false;
//               Get.offNamed(Routes.home);
//               AppSnackBar.customSnackBar(message: "Your Face is not valid",isError: true);
//             }
//           }
//         log("Detect EMbeddings  :::${recognition?.embeddings}");
//         shortImage = await decodeImageFromList(await _image.value.readAsBytes());
//         debugPrint("${shortImage.width}   ${shortImage.height}");
//       }
//     }else{
//       if(isData.value){
//         isLoading.value = false;
//         Get.offNamed(Routes.punch);
//         AppSnackBar.customSnackBar(message: "Your Face is not valid",isError: true);
//       }else{
//         Get.back();
//         Get.back();
//         isLoading.value = false;
//         Get.offNamed(Routes.home);
//         AppSnackBar.customSnackBar(message: "Your Face is not valid",isError: true);
//       }
//     }
//     //TODO call the method to perform face recognition on detected faces
//   }
//
//
//   // Future drawRectangleAroundFaces() async {
//   //   shortImage = await decodeImageFromList(await _image.value.readAsBytes());
//   //   debugPrint("${shortImage.width}   ${shortImage.height}");
//   //   await detectFaceId();
//   // }
//
//   // Future<void> detectFaceId() async {
//   //   final response = await API.callAPI(
//   //       url:
//   //       ApiUrlUtilities.detectFace,
//   //       type: APIType.tPost,
//   //       header: {
//   //         "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
//   //       },
//   //       body: {
//   //         "detectedEmbeddings": recognition?.embeddings.toString(),
//   //       });
//   //   if (response != null) {
//   //     if (response.runtimeType == String && response.contains("error_")) {
//   //       if (response.replaceFirst("error_", "") ==
//   //           "Your account is inactive, please contact admin") {
//   //       } else {
//   //         if(response.replaceFirst("error_", "") == "Users Found"){
//   //
//   //             isLoading.value = false;
//   //
//   //         }else if(response.replaceFirst("error_", "") == "Users Not Found"){
//   //
//   //             isLoading.value = false;
//   //             isFaceDetect.value = true;
//   //             AppSnackBar.customSnackBar(
//   //                 message: "Face Does Not Match, Please Add Face", isError: true);
//   //
//   //         }
//   //         AppSnackBar.customSnackBar(
//   //             message: response.replaceFirst("error_", ""), isError: true);
//   //       }
//   //     }else{
//   //
//   //
//   //       debugPrint("Response == ${response["status"]}");
//   //
//   //       if(response["status"] == true){
//   //           debugPrint("Recognition model ::${response}");
//   //           recognitionModel.value = RecognitionModel.fromJson(response["data"]);
//   //           if(isData.value){
//   //             isLoading.value = false;
//   //             Get.off(PunchAttendanceScreen());
//   //           }else{
//   //             Get.back();
//   //             Get.back();
//   //             isLoading.value = false;
//   //             Get.to(AttendanceScreen(isRecognition: true,userId: recognitionModel.value.userId.toString(),));
//   //           }
//   //       }else{
//   //           isLoading.value = false;
//   //           isFaceDetect.value = true;
//   //           AppSnackBar.customSnackBar(
//   //               message: "Face Does Not Match, Please Add Face", isError: true);
//   //       }
//   //     }
//   //   }
//   // }
//
//
//   Future<void> uploadFaceId() async {
//
//     isLoading.value = true;
//     final response = await API.callAPI(
//         url: ApiUrlUtilities.updateFaceId,
//         type: APIType.tPost,
//         header: {
//           "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
//         },
//         body: {
//           "face_recog_id":
//           recognition?.embeddings.map((e) => e.toString()).join(','),
//           "emp_id": (empCode == "" )?VariableUtilities.storage.read(KeyUtilities.empCode): empCode.value
//         });
//     debugPrint("Response :${response}");
//     if (response != null) {
//       if (response.runtimeType == String && response.contains("error_")) {
//         if (response.replaceFirst("error_", "") ==
//             "Your account is inactive, please contact admin") {
//           AppSnackBar.customSnackBar(
//               message: response.replaceFirst("error_", ""), isError: true);
//             isLoading.value = false;
//         } else {
//             isLoading.value = false;
//           AppSnackBar.customSnackBar(
//               message: response.replaceFirst("error_", ""), isError: true);
//         }
//       } else {
//         recognizer.registerFaceInDB("XXX", recognition?.embeddings ?? []);
//           if(isData.value){
//             isLoading.value = false;
//             Get.off(PunchAttendanceScreen(userId: VariableUtilities.storage.read(KeyUtilities.name),userName: VariableUtilities.storage.read(KeyUtilities.empCode),));
//             AppSnackBar.customSnackBar(
//                 message: "Face Added Successfully", isError: false);
//           }else{
//             isLoading.value = false;
//             Get.off(FaceIDAddedSuccessfullyScreen());
//             AppSnackBar.customSnackBar(
//                 message: "Face Added Successfully", isError: false);
//           }
//       }
//     }
//   }
//
//   //TODO remove rotation of camera images
//   removeRotation(File inputImage) async {
//     final img.Image? capturedImage =
//     img.decodeImage(await File(inputImage.path).readAsBytes());
//     final img.Image orientedImage = img.bakeOrientation(capturedImage!);
//     return await File(_image!.value.path).writeAsBytes(img.encodeJpg(orientedImage));
//   }
//
//   //TODO perform Face Recognition
//
//   //TODO Face Registration Dialogue
//
//   //TODO draw rectangles
//
//
//   RxList<Recognition> recognitions = <Recognition>[].obs;
//
// }