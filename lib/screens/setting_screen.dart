import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gamapath/screens/change_password_screen.dart';

import '../core/api_client.dart';
import 'login_screen.dart';

class SettingScreen extends StatefulWidget{
  const SettingScreen({Key? key});

  @override
  State<SettingScreen> createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen>{

  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  var _isAccountDeleted = false;

  Future<void> logout() async {
    await _apiClient.deleteToken();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()),
            (_) => false
    );
  }

  void _deleteToken(bool isAccountDeleted){
    setState(() {
      _isAccountDeleted = isAccountDeleted;
    },);
  }

  Future<void> deleteAccount() async {
    var token = await storage.read(key: 'token');
    dynamic res = _apiClient.deleteAccount(token!);
    await _apiClient.deleteToken();
     Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => LoginScreen()),
            (_) => false);
    // if (res['success'] == true) {
    //   _deleteToken(true);
    //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   //   content: Text('${res['message']}'),
    //   //   backgroundColor: Colors.green,
    //   // ));
    //    Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => LoginScreen()),
    //         (_) => false);
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('${res['message']}'),
    //     backgroundColor: Colors.red.shade300,
    //   ));
    // }
  }

  Future<void> _displayLogoutDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi Logout',
                style: TextStyle(
                  fontSize: 16
            ) ),
            content:  const Text('Apakah Anda yakin ingin Logout?',
                style: TextStyle(
                  fontSize: 14
            ) ),
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
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Logout'),
                onPressed: logout
              ),
            ],
          );
        });
  }

    Future<void> _displayDeleteAccountDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi Hapus Akun',
                style: TextStyle(
                  fontSize: 16
            ) ),
            content:  const Text('Apakah Anda yakin ingin Hapus Akun? Akun yang telah dihapus tidak dapat kembali.',
                style: TextStyle(
                  fontSize: 14
            ) ),
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
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('Hapus Akun'),
                onPressed: deleteAccount
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
        backgroundColor: Colors.blue.shade200,
        actions: [
        ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  child: Card(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin:  EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Text("Ubah Password"),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordScreen()
                      )
                  );
                },
              ),
              GestureDetector(
                child: Container(
                  child: Card(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin:  EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Text("Logout"),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: (){
                  _displayLogoutDialog(context);
                }
              ),
              GestureDetector(
                child: Container(
                  child: Card(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      margin:  EdgeInsets.symmetric(
                          vertical: 25, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Text("Hapus Akun"),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: (){
                  _displayDeleteAccountDialog(context);
                }
              )
            ],
          )
      ))
    );
  }
}