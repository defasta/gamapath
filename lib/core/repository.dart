import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/CategoriesModel.dart';
import '../model/PracticeModel.dart';
import '../model/TaskModel.dart';
import '../model/UserDataModel.dart';
import 'api_client.dart';

class Repository{
  static Future<User> getUserData(ApiClient _apiClient, FlutterSecureStorage storage) async {
    var token = await storage.read(key: 'token');
    User userRes = await _apiClient.getUserProfileData(token!);
    return userRes;
  }

  static Future<dynamic> isLoggedIn(ApiClient _apiClient, FlutterSecureStorage storage) async {
    var token = await storage.read(key: 'token');
    User userRes = await _apiClient.isLoggedIn(token!);
    return userRes;
  }

  static Future<List<CategoriesItem>> getCategories(ApiClient _apiClient, FlutterSecureStorage storage) async{
    var token = await storage.read(key: 'token');
    List<CategoriesItem> categories = await _apiClient.getCategories(token!);
    return categories;
  }

  static Future<List<PracticeItem>> getPractices(ApiClient _apiClient, FlutterSecureStorage storage) async{
    var token = await storage.read(key: 'token');
    List<PracticeItem> practices = await _apiClient.getPractices(token!);
    return practices;
  }
}