import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/src/options.dart' as Opt;
import 'package:gamapath/model/CategoriesModel.dart';
import 'package:gamapath/model/LearningModuleDetailModel.dart';
import 'package:gamapath/model/QuestionModel.dart';
import 'package:gamapath/model/TaskModel.dart';
import 'package:gamapath/model/UserDataModel.dart';

import '../model/FinishQuestionModel.dart';
import '../model/PracticeModel.dart';

class ApiClient{
  final Dio _dio = Dio();
  final FlutterSecureStorage storage = new FlutterSecureStorage();

  Future<dynamic> registerUser(Map<String, dynamic>? data) async {
    try {
      Response response = await _dio.post(
          'https://api.loginradius.com/identity/v2/auth/register',
          data: data);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      persistToken(response.data['data']['token']);
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> requestResetPassword(String email) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/auth/request-reset-password',
        data: {
          'email': email,
        },
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> resetPassword(String email, String token, String password) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/auth/reset-password',
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': password
        },
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> verifyEmail(String code) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/auth/verify-email',
        data: {
          'activation_token': code,
        },
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> register(String name, String email, String password, String programStudyId, String nim, String group, String role) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'program_study_id': programStudyId,
          'nim': nim,
          'group': group,
          'role': role
        },
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> deleteAccount(String token) async {
    try {
      Response response = await _dio.delete(
        'https://gamapath.fk-kmk.id/api/auth/delete-account',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success delete account: ${response.data}");
      return response.data;
    } on DioError catch (e) {
      debugPrint("error delete account ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<dynamic> isLoggedIn(String token) async {
    try {
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/auth/me',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get profile: ${response.data}");
      return response.data;
    } on DioError catch (e) {
      debugPrint("error get profile: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<User> getUserProfileData(String token) async {
    try {
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/auth/me',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get profile: ${response.data}");
      return UserDataModel.fromJson(response.data).data.user;
    } on DioError catch (e) {
      debugPrint("error get profile: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<List<CategoriesItem>> getCategories(String token) async {
    try{
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/categories',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get categories: ${response.data}");
      return CategoriesModel.fromJson(response.data).data;
    }on DioError catch (e) {
      debugPrint("error get categories: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<List<PracticeItem>> getPractices(String token) async {
    try{
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/pratices',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get practices: ${response.data}");
      return PracticeModel.fromJson(response.data).data;
    }on DioError catch (e) {
      debugPrint("error get practices: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<List<LearningModuleDetail>> getLearningModules(String token, String categoriesId) async{
    try{
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/categories/$categoriesId',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get learning modules: ${response.data}");

      return LearningModuleDetailModel.fromJson(response.data).data.learningModules;
    }on DioError catch (e) {
      debugPrint("error get learning modules: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<List<CasesItem>> getCases(String token, String categoriesId, String parentId) async{
    try{
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/categories/$categoriesId',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get cases: ${response.data}");

      List<CasesItem> cases = [];
      for (var element in LearningModuleDetailModel.fromJson(response.data).data.learningModules){
        for(var learningCase in element.cases){
          if(learningCase.learningModuleId.toString() == parentId){
            cases.add(learningCase);
          }
        }
      }
      return cases;
    }on DioError catch (e) {
      debugPrint("error get cases: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<List<ModulesItem>> getModules(String token, String categoriesId, String parentId) async{
    try{
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/categories/$categoriesId',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get cases: ${response.data}");

      List<ModulesItem> modules = [];
      for (var element in LearningModuleDetailModel.fromJson(response.data).data.learningModules){
        for(var learningCase in element.cases){
          for(var learningModule in learningCase.modules){
            if(learningModule.parentId.toString() == parentId){
              modules.add(learningModule);
            }
          }
        }
      }
      return modules;
    }on DioError catch (e) {
      debugPrint("error get cases: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<TaskItem> getTaskData(String token, String practiceId) async {
    try {
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/pratices/$practiceId',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get task: ${response.data}");
      return TaskModel.fromJson(response.data).data;
    } on DioError catch (e) {
      debugPrint("error get task: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<dynamic> changeProfile(String token, String name, String email, File? avatar) async {
    try {
      if(avatar != null){
        try{
          String fileName = avatar.path.split('/').last;
          FormData formData = FormData.fromMap({
            "name" : MultipartFile.fromString(name),
            "email": MultipartFile.fromString(email),
            "avatar": await MultipartFile.fromFile(
                avatar.path,
                filename: fileName),
          });
          Response response = await _dio.post(
              'https://gamapath.fk-kmk.id/api/auth/change-profile',
              options: Opt.Options(
                  headers: {
                    'Authorization': 'Bearer $token',
                  }),
              data: formData
          );
          debugPrint("success change profile: ${response.data}");
          return response.data;
        } on DioError catch (e) {
          debugPrint("failed change profile: ${e.response!.data}");
          return e.response!.data;
        }

      } else {
        try{
          Response response = await _dio.post(
            'https://gamapath.fk-kmk.id/api/auth/change-profile',
            options: Opt.Options(
                headers: {
                  'Authorization': 'Bearer $token',
                }),
            data: {
              'name': name,
              'email': email
            },
          );
          debugPrint("success change profile: ${response.data}");
          return response.data;
        }on DioError catch (e) {
          debugPrint("failed change profile: ${e.response!.data}");
          return e.response!.data;
        }
      }
    } on DioError catch (e) {
      debugPrint("failed change profile: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<dynamic> changePassword(String token, String oldPassword, String newPassword) async {
    try{
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/auth/change-password',
        options: Opt.Options(
            headers: {
              'Authorization': 'Bearer $token',
            }),
        data: {
          'old_password': oldPassword,
          'password': newPassword,
          'password_confirmation': newPassword
        },
      );
      debugPrint("success change password: ${response.data}");
      return response.data;
    }on DioError catch (e) {
      debugPrint("failed change password: ${e.response!.data}");
      return e.response!.data;
    }

  }

  Future<List<QuestionItem>> getQuizModuleQuestions(String token, String practicesId) async{
    try{
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/learning-modules/$practicesId/quizzes',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get questions: ${response.data}");

      return QuestionModel.fromJson(response.data).data;
    }on DioError catch (e) {
      debugPrint("error get questions: ${e.response!.data}");
      return e.response!.data;
    }
  }

    Future<dynamic> isQuizAvailable(String token, String practicesId) async{
    try{
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/learning-modules/$practicesId/quizzes',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get questions: ${response.data}");
      return response.data;
    }on DioError catch (e) {
      debugPrint("error get questions: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<dynamic> answerQuizModule(String token, String practicesId, String number, String answer) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/learning-modules/$practicesId/quizzes/$number/answer',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'answer': answer,
        },
      );
      debugPrint("success answer questions: ${response.data}");
      return response.data;
    } on DioError catch (e) {
      debugPrint("error answer questions: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<MyPreTestResults> finishQuizModule(String token, String practicesId) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/learning-modules/$practicesId/quizzes/finish',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success submit quiz: ${response.data}");
      return FinishQuestion.fromJson(response.data).data;
    } on DioError catch (e) {
      debugPrint("error submit quiz: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<List<QuestionItem>> getPretestQuestions(String token, String practicesId) async{
    try{
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/pratices/$practicesId/pre-tests',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get questions: ${response.data}");

      return QuestionModel.fromJson(response.data).data;
    }on DioError catch (e) {
      debugPrint("error get questions: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<dynamic> answerPretest(String token, String practicesId, String number, String answer) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/pratices/$practicesId/pre-tests/$number/answer',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'answer': answer,
        },
      );
      debugPrint("success answer questions: ${response.data}");
      return response.data;
    } on DioError catch (e) {
      debugPrint("error answer questions: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<MyPreTestResults> finishPretest(String token, String practicesId) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/pratices/$practicesId/pre-tests/finish',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success submit pretest: ${response.data}");
      return FinishQuestion.fromJson(response.data).data;
    } on DioError catch (e) {
      debugPrint("error submit pretest: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<List<QuestionItem>> getPostTestQuestions(String token, String practicesId) async{
    try{
      Response response = await _dio.get(
        'https://gamapath.fk-kmk.id/api/pratices/$practicesId/post-tests',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success get questions: ${response.data}");

      return QuestionModel.fromJson(response.data).data;
    }on DioError catch (e) {
      debugPrint("error get questions: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<dynamic> answerPostTest(String token, String practicesId, String number, String answer) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/pratices/$practicesId/post-tests/$number/answer',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'answer': answer,
        },
      );
      debugPrint("success answer questions: ${response.data}");
      return response.data;
    } on DioError catch (e) {
      debugPrint("error answer questions: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<MyPreTestResults> finishPostTest(String token, String practicesId) async {
    try {
      Response response = await _dio.post(
        'https://gamapath.fk-kmk.id/api/pratices/$practicesId/post-tests/finish',
        options: Opt.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      debugPrint("success submit pretest: ${response.data}");
      return FinishQuestion.fromJson(response.data).data;
    } on DioError catch (e) {
      debugPrint("error submit pretest: ${e.response!.data}");
      return e.response!.data;
    }
  }

  Future<void> persistToken(String token) async{
    await storage.write(key: 'token', value: token);
  }

  Future<bool?> hasToken() async{
    String? token = await storage.read(key: 'token');
    return token != null ? true : false;
  }

  Future<String?> getToken() async{
    String? token = await storage.read(key: 'token');
    return token;
  }

  Future<void> deleteToken() async{
    await storage.delete(key: 'token');
  }
}