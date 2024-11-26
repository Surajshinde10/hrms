// To parse this JSON data, do
//
//     final divisionsDataModel = divisionsDataModelFromJson(jsonString);

import 'dart:convert';

List<DivisionsDataModel> divisionsDataModelFromJson(String str) => List<DivisionsDataModel>.from(json.decode(str).map((x) => DivisionsDataModel.fromJson(x)));

String divisionsDataModelToJson(List<DivisionsDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DivisionsDataModel {
  int? id;
  String? name;
  int? createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  DivisionsDataModel({
    this.id,
    this.name,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory DivisionsDataModel.fromJson(Map<String, dynamic> json) => DivisionsDataModel(
    id: json["id"],
    name: json["name"],
    createdBy: json["created_by"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "created_by": createdBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
