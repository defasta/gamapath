import 'dart:convert';

PracticeModel practiceModelFromJson(String str) => PracticeModel.fromJson(json.decode(str));

String practiceModelToJson(PracticeModel data) => json.encode(data.toJson());

class PracticeModel {
  PracticeModel({
    required this.message,
    required this.success,
    required this.code,
    required this.data
  });

  String message;
  bool success;
  int code;
  List<PracticeItem> data;

  factory PracticeModel.fromJson(Map<String, dynamic> json) => PracticeModel(message: json["message"], success: json["success"], code: json["code"], data: List<PracticeItem>.from(json["data"].map((x) => PracticeItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
      "message": message,
      "success":success,
      "code": code,
      "data" : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}


class PracticeItem{
  PracticeItem({
    required this.id,
    required this.teacherId,
    required this.name,
    required this.enrollCode
  });

  int id;
  int teacherId;
  String name;
  String enrollCode;

  factory PracticeItem.fromJson(Map<String, dynamic> json) => PracticeItem(id: json["id"], teacherId:json["teacher_id"], name: json["name"], enrollCode: json["enroll_code"]);

  Map<String, dynamic> toJson() =>{
    "id": id,
    "teacher_id" : teacherId,
    "name": name,
    "enroll_code": enrollCode
  };
}