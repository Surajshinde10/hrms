import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:FaceAxis/main.dart';
import 'package:FaceAxis/modules/home/model/attendance_list_model.dart';
import 'package:FaceAxis/modules/home/model/find_face_model.dart';
import 'package:FaceAxis/modules/home/view/add_employee_screen.dart';
import 'package:FaceAxis/modules/punch/model/projects_data_model.dart';
import 'package:FaceAxis/modules/punch/model/divisions_data_model.dart';
import 'package:FaceAxis/modules/punch/model/time_model.dart';
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
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PunchingController extends GetxController {
  TextEditingController projectController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isPunchOut = false.obs;
  RxBool isFaceDetect = false.obs;
  RxBool isDepartmentDropDown = false.obs;
  RxString selectedDepartmentValue = "Select Projects".obs;
  RxInt selectedDepartmentIndex = 0.obs;
  RxInt selectedDepartmentId = 0.obs;
  RxBool isDivisionDropDown = false.obs;
  RxString selectedDivisionValue = "Select Division".obs;
  RxInt selectedDivisionIndex = 0.obs;
  RxInt selectedDivisionId = 0.obs;
  RxList<ProjectDataModel> projectData = <ProjectDataModel>[].obs;
  RxString statusValue = "Select Status".obs;

  RxList<String> departmentNameList = <String>[].obs;
  RxList departmentIdList = [].obs;
  List<DivisionsDataModel> divisionData = <DivisionsDataModel>[].obs;
  RxList divisionNameList = [].obs;
  RxList departmentSearchList = [].obs;
  RxList divisionIdList = [].obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  RxString address = "".obs;
  Rx<TimeModel> timeData = TimeModel().obs;
  RxString selectedImagePath = "".obs;
  Rx<RecognitionDataFaceModel> recognitionData = RecognitionDataFaceModel().obs;
  TextEditingController employeeIdController = TextEditingController();



  Future<void> getDepartment() async {
    projectData.clear();
    departmentNameList.clear();
    final response = await API.callAPI(
        url: ApiUrlUtilities.getProjects,
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
        });

    print("Response :${response}");

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
        projectData.forEach((element) {
          departmentNameList.add("${element.projectName}(${element.projectCode})" ?? "");
          departmentIdList.add(element.id);
        });

        print("Department data : ${departmentNameList}");
      }
    }
  }

  Future<void> getDivision() async {
    divisionData.clear();
    divisionNameList.clear();
    final response = await API.callAPI(
        url: ApiUrlUtilities.getDivision,
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
        });
    print("Response :${response}");

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
          divisionData.add(DivisionsDataModel.fromJson(element));
        });
        divisionData.forEach((element) {
          divisionNameList.add(element.name ?? "");
          divisionIdList.add(element.id ?? 0);
        });
        isLoading.value = false;
        print("Department data : ${divisionNameList}");
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

  // Future<void> punchIn(String userId) async {
  //   isLoading.value = true;
  //   DateTime currentTime = DateTime.now();
  //   print("Hello");
  //   final response = await API.callAPI(
  //       url:
  //       "${ApiUrlUtilities.punchIn}${userId}",
  //       type: APIType.tPost,
  //       header: {
  //         "authkey": VariableUtilities.storage.read(KeyUtilities.userToken)
  //       },
  //       body: {
  //         "project_id": selectedDepartmentId.value.toString(),
  //         "division_id": VariableUtilities.storage.read(KeyUtilities.divisionId),
  //         "clock_in": DateFormat("HH:mm").format(DateTime.now()),
  //         "location": address.value.toString(),
  //         "latitude": latitude.value.toString(),
  //         "longitude": longitude.value.toString(),
  //         "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
  //         "status": "Present",
  //         "working_status":"Working",
  //         "late": DateTime(
  //             currentTime.year, currentTime.month, currentTime.day, int.parse("${VariableUtilities.storage.read(KeyUtilities.startShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.startShift)}".split(":")[1]))
  //             .difference(DateTime.now())
  //             .abs()
  //             .toString(),
  //       });
  //
  //   print("Response ::${response}");
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
  //       getAttendance(userId.toString());
  //       VariableUtilities.storage.write(KeyUtilities.punchIn, 1);
  //       Get.offNamed(Routes.home);
  //       AppSnackBar.customSnackBar(message: response["message"], isError: false);
  //     }
  //   }
  // }

  Future<void> punchOut() async {
    isLoading.value = true;
    DateTime currentTime = DateTime.now();
    final response = await API.callAPI(
        url:
        "${ApiUrlUtilities.punchOut}${VariableUtilities.storage.read(KeyUtilities.id)}/${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
        type: APIType.tPost,
        header: {
          "authkey": VariableUtilities.storage.read(KeyUtilities.userToken)
        },
        body: {
          "clock_out": DateFormat("HH:mm").format(DateTime.now()),
          "early_leaving": (DateTime.now().difference(DateTime(currentTime.year,
              currentTime.month, currentTime.day, int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))) >
              Duration.zero)
              ? ""
              : DateTime(currentTime.year, currentTime.month, currentTime.day,
              int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))
              .difference(DateTime.now())
              .abs()
              .toString(),
          "overtime": (DateTime.now().difference(DateTime(currentTime.year,
              currentTime.month, currentTime.day, int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))) >
              Duration.zero)
              ? DateTime(currentTime.year, currentTime.month, currentTime.day,
              int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[0]), int.parse("${VariableUtilities.storage.read(KeyUtilities.endShift)}".split(":")[1]))
              .difference(DateTime.now())
              .abs()
              .toString()
              : "",
          "total_rest": ""
        });

    print("Response ::${response}");
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
        isLoading.value = false;
        isPunchOut.value = false;
        await VariableUtilities.storage.erase();
        Get.offAllNamed(Routes.splash);
        AppSnackBar.customSnackBar(message: response["message"], isError: false);
      }
    }
  }


  Future<void> punchInAll(String employeeId) async {
    isLoading.value = true;
    DateTime currentTime = DateTime.now();
    print(
        "");
    print(VariableUtilities.storage.read(KeyUtilities.employeeCode));
    print(VariableUtilities.storage.read(KeyUtilities.id));

    print(VariableUtilities.storage.read(KeyUtilities.empCode));
    print(VariableUtilities.storage.read(KeyUtilities.name));
    print(VariableUtilities.storage.read(KeyUtilities.attendanceId));



    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${ApiUrlUtilities.punchIn}${223344}"));
    request.files.add(
        await http.MultipartFile.fromPath('image', selectedImagePath.value));
    request.headers.addAll(
        {'authkey': VariableUtilities.storage.read(KeyUtilities.userToken)});

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
    request.fields['working_status'] = "Working";
    // request.fields['working_status'] = statusValue.value.toString();

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
      await getAttendance(employeeId.toString());
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

  Future<void> getTimeSchedule() async {
    print("Date Noe ::${DateFormat("HH:mm").format(DateTime.now())}");
    final response = await API.callAPI(
        url:
        "${ApiUrlUtilities.getTime}${VariableUtilities.storage.read(KeyUtilities.id)}",
        header: {
          "authkey": VariableUtilities.storage.read(KeyUtilities.userToken)
        },
        type: APIType.tGet);

    if(response != "" || response.toString().trim().isEmpty == false){
      if (response != null ) {
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
          timeData.value = TimeModel.fromJson(response);

          VariableUtilities.storage.write(KeyUtilities.startShift, timeData.value.startShift);
          VariableUtilities.storage.write(KeyUtilities.endShift, timeData.value.endShift);
          VariableUtilities.storage.write(KeyUtilities.startTime,
              "${timeData.value.startShift?.split(":")[0]} : ${timeData.value.startShift?.split(":")[1]} ${int.parse(timeData.value.startShift?.split(":")[0] ?? "9") < 12 ? "AM" : "PM"}");
          VariableUtilities.storage.write(KeyUtilities.endTime,
              "${timeData.value.endShift?.split(":")[0]} : ${timeData.value.endShift?.split(":")[1]} ${int.parse(timeData.value.endShift?.split(":")[0] ?? "9") < 12 ? "AM" : "PM"}");
          isLoading.value = false;
          print("time data : ${timeData}");
        }
      }
    }

  }

  RxList<AttendanceListModel> attendanceListData = <AttendanceListModel>[].obs;
  Rx<FindFaceModel> findFaceModel = FindFaceModel().obs;


  Future<void> getFindFaces() async {
    isLoading.value = true;
    attendanceListData.clear();
    final response = await API.callAPI(
        url:
        "${ApiUrlUtilities.findFace}${VariableUtilities.storage.read(KeyUtilities.empCode)}",
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
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
          Get.offNamed(Routes.recognition,arguments: {"isHome":true,"isAdd":true,"emp_id":""});
          AppSnackBar.customSnackBar(message: "Face Not Found!",isError: true);
        }
      } else {
        isLoading.value = false;
        findFaceModel.value = FindFaceModel.fromJson(response);
        if(findFaceModel.value.faceRecogId != null){
          Get.offNamed(Routes.recognition,arguments: {"isHome":true,"isAdd":false,"emp_id":""});
          AppSnackBar.customSnackBar(message: "Face Already Added!",isError: false);
        }else{
          Get.offNamed(Routes.recognition,arguments: {"isHome":true,"isAdd":true,"emp_id":""});
          AppSnackBar.customSnackBar(message: "Face Not Found!",isError: true);
        }
      }
    }
  }

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

  RxList<AttendanceListModel> attendanceList = <AttendanceListModel>[].obs;

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

  Future<void> getAttendance(String employeeId) async {
    isLoading.value = true;
    attendanceListData.clear();
    attendanceList.clear();
    final response = await API.callAPI(
        url:
        "${ApiUrlUtilities.getAttendanceList}${DateFormat("yyyy-MM-dd").format(DateTime.now())}",
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
        });
    print("Response :$response");
    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
          print("12345");
        } else {
          isLoading.value = false;
          AppSnackBar.customSnackBar(
              message: response.replaceFirst("error_", ""), isError: true);
          print("1234567");

        }
      } else {
        final storedAttendanceId = VariableUtilities.storage.read(KeyUtilities.attendanceId).toString();

        response.forEach((element) {
          attendanceListData.add(AttendanceListModel.fromJson(element));
        });

        attendanceListData.forEach((element) {
          if (element.employeeDetail?.id != storedAttendanceId) {
            attendanceList.add(element);
          }
        });

        print("response ::$response");
      }
    }
  }



  Future<void> uploadImage() async {
    isLoading.value = true;
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${ApiUrlUtilities.baseUrl}uploadImage"));
    request.files.add(
        await http.MultipartFile.fromPath('image', selectedImagePath.value??""));
    request.headers.addAll(
        {'authkey':VariableUtilities.storage.read(KeyUtilities.userToken)});
    request.fields['empCode'] = VariableUtilities.storage.read(KeyUtilities.employeeCode);
    final response = await http.Response.fromStream(await request.send());
    print("RESPONSE ::${response.body}");
    if (response.statusCode == 200) {
      registerEmployee();
      // Get.off(PunchAttendanceScreen(userId:VariableUtilities.storage.read(KeyUtilities.employeeCode),userName: VariableUtilities.storage.read(KeyUtilities.name),),);
      Get.to(PunchAttendanceScreen(userName: recognitionData.value.name, userId: recognitionData.value.id.toString(),
      ));

    AppSnackBar.customSnackBar(
          message: "Face Added Successfully", isError: false);
    } else {
      isLoading.value = false;
      AppSnackBar.customSnackBar(
          message: "${response.statusCode}", isError: true);
    }
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
        {'authkey': VariableUtilities.storage.read(KeyUtilities.userToken)});
    final response = await http.Response.fromStream(await request.send());
    print(response.runtimeType);
    print("RESPONSE  ::${response.body}");
    if (response.statusCode == 200) {
      if(jsonDecode(response.body)["id"] != null){
        isLoading.value = false;
        recognitionData.value = recognitionDataFaceModelFromJson(response.body);
    // Get.to(PunchAttendanceScreen(userId:VariableUtilities.storage.read(KeyUtilities.employeeCode),userName: VariableUtilities.storage.read(KeyUtilities.name)));

        Get.to(PunchAttendanceScreen(
          userName: recognitionData.value.name,
          userId: recognitionData.value.id.toString(),
        ));
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
                            Get.offNamed(Routes.punch);
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
                        child: CommonButton(buttonName: "Add Face",
                          onTap: (){
                          Get.back();
                          uploadImage();
                        },height: 40,),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: CommonButton(buttonName: "Retry",onTap: (){
                          Get.offNamed(Routes.punch);
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
  Future<void> registerEmployee() async {
    final response = await API.callAPI(
        url: "${ApiUrlUtilities.baseUrl}registerUser",
        type: APIType.tGet,
        header: {
          "authKey": VariableUtilities.storage.read(KeyUtilities.userToken)
        });
    print("Response :$response");

    if (response != null) {
      if (response.runtimeType == String && response.contains("error_")) {
        if (response.replaceFirst("error_", "") ==
            "Your account is inactive, please contact admin") {
          // AppSnackBar.customSnackBar(
          //     message: response.replaceFirst("error_", ""), isError: true);
          isLoading.value = false;
        } else {
          isLoading.value = false;
          // AppSnackBar.customSnackBar(
          //     message: response.replaceFirst("error_", ""), isError: true);
        }
      } else {
        print("Response=:${response}");
      }
    }
  }


  initApi() {
    Future.wait([
      getCurrentLocation(),
      getDepartment(),
      getTimeSchedule(),
    ]);
  }

  @override
  void onInit() async{
    initApi();
    var cameras= await availableCameras();
    description.value = cameras[1];
    cameraController = CameraController(description.value,ResolutionPreset.high);
    super.onInit();
    print("Punching ::${VariableUtilities.storage.read(KeyUtilities.departmentName)}");
  }
}
