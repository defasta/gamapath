import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_url_image_load_fail/flutter_url_image_load_fail.dart';
import 'package:gamapath/model/TaskModel.dart';
import 'package:gamapath/screens/profile_screen.dart';
import 'package:gamapath/screens/setting_screen.dart';
import 'package:gamapath/screens/task_screen.dart';

import '../core/api_client.dart';
import '../core/repository.dart';
import '../model/CategoriesModel.dart';
import '../model/PracticeModel.dart';
import '../model/UserDataModel.dart';
import 'learning_module_cases_screen.dart';
import 'learning_module_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();


  Future<User> _userData = Future.value(User(id: 0, name: '', email: '', profile_photo_path: '', profile_photo_url: '', student: null, ));
  Future<List<CategoriesItem>> _listCategories = Future.value(List.empty());
  Future<List<PracticeItem>> _listPractices = Future.value(List.empty());

  @override
  void initState() {
    super.initState();
    _userData = Repository.getUserData(_apiClient, storage);
    _listCategories = Repository.getCategories(_apiClient, storage);
    _listPractices = Repository.getPractices(_apiClient, storage);

    
  }

  @override
  Widget build(BuildContext context) {
    return UserInfoFutureBuilderWidget(_userData, _listCategories, _listPractices);
  }

}

class UserInfoFutureBuilderWidget extends StatelessWidget{
  final TextEditingController _textFieldController = TextEditingController();
  String? codeDialog;
  String? valueText;
  final Future<User> _userData;
  final Future<List<CategoriesItem>> _listCategories;
  final Future<List<PracticeItem>> _listPractices;

  UserInfoFutureBuilderWidget(this._userData, this._listCategories, this._listPractices);


  Future<void> _displayEnrollDialog(BuildContext context, String enrollCode, String taskId, String taskName) async {
    _textFieldController.text = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enroll Pre - Post Test',
                style: TextStyle(
                  fontSize: 16
            ) ),
            content: TextField(
              controller: _textFieldController,
              decoration:
              const InputDecoration(hintText: "Masukkan enroll code"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.grey,
                textColor: Colors.white,
                child: const Text('Batal'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                color: Colors.blueAccent,
                textColor: Colors.white,
                child: const Text('Enroll'),
                onPressed: () {
                  if(_textFieldController.text != enrollCode){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Enroll code tidak valid!"),
                      backgroundColor: Colors.redAccent,
                    ));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskScreen(taskName: taskName, taskId: taskId)
                        )
                    );
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
            width: size.width,
            height: size.height,
            child: Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(image: DecorationImage(
                    image : const AssetImage('assets/images/bg_main.png'),
                    fit: BoxFit.fitHeight
                ),),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 35, horizontal: 20
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FutureBuilder(
                                future: _userData,
                                builder: (context, AsyncSnapshot<User> snapshot){
                                  if(snapshot.hasData){
                                    if(snapshot.connectionState == ConnectionState.waiting){
                                      return Container(
                                        width: size.width,
                                        height: size.height,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }else if (snapshot.error != null) {
                                      debugPrint("Error snapshot: ${snapshot.error.toString()}");
                                      return const Center(child: Text('Terjadi Error!'));
                                    } else {
                                      String? userName = snapshot.data?.name;
                                      String? userPhoto = snapshot.data?.profile_photo_url ?? "https://teknoreka.com/wp-content/uploads/2022/09/cropped-teknoreka-tanpa-background-new.png";

                                      return Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            const SizedBox(height: 20),
                                            Container(
                                              width: size.width,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 12),
                                              decoration: BoxDecoration(
                                                  color: Colors.white38,
                                                  borderRadius: BorderRadius.circular(5)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text('Hai,',
                                                      style: TextStyle(
                                                          fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500)),
                                                  const SizedBox(width: 7),
                                                  Text(userName!,
                                                      style: const TextStyle(
                                                          fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w700)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: size.width,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(0, 2),
                                                      blurRadius: 5,
                                                      color: Colors.black.withOpacity(0.3),
                                                    ),]),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        GestureDetector(
                                                          child:  Align(
                                                            alignment: Alignment.topCenter,
                                                            child: Container(
                                                              padding: const EdgeInsets.all(5),
                                                              clipBehavior: Clip.hardEdge,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.transparent,
                                                                border: Border.all(
                                                                    width: 1, color:  Colors.blue.shade100),
                                                              ),
                                                              child: Container(
                                                                height: 60,
                                                                width: 60,
                                                                clipBehavior: Clip.hardEdge,
                                                                decoration: const BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child: LoadImageFromUrl(
                                                                    imageUrl: userPhoto!, //Image URL to load
                                                                    buildSuccessWidget:  (image) => image,
                                                                    buildLoadingWidget:  () => CircularProgressIndicator(),
                                                                    buildFailedWidget: (retryLoadImage, code, message){
                                                                      return ElevatedButton(
                                                                        child: Text('Try Again'),
                                                                        onPressed: (){
                                                                          retryLoadImage();
                                                                        },
                                                                      );
                                                                    },
                                                                    requestTimeout: Duration(seconds: 10) //Optionally set the timeout
                                                                ),
                                                              ),
                                                            ),),
                                                          onTap: (){
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => ProfileScreen()
                                                                )
                                                            );
                                                          },
                                                        ),
                                                        const SizedBox(height: 7),
                                                        Text("Profil",
                                                            style: const TextStyle(
                                                                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                                                      ]),
                                                  const SizedBox(width: 35),
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.topCenter,
                                                          child: Container(
                                                            padding: const EdgeInsets.all(5),
                                                            clipBehavior: Clip.hardEdge,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: Colors.transparent,
                                                              border: Border.all(
                                                                  width: 1, color:  Colors.blue.shade100),
                                                            ),
                                                            child: Container(
                                                              height: 60,
                                                              width: 60,
                                                              clipBehavior: Clip.hardEdge,
                                                              decoration: const BoxDecoration(
                                                                shape: BoxShape.circle,
                                                              ),
                                                              child: Container(
                                                                  child: Center(
                                                                    child: Text(DateTime.now().day.toString()+"/"+DateTime.now().month.toString(), style: const TextStyle(
                                                                        fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500)),
                                                                  ),
                                                                  decoration: new BoxDecoration(
                                                                      shape: BoxShape.circle,
                                                                      color:  Colors.blue.shade100
                                                                  )),
                                                            ),
                                                          ),),
                                                        const SizedBox(height: 7),
                                                        Text("Tanggal",
                                                            style: const TextStyle(
                                                                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                                                      ]),
                                                  const SizedBox(width: 35),
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: (){
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>SettingScreen()
                                                                )
                                                            );
                                                          },
                                                          child: Align(
                                                            alignment: Alignment.topCenter,
                                                            child: Container(
                                                              padding: const EdgeInsets.all(5),
                                                              clipBehavior: Clip.hardEdge,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.transparent,
                                                                border: Border.all(
                                                                    width: 1, color:  Colors.blue.shade100),
                                                              ),
                                                              child: Container(
                                                                height: 60,
                                                                width: 60,
                                                                clipBehavior: Clip.hardEdge,
                                                                decoration: const BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                child:  Container(
                                                                    child: Container(
                                                                      margin: EdgeInsets.all(12.0),
                                                                      child: const Image(
                                                                        image: AssetImage('assets/images/ic_setting.png'),),
                                                                    ),
                                                                    decoration: new BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        color:  Colors.blue.shade100
                                                                    )),
                                                              ),
                                                            ),),
                                                        ),
                                                        const SizedBox(height: 7),
                                                        Text('Pengaturan',
                                                            style: const TextStyle(
                                                                fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                                                      ]),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    debugPrint("error has no data snapshot: ${snapshot.error.toString()}");
                                  }
                                  return const SizedBox();
                                },
                              ),
                              const SizedBox(height: 30),
                              FutureBuilder(
                                future: _listCategories,
                                builder: (context, AsyncSnapshot<List<CategoriesItem>> snapshot){
                                  if(snapshot.hasData){
                                    if(snapshot.connectionState == ConnectionState.waiting){
                                      return Container(
                                        width: size.width,
                                        height: size.height,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }else if (snapshot.error != null) {
                                      debugPrint("Error snapshot: ${snapshot.error.toString()}");
                                      return const Center(child: Text('Terjadi Error!'));
                                    } else {

                                      var categories = snapshot.data;

                                      return Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              width: size.width,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: Colors.white38,
                                                borderRadius: BorderRadius.circular(5),),
                                              child: Text('Kategori',
                                                  style: TextStyle(
                                                      fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                                            ),
                                            ListView.builder(
                                                padding: EdgeInsets.symmetric(vertical: 5),
                                                shrinkWrap: true,
                                                itemCount: categories?.length,
                                                itemBuilder: (context, index){
                                                  return GestureDetector(
                                                    child: Container(
                                                      child: Card(
                                                        child: Container(
                                                          margin:  EdgeInsets.symmetric(
                                                              vertical: 20, horizontal: 0),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(categories![index].name)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => LearningModuleScreen(
                                                                  categoryName: categories[index].name,
                                                                  categoryId: categories[index].id.toString()
                                                              )
                                                          )
                                                      );
                                                    },
                                                  );
                                                }),
                                          ],

                                        ),
                                      );
                                    }
                                  } else {
                                    debugPrint("error has no data snapshot: ${snapshot.error.toString()}");
                                  }
                                  return const SizedBox();
                                },
                              ),
                              const SizedBox(height: 25),
                              FutureBuilder(
                                future: _listPractices,
                                builder: (context, AsyncSnapshot<List<PracticeItem>> snapshot){
                                  if(snapshot.hasData){
                                    if(snapshot.connectionState == ConnectionState.waiting){
                                      return Container(
                                        width: size.width,
                                        height: size.height,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }else if (snapshot.error != null) {
                                      debugPrint("Error snapshot: ${snapshot.error.toString()}");
                                      return const Center(child: Text('Terjadi Error!'));
                                    } else {

                                      var practices = snapshot.data;

                                      return Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Container(
                                              width: size.width,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 12),
                                              decoration: BoxDecoration(
                                                color: Colors.white38,
                                                borderRadius: BorderRadius.circular(5),),
                                              child: Text('Pre - Post Test',
                                                  style: TextStyle(
                                                      fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
                                            ),
                                            ListView.builder(
                                                padding: EdgeInsets.symmetric(vertical: 5),
                                                shrinkWrap: true,
                                                itemCount: practices?.length,
                                                itemBuilder: (context, index){
                                                  return GestureDetector(
                                                    child: Container(
                                                      child: Card(
                                                        child: Container(
                                                          margin:  EdgeInsets.symmetric(
                                                              vertical: 20, horizontal: 0),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Text(practices![index].name)
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      _displayEnrollDialog(context, practices![index].enrollCode, practices![index].id.toString(), practices![index].name);
                                                      // Navigator.push(
                                                      //     context,
                                                      //     MaterialPageRoute(
                                                      //         builder: (context) => LearningModuleScreen(
                                                      //             categoriesName: categoriesModel[index].name,
                                                      //             categoriesId: categoriesModel[index].id.toString()
                                                      //         )
                                                      //     )
                                                      // );
                                                    },
                                                  );
                                                }),
                                          ],

                                        ),
                                      );
                                    }
                                  } else {
                                    debugPrint("error has no data snapshot: ${snapshot.error.toString()}");
                                  }
                                  return const SizedBox();
                                },
                              ),
                            ]
                        )
                    )
                )
            )
        )
    );
  }


}