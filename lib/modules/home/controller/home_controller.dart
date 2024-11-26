import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:FaceAxis/main.dart';
import 'package:FaceAxis/modules/home/model/attendance_list_model.dart';
import 'package:FaceAxis/modules/home/model/employee_list_model.dart';
import 'package:FaceAxis/modules/home/model/find_face_model.dart';
import 'package:FaceAxis/modules/home/model/recent_activities_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:FaceAxis/modules/home/view/add_employee_screen.dart';
import 'package:FaceAxis/modules/home/view/attendance_screen.dart';
import 'package:FaceAxis/modules/home/view/success_screen%20.dart';
import 'package:FaceAxis/modules/punch/model/projects_data_model.dart';
import 'package:FaceAxis/modules/punch/view/punch_attendance_screen.dart';
import 'package:FaceAxis/modules/recognition/model/recognition_data_face_model.dart';
import 'package:FaceAxis/routes/app_routes.dart';
import 'package:FaceAxis/services/api_services.dart';
import 'package:FaceAxis/services/api_url.dart';
import 'package:FaceAxis/utilities/color_utilities.dart';
import 'package:FaceAxis/utilities/font_utilities.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:FaceAxis/widgets/common_button.dart';
import 'package:FaceAxis/widgets/common_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  RxInt selectedIndex = 0.obs;
  RxBool isSelectTabOpen = false.obs;
  RxBool isChecked = false.obs;
  RxInt selectedTap = 0.obs;
  RxList<AttendanceListModel> attendanceListData = <AttendanceListModel>[].obs;
  RxList<AttendanceListModel> attendanceList = <AttendanceListModel>[].obs;
  RxList<EmployeeListModel> employeeListData = <EmployeeListModel>[].obs;
  RxList<RecentActivitiesModel> recentActivitiesData =
      <RecentActivitiesModel>[].obs;
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController changeStatusController = TextEditingController();
  List statusList = ["Idle","Working","Weekly Off"];
  RxString statusValue = "Select Status".obs;
  RxBool isStatusDropDownOpen = false.obs;
  RxBool isDepartmentDropDown = false.obs;
  RxString isDepartmentValue = "".obs;
  var selectedImagePath = ''.obs;
  RxBool isLoading = false.obs;
  RxList<int> punchingId = <int>[].obs;
  RxInt totalPresentAttendance = 0.obs;
  RxInt totalAbsentAttendance = 0.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString address = "".obs;
  RxList<ProjectDataModel> projectData = <ProjectDataModel>[].obs;
  Rx<FindFaceModel> findFaceModel = FindFaceModel().obs;
  RxBool isFaceIdRequired = false.obs;
  RxString filePath = "".obs;
  List<String> tageList = ["Project","Attendance","Employees","Recent Activities"];
  RxInt selectedTagIndex  = 0.obs;
  RxBool isFaceDetect = false.obs;




  late CameraController  _cameraController;

  CameraController get cameraController => _cameraController;

  set cameraController(CameraController value) {
    _cameraController = value;
    update();
  }

  RxBool isInitializedCamera = false.obs;
  Rx<File> _image = File("").obs;
  Rx<CameraDescription> description = cameras[1].obs;
  Rx<CameraLensDirection>  camDirec = CameraLensDirection.front.obs;
  Rx<RecognitionDataFaceModel> recognitionData = RecognitionDataFaceModel().obs;

  initializeCamera() async{
    isLoading.value = true;
    cameraController=CameraController(description.value,ResolutionPreset.high);
    await cameraController.initialize();
    isInitializedCamera.value = true;
    Timer(Duration(seconds: 2), () async{
      XFile? pickedFile = await cameraController.takePicture();
      if (pickedFile != null) {
        _image.value = File(pickedFile.path);
        selectedImagePath.value = pickedFile.path;
        debugPrint("Image :::${_image.value}");
        isInitializedCamera.value = false;
        await recognitionImage();
      }else{
        isLoading.value = false;
      }
    });
    update();
  }

  initializeCameraUpload() async{
    isLoading.value = true;
    cameraController=CameraController(description.value,ResolutionPreset.high);
    await cameraController.initialize();
    isInitializedCamera.value = true;
    Timer(Duration(seconds: 2), () async{
      XFile? pickedFile = await cameraController.takePicture();
      if (pickedFile != null) {
        _image.value = File(pickedFile.path);
        selectedImagePath.value = pickedFile.path;
        debugPrint("Image :::${_image.value}");
        isInitializedCamera.value = false;
        isLoading.value = false;
        Get.to(AddEmployeeScreen());
      }else{
        isLoading.value = false;
      }
    });
    update();
  }

  Future<void> recognitionImage() async {
    isLoading.value = true;
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${ApiUrlUtilities.baseUrl}recognize"));
    request.files.add(
        await http.MultipartFile.fromPath('image', selectedImagePath.value??""));
    request.headers.addAll(
        {'authkey': VariableUtilities.storage.read(KeyUtilitiess.userToken)});
    final response = await http.Response.fromStream(await request.send());
    print(response.runtimeType);
    print("RESPONSE  ::${response.body}");
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)["id"] != null){
        isLoading.value = false;
        recognitionData.value = recognitionDataFaceModelFromJson(response.body);
        Get.to(AttendanceScreen(isRecognition: true,userName:recognitionData.value.name,userId: recognitionData.value.employeeCode,));
      }else{
        isLoading.value = false;
        Get.dialog(Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Dialog(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10,),
                    Text("Your Face not Found",style: FontUtilities.h16(color: ColorUtilities.blackColor,fontFamily: FontFamily.interMedium)),
                    SizedBox(height: 60
                      ,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CommonButton(buttonName: "Retry",onTap: (){

                            Get.back();
                            // Get.offNamed(Routes.home);
                          },height: 40,),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ),
        ));
      }
    } else {
      isLoading.value = false;
      Get.dialog(Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Dialog(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10,),
                  Text("Your Face not Match",style: FontUtilities.h16(color: ColorUtilities.blackColor,fontFamily: FontFamily.interMedium)),
                  SizedBox(height: 60
                    ,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CommonButton(buttonName: "Add Face",onTap: (){
                          Get.off(AddEmployeeScreen());
                        },height: 40,),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: CommonButton(buttonName: "Retry",onTap: (){
                          Get.offNamed(Routes.home);
                        },height: 40,),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ));
      // AppSnackBar.customSnackBar(
      //     message: "${response.statusCode}", isError: true);
    }
  }

  Future<void> uploadImage(String empCode) async {
    isLoading.value = true;
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${ApiUrlUtilities.baseUrl}uploadImage"));
    request.files.add(
        await http.MultipartFile.fromPath('image', selectedImagePath.value??""));
    request.headers.addAll(
        {'authkey': VariableUtilities.storage.read(KeyUtilitiess.userToken)});
    request.fields['empCode'] = empCode;
    var response = await request.send();
    if (response.statusCode == 200) {
      isLoading.value = false;
      await registerEmployee();
      Get.off(FaceIDAddedSuccessfullyScreen(userId: empCode,));
      AppSnackBar.customSnackBar(
          message: "Face Added Successfully", isError: false);
    } else {
      isLoading.value = false;
      AppSnackBar.customSnackBar(
          message: "${response.statusCode}", isError: true);
    }
  }

  Future<void> registerEmployee() async {
    final response = await API.callAPI(
        url: "${ApiUrlUtilities.baseUrl}registerUser",
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilitiess.userToken)
        });
    print("Response :$response");

    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        print("Response :${response}");
      }
    }
  }

  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      // Request permission to use location
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle if the user denied permission
        // You may want to show a dialog to explain why you need the location permission
        return Future.error('Location permission denied');
      }

      // Get the current position
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = currentPosition.latitude;
      longitude.value = currentPosition.longitude;
      await getAddressFromLatLng();
    } catch (e) {
      // Handle any exceptions thrown during the process
      print('Error getting location: $e');
      return Future.error('Error getting location: $e');
    }
  }

  Future<void> getAddressFromLatLng() async {
    await placemarkFromCoordinates(latitude.value, longitude.value)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      address.value = place.administrativeArea ?? "";
      print(
          "${place.name} ${place.country} ${place.administrativeArea}, ${place.subAdministrativeArea}, ${place.locality} ${place.subLocality}");
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> getImageFromCamera() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      print("SelectedPath ::${selectedImagePath.value}");
    }
    Get.to(AttendanceScreen(
      isRecognition: false,
    ));
  }

  void openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        filePath.value = result.files.single.path ?? "";
        print("File path: ${result.files.single.path}");
        print("File name: ${result.files.single.name}");
      } else {
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  Future<void> uploadEmployeeAttendanceWithImage() async {
    isLoading.value = true;
    print(
        "URL IMAGE : https://testhrms.server55.net/api/addblueempattendance/${VariableUtilities.storage.read(KeyUtilities.id)}");
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "https://testhrms.server55.net/api/addblueempattendance/${VariableUtilities.storage.read(KeyUtilities.id)}"));
    request.files.add(
        await http.MultipartFile.fromPath('image', selectedImagePath.value));
    request.headers.addAll(
        {'authkey': VariableUtilities.storage.read(KeyUtilitiess.userToken)});
    request.fields['blue_emp_id'] = employeeIdController.text;
    request.fields["clock_in"] = DateFormat("HH:mm:ss").format(DateTime.now());
    request.fields["clock_out"] = "00:00:00";
    request.fields["date"] = DateFormat("yyyy-MM-dd").format(DateTime.now());
    request.fields["latitude"] =
        latitude.value.toString();
    request.fields["longitude"] =
        longitude.value.toString();
    request.fields['location'] =
        address.value.toString();
    request.fields['status'] = "Present";

    print("Request ::${request.files.first.filename}");
    var response = await request.send();
    print("${request.fields}");
    if (response.statusCode == 200) {
      Get.back();
      await getAttendance();
      isLoading.value = false;
      AppSnackBar.customSnackBar(
          message: "Attendance Successfully!", isError: false);
      Get.offNamed(Routes.home);
      employeeIdController.text = "";
      statusValue.value = "select status";
    } else {
      isLoading.value = false;
      AppSnackBar.customSnackBar(
          message: "${response.statusCode}", isError: true);
    }
    print("Response ::: ${response.request}");
    print("Response  :::: ${response.statusCode}");
  }

  Future<void> punchIn(String userId) async {
    isLoading.value = true;
    DateTime currentTime = DateTime.now();
    final response = await API.callAPI(
        url:
        "${ApiUrlUtilities.punchIn}$userId",
        type: APIType.tPost,
        header: {
          "authkey": VariableUtilities.storage.read(KeyUtilitiess.userToken)
        },
        body: {
          "project_id": VariableUtilities.storage.read(KeyUtilities.departmentId),
          "division_id": VariableUtilities.storage.read(KeyUtilities.divisionId),
          "clock_in": DateFormat("HH:mm").format(DateTime.now()),
          "location": address.value.toString(),
          "latitude": latitude.value.toString(),
          "longitude": longitude.value.toString(),
          "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
          "status": "present",
          "working_status": statusValue.value,
          "late": DateTime(
              currentTime.year, currentTime.month, currentTime.day, int.parse("${VariableUtilities.storage.read(KeyUtilities.startShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.startShift)}".split(":")[1]))
              .difference(DateTime.now())
              .abs()
              .toString(),
        });

    print("Response ::$response");
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        Get.back();
        Get.back();
        await getAttendance();
        isLoading.value = false;
        Get.offNamed(Routes.punch);
        employeeIdController.clear();
        AppSnackBar.customSnackBar(message: response["message"], isError: false);
      }
    }
  }

  Future<void> punchInAll(String employeeId) async {
    isLoading.value = true;
    DateTime currentTime = DateTime.now();
    print(
        "");
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${ApiUrlUtilities.punchIn}${employeeId.toString()}"));
    request.files.add(
        await http.MultipartFile.fromPath('image', selectedImagePath.value));
    request.headers.addAll(
        {'authkey':VariableUtilities.storage.read(KeyUtilitiess.userToken)});

    request.fields['project_id'] = VariableUtilities.storage.read(KeyUtilities.departmentId).toString();
    request.fields['division_id'] = VariableUtilities.storage.read(KeyUtilities.divisionId).toString();
    request.fields["clock_in"] = DateFormat("HH:mm").format(DateTime.now());
    request.fields["date"] = DateFormat("yyyy-MM-dd").format(DateTime.now());
    request.fields["latitude"] =
        latitude.value.toString();
    request.fields["longitude"] =
        longitude.value.toString();
    request.fields['location'] =
        address.value.toString();
    request.fields['status'] = "Present";
    request.fields['working_status'] = statusValue.value.toString();
    request.fields['late'] = DateTime(
        currentTime.year, currentTime.month, currentTime.day, int.parse("${VariableUtilities.storage.read(KeyUtilities.startShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.startShift)}".split(":")[1]))
        .difference(DateTime.now())
        .abs()
        .toString();
    print("Request ::${request.files.first.filename}");
    var response = await request.send();
    print("${request.fields}");
    if (response.statusCode == 200) {
      // Get.back();
      Get.back();
      await getAttendance();
      isLoading.value = false;
      AppSnackBar.customSnackBar(
          message: "Attendance Successfully!", isError: false);
      Get.offNamed(Routes.home);
      employeeIdController.text = "";
      statusValue.value = "select status";

    } else {
      isLoading.value = false;
      AppSnackBar.customSnackBar(
          message: "${response.statusCode}", isError: true);
    }

    print("Response ::: ${response.request}");
    print("Response  :::: ${response.statusCode}");
  }
  Future<void> logOut() async {
    isLoading.value = true;
    DateTime currentTime = DateTime.now();
    final response = await API.callAPI(
      url: "${ApiUrlUtilities.punchOut}${VariableUtilities.storage.read(KeyUtilities.id)}/${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
      type: APIType.tPost,
      header: {
        "authkey": VariableUtilities.storage.read(KeyUtilitiess.userToken),
      },
      body: {
        "clock_out": DateFormat("HH:mm").format(DateTime.now()),
        "early_leaving": (DateTime.now().difference(DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]),
          int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]),
        )) >
            Duration.zero)
            ? ""
            : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]),
            int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))
            .difference(DateTime.now())
            .abs()
            .toString(),
        "overtime": (DateTime.now().difference(DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]),
          int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]),
        )) >
            Duration.zero)
            ? DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]),
            int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))
            .difference(DateTime.now())
            .abs()
            .toString()
            : "",
        "total_rest": "",
      },
    );

    print("Response ::$response");
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") == "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
            message: response.replaceFirst("error_", ""),
            isError: true,
          );
          isLoading.value = false;
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
            message: response.replaceFirst("error_", ""),
            isError: true,
          );
        }
      } else {
        isLoading.value = false;

        // Erase only attendance ID
        VariableUtilities.storage.read(KeyUtilitiess.userToken);

        Get.offAllNamed(Routes.punch);
        AppSnackBar.customSnackBar(message: response["message"], isError: false);
      }
    }
  }

  Future<void> punchOut() async {
    isLoading.value = true;
    DateTime currentTime = DateTime.now();
    final response = await API.callAPI(
      url: "${ApiUrlUtilities.punchOut}${VariableUtilities.storage.read(KeyUtilities.id)}/${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
      type: APIType.tPost,
      header: {
        "authkey": VariableUtilities.storage.read(KeyUtilitiess.userToken),
      },
      body: {
        "clock_out": DateFormat("HH:mm").format(DateTime.now()),
        "early_leaving": (DateTime.now().difference(DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]),
          int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]),
        )) >
            Duration.zero)
            ? ""
            : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]),
            int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))
            .difference(DateTime.now())
            .abs()
            .toString(),
        "overtime": (DateTime.now().difference(DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]),
          int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]),
        )) >
            Duration.zero)
            ? DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]),
            int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))
            .difference(DateTime.now())
            .abs()
            .toString()
            : "",
        "total_rest": "",
      },
    );

    print("punchout........Response ::$response");
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") == "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
            message: response.replaceFirst("error_", ""),
            isError: true,
          );
          isLoading.value = false;
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
            message: response.replaceFirst("error_", ""),
            isError: true,
          );
        }
      } else {
        isLoading.value = false;

        // Erase only attendance ID
        // attendanceListData.clear();
        VariableUtilities.storage.remove(KeyUtilities.endTime);

        Get.offAllNamed(Routes.splash);
        // AppSnackBar.customSnackBar(message: response["message"], isError: false);
      }
    }
  }

  // Future<void> punchOut() async {
  //   isLoading.value = true;
  //   DateTime currentTime = DateTime.now();
  //   final response = await API.callAPI(
  //       url:
  //       "${ApiUrlUtilities.punchOut}${VariableUtilities.storage.read(KeyUtilities.id)}/${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
  //       type: APIType.tPost,
  //       header: {
  //         "authkey": VariableUtilities.storage.read(KeyUtilities.userToken)
  //       },
  //       body: {
  //         "clock_out": DateFormat("HH:mm").format(DateTime.now()),
  //         "early_leaving": (DateTime.now().difference(DateTime(currentTime.year,
  //             currentTime.month, currentTime.day, int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))) >
  //             Duration.zero)
  //             ? ""
  //             : DateTime(currentTime.year, currentTime.month, currentTime.day,
  //             int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))
  //             .difference(DateTime.now())
  //             .abs()
  //             .toString(),
  //         "overtime": (DateTime.now().difference(DateTime(currentTime.year,
  //             currentTime.month, currentTime.day, int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))) >
  //             Duration.zero)
  //             ? DateTime(currentTime.year, currentTime.month, currentTime.day,
  //             int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))
  //             .difference(DateTime.now())
  //             .abs()
  //             .toString()
  //             : "",
  //         "total_rest": ""
  //       });
  //
  //   print("Response ::$response");
  //   if (response != null) {
  //     if (response.runtimeType == String && response.contains("error_")) {
  //       if (response.replaceFirst("error_", "") ==
  //           "Your account is inactive, please contact admin") {
  //         AppSnackBar.customSnackBar(
  //             message: response.replaceFirst("error_", ""), isError: true);
  //         isLoading.value = false;
  //       } else {
  //         isLoading.value = false;
  //         AppSnackBar.customSnackBar(
  //             message: response.replaceFirst("error_", ""), isError: true);
  //       }
  //     } else {
  //       isLoading.value = false;
  //       await VariableUtilities.storage.erase();
  //       Get.offAllNamed(Routes.punch);
  //       AppSnackBar.customSnackBar(message: response["message"], isError: false);
  //     }
  //   }
  // }

  Future<void> getDepartment() async {
    projectData.clear();
    final response = await API.callAPI(
        url: ApiUrlUtilities.getProjects,
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilitiess.userToken)
        });
    print("Response :$response");

    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        response.forEach((element) {
          projectData.add(ProjectDataModel.fromJson(element));
        });
      }
    }
  }

  Future<void> multiplePunchOutEmployee() async {
    isLoading.value = true;
    final response = await API.callAPI(
        url:
            ApiUrlUtilities.multiplePunchOut,
        type: APIType.tPost,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilitiess.userToken),
        },
        body: {
          "clock_out": DateFormat("HH:mm:ss").format(DateTime.now()),
          "ids": punchingId
        });
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        await getAttendance();
        isLoading.value = false;
        isSelectTabOpen.value = false;
        punchingId.clear();
      }
    }
  }

  Future<void> getAttendance() async {
    isLoading.value = true;
    attendanceListData.clear();
    attendanceList.clear();
    final response = await API.callAPI(
        url:
            "${ApiUrlUtilities.getAttendanceList}${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilitiess.userToken)
        });
    print("Response :$response");
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        response.forEach((element) {
          attendanceListData.add(AttendanceListModel.fromJson(element));
        });
        attendanceListData.forEach((element) {
          if(element.employeeDetail?.id != VariableUtilities.storage.read(KeyUtilities.id)){
            attendanceList.add(element);
          }

        });
        print("response ::$response");
      }
    }
  }

  Future<void> getFindFaces() async {
    isLoading.value = true;
    attendanceListData.clear();
    final response = await API.callAPI(
        url:
        "${ApiUrlUtilities.findFace}${employeeIdController.text}",
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilitiess.userToken)
        });
    print("Response :$response");
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          findFaceModel.value.userId = null;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        isLoading.value = false;
          findFaceModel.value = FindFaceModel.fromJson(response);
        print("response  ::: ${isFaceIdRequired.value}");
      }
    }
  }

  Future<void> getEmployee() async {
    final response = await API.callAPI(
        url: ApiUrlUtilities.getEmployeeList,
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilitiess.userToken)
        });
    print("Response :$response");
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        response.forEach((element) {
          employeeListData.add(EmployeeListModel.fromJson(element));
        });
        isLoading.value = false;
      }
    }
  }

  Future<void> getRecentActivities() async {
    isLoading.value = true;
    final response = await API.callAPI(
        url:
            "${ApiUrlUtilities.getRecentActivities}${VariableUtilities.storage.read(KeyUtilities.attendanceId)}",
        type: APIType.tGet,
        header: {
          "authKey":VariableUtilities.storage.read(KeyUtilitiess.userToken)
        });
    print('recent activity.........'+'${response}');
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
          print("recent api  issueeeeeeeeeeee");
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        isLoading.value = false;
        response.forEach((element) {
          recentActivitiesData.add(RecentActivitiesModel.fromJson(element));
        });
        print("Recent Activities ::$recentActivitiesData");
      }
    }
  }

  Future<void> changeStatus(String EmpId) async {
    isLoading.value = true;
    final response = await API.callAPI(
        url:
        ApiUrlUtilities.markAbsent,
        type: APIType.tPost,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilitiess.userToken),
        },
        body: {
          "employee_id": EmpId,
          "status": "Present",
          "working_status": statusValue.value,
        });
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        Get.back;
        await getAttendance();
        isLoading.value = false;
        AppSnackBar.customSnackBar(
            message: "Status Change Successfully", isError: false);
        Get.offNamed(Routes.home);
        statusValue.value.isEmpty;
        employeeIdController.clear();
      }
    }
  }

  Future<void> markAbsent() async {
    isLoading.value = true;
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            ApiUrlUtilities.markAbsent));
    request.files.add(
        await http.MultipartFile.fromPath('leave_image', filePath.value));
    request.headers.addAll(
        {'authkey': VariableUtilities.storage.read(KeyUtilitiess.userToken)});

    request.fields['employee_id'] = employeeIdController.text;
    request.fields['leave_reason'] = changeStatusController.text;
    request.fields['status'] = "Absent";
    request.fields['working_status'] = "Absent";
    print("Request ::${request.files.first.filename}");
    var response = await request.send();
    print("${request.fields}");
    if (response.statusCode == 200) {
      Get.back();
      await getAttendance();
      isLoading.value = false;
      AppSnackBar.customSnackBar(
          message: "Absent Add Successfully!", isError: false);
      Get.offNamed(Routes.home);
      employeeIdController.text = "";
      changeStatusController.text = "";

    } else {
      isLoading.value = false;
      AppSnackBar.customSnackBar(
          message: "${response.statusCode}", isError: true);
    }

    print("Response ::: ${response.request}");
    print("Response  :::: ${response.statusCode}");
  }

  // Future<void> getAttendanceEmployee() async {
  //   isLoading.value = true;
  //   final response = await API.callAPI(
  //       url:
  //           "${ApiUrlUtilities.getAttendanceEmployee}${VariableUtilities.storage.read(KeyUtilities.id)}",
  //       type: APIType.tGet,
  //       header: {
  //         "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
  //       });
  //   print("Response :${response}");
  //   if (response != null) {
  //     if (response.runtimeType == String && response.contains("error_")) {
  //       if (response.replaceFirst("error_", "") ==
  //           "Your account is inactive, please contact admin") {
  //         AppSnackBar.customSnackBar(
  //             message: response.replaceFirst("error_", ""), isError: true);
  //         isLoading.value = false;
  //       } else {
  //         isLoading.value = false;
  //         AppSnackBar.customSnackBar(
  //             message: response.replaceFirst("error_", ""), isError: true);
  //       }
  //     } else {
  //       totalPresentAttendance.value = response["totalPresentattendance"];
  //       totalAbsentAttendance.value = response["totalAbsentattendance"];
  //       print("TOTAL ${response}");
  //       isLoading.value = false;
  //     }
  //   }
  // }

  initApi() async {
    Future.wait([
      getAttendance(),
      getCurrentLocation(),
      getDepartment(),
      getRecentActivities(),
      //getAttendanceEmployee(),
    ]);
  }

  @override
  void onInit() async{
    // TODO: implement onInit
    var cameras= await availableCameras();
    description.value = cameras[0];
    cameraController = CameraController(description.value,ResolutionPreset.high);
    super.onInit();
    print("DEpartment Name ::${VariableUtilities.storage.read(KeyUtilities.departmentName)}");
    initApi();
  }
}
