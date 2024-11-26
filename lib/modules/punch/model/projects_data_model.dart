// To parse this JSON data, do
//
//     final projectDataModel = projectDataModelFromJson(jsonString);

import 'dart:convert';

List<ProjectDataModel> projectDataModelFromJson(String str) => List<ProjectDataModel>.from(json.decode(str).map((x) => ProjectDataModel.fromJson(x)));

String projectDataModelToJson(List<ProjectDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectDataModel {
  int? id;
  String? projectName;
  String? division;
  String? projectCode;
  DateTime? createdAt;
  String? updatedAt;

  ProjectDataModel({
    this.id,
    this.projectName,
    this.division,
    this.projectCode,
    this.createdAt,
    this.updatedAt,
  });

  factory ProjectDataModel.fromJson(Map<String, dynamic> json) => ProjectDataModel(
    id: json["id"],
    projectName: json["project_name"],
    division: json["division"],
    projectCode: json["project_code"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "project_name": projectName,
    "division": division,
    "project_code": projectCode,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
  };
}
