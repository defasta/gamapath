import 'dart:convert';

QuestionModel questionModel(String str) => QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel{
  QuestionModel({
    required this.message,
    required this.success,
    required this.code,
    required this.data
  });

  String message;
  bool success;
  int code;
  List<QuestionItem> data;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(message: json["message"], success: json["success"], code: json["code"], data: List<QuestionItem>.from(json["data"].map((x) => QuestionItem.fromJson(x))));

  Map<String, dynamic> toJson() => {
    "message": message,
    "success":success,
    "code": code,
    "data" : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class QuestionItem{
  QuestionItem({
    required this.id,
    required this.type,
    required this.number,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.optionE,
    required this.createdAt,
    required this.updatedAt,
    required this.parentType,
    required this.parentId,
    required this.yourAnswer
  });

  factory QuestionItem.fromJson(Map<String, dynamic> json) => QuestionItem(id: json["id"], type: json["type"], number: json["number"], question: json["question"], optionA: json["option_a"], optionB: json["option_b"], optionC: json["option_c"], optionD: json["option_d"], optionE: json["option_e"], createdAt: json["created_at"], updatedAt: json["updated_at"], parentType: json["parent_type"], parentId: json["parent_id"], yourAnswer: json["your_answer"]);

  Map<String, dynamic> toJson() =>{
    "id":id,
    "type":type,
    "number":number,
    "question": question,
    "option_a":optionA,
    "option_b":optionB,
    "option_c":optionC,
    "option_d":optionD,
    "option_e":optionE,
    "created_at":createdAt,
    "parent_type":parentType,
    "parent_id":parentId,
    "your_answer":yourAnswer
  };

  int id;
  String type;
  int number;
  String question;
  String optionA;
  String optionB;
  String optionC;
  String optionD;
  String? optionE;
  String createdAt;
  String updatedAt;
  String parentType;
  int parentId;
  String? yourAnswer;
}