
class ApiUrlUtilities{
  static const String baseUrl = "http://app.faceaxis.com/api/";

  // static const String baseUrl = "https://testhrms.server55.net/api/";
  static const String verifyEmployee = "${baseUrl}verifyemployee";
  static const String getProjects = "${baseUrl}get-projects";
  static const String getDivision = "${baseUrl}divisions";
  static const String getTime = "${baseUrl}timesheet-employee/";
  static const String punchIn = "${baseUrl}clockin/";
  static const String punchOut = "${baseUrl}clockout/";
  static const String getAttendanceList = "${baseUrl}attandance-blue-list/";
  static const String findFace = "${baseUrl}find-face-employee/";
  static const String updateAttendanceWithImage = "${baseUrl}addblueempattendance/";
  static const String getEmployeeList = "${baseUrl}emplist";
  static const String updateFaceId = "${baseUrl}facerecognition";
  static const String detectFace = "https://testhrms.server55.net/faceapp/detect_api";
  static const String recognitionFaceId = "${baseUrl}embedded-list";
  static const String getRecentActivities = "${baseUrl}recent-activities/";
  static const String multiplePunchOut = "${baseUrl}punch-out-attandance-blue-list";
  static const String getAttendanceEmployee = "${baseUrl}get-attandance-employee/";
  static const String getEmbeddings = "${baseUrl}get-all-face";
  static const String markAbsent = "${baseUrl}mark-absent";
}