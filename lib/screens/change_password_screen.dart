import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/api_client.dart';
import '../utils/validator.dart';
import 'home_screen.dart';

class ChangePasswordScreen extends StatefulWidget{
  const ChangePasswordScreen({Key? key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreen();
}

class _ChangePasswordScreen extends State<ChangePasswordScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textFieldOldPasswordController = TextEditingController();
  final TextEditingController _textFieldNewPasswordController = TextEditingController();
  final TextEditingController _textFieldNewPasswordConfirmController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  bool _showPassword = true;
  bool _showNewPassword = true;
  bool _showPasswordConfirm = true;

  Future<void> changePassword() async {
    if (_formKey.currentState!.validate()) {
      var token = await storage.read(key: 'token');
      dynamic res = await _apiClient.changePassword(token!, _textFieldOldPasswordController.text, _textFieldNewPasswordController.text);

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Berhasil mengubah password!'),
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
        title: Text('Edit Profil'),
    backgroundColor: Colors.blue.shade200),
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
                                  Padding(
                                      padding: EdgeInsets.all(12),
                                      child:  Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            'Password Lama',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black38,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            controller: _textFieldOldPasswordController,
                                            obscureText: _showPassword,
                                            validator: (value) {
                                              return Validator.validatePassword(value ?? "");
                                            },
                                            decoration:
                                            InputDecoration(
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    setState(
                                                            () => _showPassword = !_showPassword);
                                                  },
                                                  child: Icon(
                                                    _showPassword
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                hintText: ""
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'Password Baru',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black38,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            controller: _textFieldNewPasswordController,
                                            obscureText: _showNewPassword,
                                            validator: (value) {
                                              return Validator.validatePassword(value ?? "");
                                            },
                                            decoration:
                                            InputDecoration(
                                              hintText: "",
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  setState(
                                                          () => _showNewPassword = !_showNewPassword);
                                                },
                                                child: Icon(
                                                  _showNewPassword
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            'Konfirmasi Password Baru',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black38,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          const SizedBox(height: 10),
                                          TextFormField(
                                            controller: _textFieldNewPasswordConfirmController,
                                            obscureText: _showPasswordConfirm,
                                            validator: (value) {
                                              return Validator.validatePasswordConfirm( value ?? "", _textFieldNewPasswordController.text);
                                            },
                                            decoration:
                                            InputDecoration(
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    setState(
                                                            () => _showPasswordConfirm = !_showPasswordConfirm);
                                                  },
                                                  child: Icon(
                                                    _showPasswordConfirm
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                hintText: ""
                                            ),
                                          ),
                                          SizedBox(height: 20),
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
                                  onPressed: changePassword,
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
    ) ,);
  }

}