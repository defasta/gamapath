import 'dart:convert';

CategoriesModel CategoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String CategoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
  CategoriesModel({
    required this.message,
    required this.success,
    required this.code,
    required this.data
  });

  String message;
  bool success;
  int code;
  List<CategoriesItem> data;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(message: json["message"], success: json["success"], code: json["code"], data: List<CategoriesItem>.from(json["data"].map((x) => CategoriesItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
      "message": message,
      "success":success,
      "code": code,
      "data" : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}


class CategoriesItem{
  CategoriesItem({
    required this.id,
    required this.teacherId,
    required this.name,
    required this.createdAt,
    required this.updatedAt
  });

  int id;
  int teacherId;
  String name;
  String createdAt;
  String updatedAt;

  factory CategoriesItem.fromJson(Map<String, dynamic> json) => CategoriesItem(id: json["id"], teacherId:json["teacher_id"], name: json["name"], createdAt: json["created_at"], updatedAt: json["updated_at"]);

  Map<String, dynamic> toJson() =>{
    "id": id,
    "teacher_id" : teacherId,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt
  };
}