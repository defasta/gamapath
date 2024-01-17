import 'dart:convert';

TaskModel TaskModelFromJson(String str) => TaskModel.fromJson(json.decode(str));

String TaskModelToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  TaskModel({
    required this.message,
    required this.success,
    required this.code,
    required this.data
  });

  String message;
  bool success;
  int code;
  TaskItem data;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(message: json["message"], success: json["success"], code: json["code"], data: TaskItem.fromJson(json["data"])
  );

  Map<String, dynamic> toJson() => {
      "message": message,
      "success":success,
      "code": code,
      "data" : data,
  };
}


class TaskItem{
  TaskItem({
    required this.id,
    required this.teacherId,
    required this.name,
    required this.enrollCode,
    required this.preTestResult,
    required this.postTestResult
  });

  int id;
  int teacherId;
  String name;
  String enrollCode;
  PreTestResult? preTestResult;
  PostTestResult? postTestResult;


  factory TaskItem.fromJson(Map<String?, dynamic> json) => TaskItem(id: json["id"], teacherId:json["teacher_id"], name: json["name"], enrollCode: json["enroll_code"], preTestResult: PreTestResult.fromJson(json["my_pre_test_result"]), postTestResult: PostTestResult?.fromJson(json["my_post_test_result"]));

  Map<String?, dynamic> toJson() =>{
    "id": id,
    "teacher_id" : teacherId,
    "name": name,
    "enroll_code": enrollCode,
    "my_pre_test_result": preTestResult,
    "my_post_test_result": postTestResult
  };
}

class PreTestResult{
  PreTestResult({required this.point, required this.status});

  int? point;
  String? status;

  factory PreTestResult.fromJson(Map<String, dynamic>? json) => PreTestResult(point: json?["point"], status: json?["status"]);

  Map<String, dynamic>? toJson() => {
    "point": point,
    "status": status
  };
}

class PostTestResult{
  PostTestResult({required this.point, required this.status});

  int? point;
  String? status;

  factory PostTestResult.fromJson(Map<String, dynamic>? json) => PostTestResult(point: json?["point"], status: json?["status"]);

  Map<String, dynamic>? toJson() => {
    "point": point,
    "status": status
  };
}