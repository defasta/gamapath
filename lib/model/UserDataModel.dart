
import 'dart:convert';

UserDataModel UserDataModelFromJson(String str) => UserDataModel.fromJson(json.decode(str));

String UserDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel{
  UserDataModel({
    required this.message,
    required this.success,
    required this.code,
    required this.data});

  String message;
  bool success;
  int code;
  UserModel data;

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(message: json["message"], success: json["success"], code: json["code"], data: UserModel.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {
    "message": message,
    "success":success,
    "code": code,
    "data" : data,
  };
}

class UserModel{
  UserModel({required this.user});

  User user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(user: User.fromJson(json["user"]));

  Map<String, dynamic> toJson() => {
    "user": user
  };
}

class User{
  int id;
  String name;
  String email;
  String? profile_photo_path;
  String? profile_photo_url;
  Student? student;

  User({required this.id, required this.name, required this.email, required this.profile_photo_path, required this.profile_photo_url, required this.student});

  factory User.fromJson(Map<String, dynamic> json)
      => User(id: json["id"], name: json["name"], email: json["email"], profile_photo_path: json["profile_photo_path"], profile_photo_url: json["profile_photo_url"],  student: Student.fromJson(json["student"]));

  Map<String, dynamic> toJson() => {
    "id" : id,
    "name" : name,
    "email" : email,
    "profile_photo_path" : profile_photo_path,
    "profile_photo_url" : profile_photo_url,
    "student" : student
  };
}

class Student{
  Student({required this.programStudyId, required this.nim, required this.group, required this.year, required this.programStudy});

  int? programStudyId;
  String? nim;
  String? group;
  String? year;
  ProgramStudy? programStudy;

  factory Student.fromJson(Map<String, dynamic> json) => Student(programStudyId: json["program_study_id"], nim: json["nim"], group: json["group"], year: json["year"], programStudy: ProgramStudy.fromJson(json["program_study"]));

  Map<String, dynamic> toJson() => {
    "program_study_id": programStudyId,
    "nim": nim,
    "group": group,
    "year": year,
    "program_study": programStudy
  };
}

class ProgramStudy{
  ProgramStudy({required this.name});

  String? name;

  factory ProgramStudy.fromJson(Map<String, dynamic>? json) => ProgramStudy(name: json?["name"]);

  Map<String, dynamic>? toJson() => {
    "name": name
  };
}