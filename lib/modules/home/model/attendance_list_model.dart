// To parse this JSON data, do
//
//     final attendanceListModel = attendanceListModelFromJson(jsonString);

import 'dart:convert';

List<AttendanceListModel> attendanceListModelFromJson(String str) => List<AttendanceListModel>.from(json.decode(str).map((x) => AttendanceListModel.fromJson(x)));

String attendanceListModelToJson(List<AttendanceListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendanceListModel {
  int? id;
  String? employeeId;
  String? attendedEmpId;
  dynamic departmentId;
  String? divisionId;
  String? projectId;
  DateTime? date;
  String? status;
  String? workingStatus;
  String? clockIn;
  String? clockOut;
  String? location;
  String? latitude;
  String? longitude;
  String? late;
  dynamic earlyLeaving;
  dynamic overtime;
  dynamic totalRest;
  dynamic image;
  String? leaveReason;
  String? leaveImage;
  dynamic createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  EmployeeDetail? employeeDetail;
  bool isCheck = false;

  AttendanceListModel({
    this.id,
    this.employeeId,
    this.attendedEmpId,
    this.departmentId,
    this.divisionId,
    this.projectId,
    this.date,
    this.status,
    this.workingStatus,
    this.clockIn,
    this.clockOut,
    this.location,
    this.latitude,
    this.longitude,
    this.late,
    this.earlyLeaving,
    this.overtime,
    this.totalRest,
    this.image,
    this.leaveReason,
    this.leaveImage,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
    this.employeeDetail,
    required this.isCheck,
  });

  factory AttendanceListModel.fromJson(Map<String, dynamic> json) => AttendanceListModel(
    id: json["id"],
    employeeId: json["employee_id"].toString(),
    attendedEmpId: json["attended_emp_id"].toString(),
    departmentId: json["department_id"],
    divisionId: json["division_id"].toString(),
    projectId: json["project_id"].toString(),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    status: json["status"],
    workingStatus: json["working_status"],
    clockIn: json["clock_in"],
    clockOut: json["clock_out"],
    location: json["location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    late: json["late"],
    earlyLeaving: json["early_leaving"],
    overtime: json["overtime"],
    totalRest: json["total_rest"],
    image: json["image"],
    leaveReason: json["leave_reason"],
    leaveImage: json["leave_image"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    employeeDetail: json["employee_detail"] == null ? null : EmployeeDetail.fromJson(json["employee_detail"]),
    isCheck: json["isCheck"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "attended_emp_id": attendedEmpId,
    "department_id": departmentId,
    "division_id": divisionId,
    "project_id": projectId,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "status": status,
    "working_status": workingStatus,
    "clock_in": clockIn,
    "clock_out": clockOut,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "late": late,
    "early_leaving": earlyLeaving,
    "overtime": overtime,
    "total_rest": totalRest,
    "image": image,
    "leave_reason": leaveReason,
    "leave_image": leaveImage,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "employee_detail": employeeDetail?.toJson(),
    "isCheck":isCheck,
  };
}

class EmployeeDetail {
  int? id;
  String? userId;
  String? name;
  String? employeeCode;
  DateTime? dob;
  String? gender;
  String? faceRecogId;
  dynamic image;
  String? phone;
  String? address;
  String? email;
  String? password;
  String? authKey;
  String? employeeId;
  String? employeeHashCode;
  String? branchId;
  String? departmentId;
  String? designationId;
  DateTime? companyDoj;
  dynamic documents;
  dynamic accountHolderName;
  dynamic accountNumber;
  dynamic bankName;
  dynamic bankIdentifierCode;
  dynamic branchLocation;
  dynamic taxPayerId;
  dynamic salaryType;
  dynamic accountType;
  dynamic salary;
  String? isActive;
  String? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  EmployeeDetail({
    this.id,
    this.userId,
    this.name,
    this.employeeCode,
    this.dob,
    this.gender,
    this.faceRecogId,
    this.image,
    this.phone,
    this.address,
    this.email,
    this.password,
    this.authKey,
    this.employeeId,
    this.employeeHashCode,
    this.branchId,
    this.departmentId,
    this.designationId,
    this.companyDoj,
    this.documents,
    this.accountHolderName,
    this.accountNumber,
    this.bankName,
    this.bankIdentifierCode,
    this.branchLocation,
    this.taxPayerId,
    this.salaryType,
    this.accountType,
    this.salary,
    this.isActive,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory EmployeeDetail.fromJson(Map<String, dynamic> json) => EmployeeDetail(
    id: json["id"],
    userId: json["user_id"].toString(),
    name: json["name"],
    employeeCode: json["EmployeeCode"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    gender: json["gender"],
    faceRecogId: json["face_recog_id"],
    image: json["image"],
    phone: json["phone"],
    address: json["address"],
    email: json["email"],
    password: json["password"],
    authKey: json["auth_key"],
    employeeId: json["employee_id"],
    employeeHashCode: json["employee_hash_code"],
    branchId: json["branch_id"],
    departmentId: json["department_id"],
    designationId: json["designation_id"],
    companyDoj: json["company_doj"] == null ? null : DateTime.parse(json["company_doj"]),
    documents: json["documents"],
    accountHolderName: json["account_holder_name"],
    accountNumber: json["account_number"],
    bankName: json["bank_name"],
    bankIdentifierCode: json["bank_identifier_code"],
    branchLocation: json["branch_location"],
    taxPayerId: json["tax_payer_id"],
    salaryType: json["salary_type"],
    accountType: json["account_type"],
    salary: json["salary"],
    isActive: json["is_active"].toString(),
    createdBy: json["created_by"].toString(),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "EmployeeCode": employeeCode,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "face_recog_id": faceRecogId,
    "image": image,
    "phone": phone,
    "address": address,
    "email": email,
    "password": password,
    "auth_key": authKey,
    "employee_id": employeeId,
    "employee_hash_code": employeeHashCode,
    "branch_id": branchId,
    "department_id": departmentId,
    "designation_id": designationId,
    "company_doj": "${companyDoj!.year.toString().padLeft(4, '0')}-${companyDoj!.month.toString().padLeft(2, '0')}-${companyDoj!.day.toString().padLeft(2, '0')}",
    "documents": documents,
    "account_holder_name": accountHolderName,
    "account_number": accountNumber,
    "bank_name": bankName,
    "bank_identifier_code": bankIdentifierCode,
    "branch_location": branchLocation,
    "tax_payer_id": taxPayerId,
    "salary_type": salaryType,
    "account_type": accountType,
    "salary": salary,
    "is_active": isActive,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
