// To parse this JSON data, do
//
//     final embeddingData = embeddingDataFromJson(jsonString);

import 'dart:convert';

List<EmbeddingData> embeddingDataFromJson(String str) => List<EmbeddingData>.from(json.decode(str).map((x) => EmbeddingData.fromJson(x)));

String embeddingDataToJson(List<EmbeddingData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmbeddingData {
  String? faceRecogId;
  String? name;
  String? employeeHashCode;

  EmbeddingData({
    this.faceRecogId,
    this.name,
    this.employeeHashCode,
  });

  factory EmbeddingData.fromJson(Map<String, dynamic> json) => EmbeddingData(
    faceRecogId: json["face_recog_id"],
    name: json["name"],
    employeeHashCode: json["employee_hash_code"],
  );

  Map<String, dynamic> toJson() => {
    "face_recog_id": faceRecogId,
    "name": name,
    "employee_hash_code": employeeHashCode,
  };
}
