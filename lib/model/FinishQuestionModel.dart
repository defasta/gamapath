import 'dart:convert';

FinishQuestion FinishQuestionFromJson(String str) => FinishQuestion.fromJson(json.decode(str));

String FinishQuestionToJson(FinishQuestion data) => json.encode(data.toJson());

class FinishQuestion {
  FinishQuestion({
    required this.message,
    required this.success,
    required this.code,
    required this.data
  });

  String message;
  bool success;
  int code;
  MyPreTestResults data;

  factory FinishQuestion.fromJson(Map<String, dynamic> json) => FinishQuestion(message: json["message"], success: json["success"], code: json["code"], data: MyPreTestResults.fromJson(json["data"])
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "success":success,
    "code": code,
    "data" : data,
  };
}

class MyPreTestResults{
  MyPreTestResults({required this.id, required this.studentId, required this.type, required this.point, required this.status, required this.startAt, required this.endAt, required this.createdAt, required this.updatedAt, required this.parentType, required this.parentId});

  int id;
  int studentId;
  String type;
  int point;
  String status;
  String startAt;
  String endAt;
  String createdAt;
  String updatedAt;
  String parentType;
  int parentId;

  factory MyPreTestResults.fromJson(Map<String, dynamic> json) => MyPreTestResults(id: json["id"], studentId: json["student_id"], type: json["type"], point: json["point"], status: json["status"], startAt: json["start_at"], endAt: json["end_at"],  createdAt: json["created_at"], updatedAt: json["updated_at"], parentType: json["parent_type"], parentId: json["parent_id"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "student_id": studentId,
    "type": type,
    "point": point,
    "status": status,
    "start_at": startAt,
    "end_at": endAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "parent_type": parentType,
    "parent_id": parentId
  };
}
