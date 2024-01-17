import 'dart:convert';

import 'package:flutter/cupertino.dart';

LearningModuleDetailModel LearningModuleDetailModelFromJson(String str) => LearningModuleDetailModel.fromJson(json.decode(str));

String LearningModuleDetailModelToJson(LearningModuleDetailModel data) => json.encode(data.toJson());

class LearningModuleDetailModel {
  LearningModuleDetailModel({
    required this.message,
    required this.success,
    required this.code,
    required this.data
  });

  String message;
  bool success;
  int code;
  LearningModuleDetailData data;

  factory LearningModuleDetailModel.fromJson(Map<String, dynamic> json) => LearningModuleDetailModel(message: json["message"], success: json["success"], code: json["code"], data: LearningModuleDetailData.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {
      "message": message,
      "success":success,
      "code": code,
      "data" : data
  };
}

class LearningModuleDetailData{
  LearningModuleDetailData({
    required this.id,
    required this.teacherId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.teacher, required this.learningModules});

  int id;
  int teacherId;
  String name;
  String createdAt;
  String updatedAt;
  Teacher teacher;
  List<LearningModuleDetail> learningModules;

  factory LearningModuleDetailData.fromJson(Map<String, dynamic> json) => LearningModuleDetailData(id: json["id"], teacherId: json["teacher_id"], name: json["name"], createdAt: json["created_at"], updatedAt: json["updated_at"], teacher: Teacher.fromJson(json["teacher"]), learningModules: List<LearningModuleDetail>.from(json["learning_modules"].map((x) => LearningModuleDetail.fromJson(x))),);

  Map<String, dynamic> toJson() =>{
    "id": id,
    "teacher_id" : teacherId,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "teacher": teacher,
    "learning_modules" : List<dynamic>.from(learningModules.map((x) => x.toJson())),
    //"my_quiz_result": myQuizResult
  };

}
class LearningModuleDetail{
  LearningModuleDetail({
    required this.id,
    required this.teacherId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
    required this.cases,
    //required this.myQuizResult
  });

  int id;
  int teacherId;
  String name;
  String createdAt;
  String updatedAt;
  int categoryId;
  List<CasesItem> cases;
  //String myQuizResult;

    factory LearningModuleDetail.fromJson(Map<String, dynamic> json) => LearningModuleDetail(id: json["id"], teacherId:json["teacher_id"], name: json["name"], createdAt: json["created_at"], updatedAt: json["updated_at"], categoryId: json["category_id"],cases: List<CasesItem>.from(json["cases"].map((x) => CasesItem.fromJson(x))),
        //myQuizResult: json["my_quiz_result"]
    );

  Map<String, dynamic> toJson() =>{
    "id": id,
    "teacher_id" : teacherId,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "category_id" : categoryId,
    "cases" : List<dynamic>.from(cases.map((x) => x.toJson())),
    //"my_quiz_result": myQuizResult
  };
}

class Teacher{
  Teacher({
    required this.id,
    required this.name,
    required this.profilePhotoUrl
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(id: json["id"], name: json["name"], profilePhotoUrl: json["profile_photo_url"]);

  Map<String, dynamic> toJson() =>{
    "id":id,
    "name":name,
    "profile_photo_url":profilePhotoUrl
  };

  int id;
  String name;
  String profilePhotoUrl;
}

class CasesItem{
  CasesItem({
    required this.id, 
    required this.learningModuleId, 
    required this.name, 
    required this.createdAt, 
    required this.updatedAt, 
    required this.modules});
  
  factory CasesItem.fromJson(Map<String, dynamic> json) => CasesItem(id: json["id"], learningModuleId: json["learning_module_id"], name: json["name"], createdAt: json["created_at"], updatedAt: json["updated_at"], modules: List<ModulesItem>.from(json["modules"].map((x) => ModulesItem.fromJson(x))));

  int id;
  int learningModuleId;
  String name;
  String createdAt;
  String updatedAt;
  List<ModulesItem> modules;

  Map<String, dynamic> toJson() =>{
    "id":id,
    "learning_module_id":learningModuleId,
    "name": name,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "modules": List<dynamic>.from(modules.map((x) => x.toJson()))
  };
}

class ModulesItem{
  ModulesItem({
    required this.id,
    required this.parentType,
    required this.parentId,
    required this.file,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.annotations
  });

  factory ModulesItem.fromJson(Map<String, dynamic> json) => ModulesItem(id: json["id"], parentType: json["parent_type"], parentId: json["parent_id"], file: json["file"], type: json["type"], createdAt: json["created_at"], updatedAt: json["updated_at"], annotations: List<AnnotationsItem>.from(json["annotations"].map((x) => AnnotationsItem.fromJson(x))));

  int id;
  String parentType;
  int parentId;
  String file;
  String type;
  String createdAt;
  String updatedAt;
  List<AnnotationsItem> annotations;

  Map<String, dynamic> toJson() =>{
    "id":id,
    "parent_type": parentType,
    "parent_id": parentId,
    "file": file,
    "type":type,
    "created_at":createdAt,
    "updated_at":updatedAt,
    "annotations":List<dynamic>.from(annotations.map((x) => x.toJson()))
  };
}

class AnnotationsItem{
  AnnotationsItem({
    required this.id,
    required this.moduleId,
    required this.number,
    required this.description,
    required this.createdAt,
    required this.updatedAt
  });

  factory AnnotationsItem.fromJson(Map<String, dynamic> json) => AnnotationsItem(id: json["id"], moduleId: json["module_id"], number: json["number"], description: json["description"], createdAt: json["created_at"], updatedAt: json["updated_at"]);

  int id;
  int moduleId;
  String number;
  String description;
  String createdAt;
  String updatedAt;

  Map<String, dynamic> toJson() =>{
    "id":id,
    "module_id":moduleId,
    "number":number,
    "description":description,
    "created_at": createdAt,
    "updated_at":updatedAt
  };
}