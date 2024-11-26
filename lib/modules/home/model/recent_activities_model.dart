// To parse this JSON data, do
//
//     final recentActivitiesModel = recentActivitiesModelFromJson(jsonString);

import 'dart:convert';

List<RecentActivitiesModel> recentActivitiesModelFromJson(String str) => List<RecentActivitiesModel>.from(json.decode(str).map((x) => RecentActivitiesModel.fromJson(x)));

String recentActivitiesModelToJson(List<RecentActivitiesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecentActivitiesModel {
  int? id;
  String? employeeId;
  dynamic departmentId;
  String? divisionId;
  DateTime? date;
  String? status;
  String? clockIn;
  String? clockOut;
  String? location;
  String? latitude;
  String? longitude;
  String? late;
  String? earlyLeaving;
  dynamic overtime;
  dynamic totalRest;
  dynamic createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  RecentActivitiesModel({
    this.id,
    this.employeeId,
    this.departmentId,
    this.divisionId,
    this.date,
    this.status,
    this.clockIn,
    this.clockOut,
    this.location,
    this.latitude,
    this.longitude,
    this.late,
    this.earlyLeaving,
    this.overtime,
    this.totalRest,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory RecentActivitiesModel.fromJson(Map<String, dynamic> json) => RecentActivitiesModel(
    id: json["id"],
    employeeId: json["employee_id"].toString(),
    departmentId: json["department_id"],
    divisionId: json["division_id"].toString(),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    status: json["status"],
    clockIn: json["clock_in"],
    clockOut: json["clock_out"],
    location: json["location"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    late: json["late"],
    earlyLeaving: json["early_leaving"],
    overtime: json["overtime"],
    totalRest: json["total_rest"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "department_id": departmentId,
    "division_id": divisionId,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "status": status,
    "clock_in": clockIn,
    "clock_out": clockOut,
    "location": location,
    "latitude": latitude,
    "longitude": longitude,
    "late": late,
    "early_leaving": earlyLeaving,
    "overtime": overtime,
    "total_rest": totalRest,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
