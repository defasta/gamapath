import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_url_image_load_fail/flutter_url_image_load_fail.dart';
import 'package:gamapath/screens/home_screen.dart';
import 'package:gamapath/screens/profile_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../core/api_client.dart';

class ChangeProfileScreen extends StatefulWidget{
  final String name;
  final String email;
  final String urlPhoto;

  const ChangeProfileScreen({Key? key, required this.name, required this.email, required this.urlPhoto});

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreen();
}

class _ChangeProfileScreen extends State<ChangeProfileScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldEmailController = TextEditingController();
  final TextEditingController _textFieldNameController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  bool isImageSelected = false;
  File? imageFile;

  @override
  void initState(){
    super.initState();

    _textFieldNameController.text = widget.name;
    _textFieldEmailController.text = widget.email;
  }

  Future<void> changeProfile() async {
    if (_formKey.currentState!.validate()) {
      var token = await storage.read(key: 'token');
      dynamic res = await _apiClient.changeProfile(token!, _textFieldNameController.text, _textFieldEmailController.text, imageFile);

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Berhasil mengubah profil!'),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            HomeScreen()), (Route<dynamic> route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${res['message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  pickImagefromGallery() async {
    try {
      final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          imageFile = File(pickedImage.path);
          isImageSelected = true;
        });
      } else {
        print('User didnt pick any image.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // _textFieldNameController.text = widget.name;
    // _textFieldEmailController.text = widget.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
        backgroundColor: Colors.blue.shade200,
        actions: [
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            SizedBox(
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
                                    GestureDetector(
                                      child:  Center(
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
                                            child: isImageSelected ? Image(
                                              image: FileImage(imageFile!),
                                            ) : LoadImageFromUrl(
                                                imageUrl: widget.urlPhoto!, //Image URL to load
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
                                            ) ,
                                          ),
                                        ),),
                                      onTap: () async {
                                        await pickImagefromGallery();
                                      },
                                    ),
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
                                            TextField(
                                              controller: _textFieldNameController,
                                              decoration:
                                              const InputDecoration(hintText: "Masukkan nama"),
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
                                            TextField(
                                              controller: _textFieldEmailController,
                                              decoration:
                                              const InputDecoration(hintText: "Masukkan email"),
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
                                    onPressed: changeProfile,
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15)),
                                    child: const Text(
                                      "Simpan",
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
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ) ,
    );
  }
}