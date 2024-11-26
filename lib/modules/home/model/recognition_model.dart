// To parse this JSON data, do
//
//     final recognitionModel = recognitionModelFromJson(jsonString);

import 'dart:convert';

RecognitionModel recognitionModelFromJson(String str) => RecognitionModel.fromJson(json.decode(str));

String recognitionModelToJson(RecognitionModel data) => json.encode(data.toJson());

class RecognitionModel {
  int? id;
  int? userId;
  String? name;
  String? employeeCode;
  DateTime? dob;
  String? gender;
  String? faceRecogId;
  String? phone;
  String? address;
  String? email;
  String? password;
  dynamic authKey;
  String? employeeId;
  String? employeeHashCode;
  int? branchId;
  int? departmentId;
  int? designationId;
  DateTime? companyDoj;
  String? documents;
  dynamic accountHolderName;
  dynamic accountNumber;
  dynamic bankName;
  dynamic bankIdentifierCode;
  dynamic branchLocation;
  dynamic taxPayerId;
  dynamic salaryType;
  dynamic accountType;
  dynamic salary;
  int? isActive;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  RecognitionModel({
    this.id,
    this.userId,
    this.name,
    this.employeeCode,
    this.dob,
    this.gender,
    this.faceRecogId,
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

  factory RecognitionModel.fromJson(Map<String, dynamic> json) => RecognitionModel(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    employeeCode: json["EmployeeCode"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    gender: json["gender"],
    faceRecogId: json["face_recog_id"],
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
    isActive: json["is_active"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "EmployeeCode": employeeCode,
    "dob": dob?.toIso8601String(),
    "gender": gender,
    "face_recog_id": faceRecogId,
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
