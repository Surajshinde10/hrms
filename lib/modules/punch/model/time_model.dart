// To parse this JSON data, do
//
//     final timeModel = timeModelFromJson(jsonString);

import 'dart:convert';

TimeModel timeModelFromJson(String str) => TimeModel.fromJson(json.decode(str));

String timeModelToJson(TimeModel data) => json.encode(data.toJson());

class TimeModel {
  int? id;
  String? employeeId;
  DateTime? date;
  String? hours;
  String? remark;
  String? createdBy;
  String? startShift;
  String? endShift;
  DateTime? createdAt;
  DateTime? updatedAt;

  TimeModel({
    this.id,
    this.employeeId,
    this.date,
    this.hours,
    this.remark,
    this.createdBy,
    this.startShift,
    this.endShift,
    this.createdAt,
    this.updatedAt,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) => TimeModel(
    id: json["id"],
    employeeId: json["employee_id"].toString(),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    hours: json["hours"].toString(),
    remark: json["remark"],
    createdBy: json["created_by"].toString(),
    startShift: json["start_shift"],
    endShift: json["end_shift"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "hours": hours,
    "remark": remark,
    "created_by": createdBy,
    "start_shift": startShift,
    "end_shift": endShift,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
