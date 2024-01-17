import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_url_image_load_fail/flutter_url_image_load_fail.dart';
import 'package:gamapath/screens/change_profile_screen.dart';
import 'package:gamapath/screens/login_screen.dart';
import '../core/repository.dart';

import '../core/api_client.dart';
import '../model/UserDataModel.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({Key? key}): super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen>{

  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  Future<User> _userData = Future.value(User(id: 0, name: '', email: '', profile_photo_path: '', profile_photo_url: '', student: null, ));
  //get user data from ApiClient
  Future<User> getUserData() async {
    var token = await storage.read(key: 'token');
    User userRes = await _apiClient.getUserProfileData(token!);
    return userRes;
  }

  Future<void> logout() async {
    await _apiClient.deleteToken();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()),
            (_) => false
    );
  }

  @override
  void initState(){
    super.initState();
    _userData = Repository.getUserData(_apiClient, storage);
  }


  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        backgroundColor: Colors.blue.shade200,
        actions: [
        ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child:   FutureBuilder(
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
                            String? email = snapshot.data?.email;
                            String? program = snapshot.data?.student?.programStudy?.name;
                            String? group = snapshot.data?.student?.group;
                            String? nim = snapshot.data?.student?.nim;

                            return Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  const SizedBox(height: 20),
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
                                    child :Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Center(
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
                                                height: 100,
                                                width: 100,
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
                                                    requestTimeout: Duration(seconds: 2) //Optionally set the timeout
                                                ),
                                              ),
                                            ),),
                                          const SizedBox(height: 12),
                                          Padding(
                                            padding: EdgeInsets.all(12),
                                            child:  Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                const SizedBox(height: 10),
                                                Text(
                                                  'Nama',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black38,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  userName!,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  'Email',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black38,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  email!,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  'Program',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black38,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  program ?? "-",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  'Kelompok',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black38,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  group ?? "-",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  'NIM',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black38,
                                                      fontWeight: FontWeight.normal),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  nim ?? "-",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black54,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            )
                                          ),

                                        ]),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ChangeProfileScreen(name: userName, email: email, urlPhoto: userPhoto)
                                                )
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blueAccent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 40, vertical: 15)),
                                          child: const Text(
                                            "Edit Profil",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
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
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}