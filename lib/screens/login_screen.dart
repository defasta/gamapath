import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gamapath/screens/register_screen.dart';
import 'package:gamapath/screens/request_reset_password_screen.dart';
import 'package:gamapath/utils/validator.dart';

import '../core/api_client.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _showPassword = true;

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Mohon tunggu...'),
        backgroundColor: Colors.green,
      ));

      dynamic res = await _apiClient.login(
        emailController.text,
        passwordController.text,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login berhasil!'),
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
        backgroundColor: Colors.blueGrey[200],
        body: Form(
          key: _formKey,
          child: Stack(children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image : const AssetImage('assets/images/bg_pathology.png'),
                    fit: BoxFit.fitHeight
                  ),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: size.width * 0.85,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Row(children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: Image(
                                    image: AssetImage('assets/images/logo_text_hitam.png'),),
                                ),
                                new Spacer(),
                                Container(
                                  height: 45,
                                  width: 45,
                                  child: Image(
                                    image: AssetImage('assets/images/logo_ugm.png'),),
                                )
                                ],)
                            ),
                            SizedBox(height: size.height * 0.05),
                            Container(
                              child: Text(
                                "GAMAPATH",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Container(
                              child: Text(
                                "Aplikasi pendamping praktikum\nPatologi Anatomik FK-KMK UGM\nHibah Akademik Pengembangan Mata Kuliah\nBerbasis Teknologi Informasi 2021",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                return Validator.validateEmail(value ?? "");
                              },
                              style: TextStyle(
                                  fontSize: 14
                              ),
                              decoration: InputDecoration(
                                hintText: "Email",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            TextFormField(
                              obscureText: _showPassword,
                              controller: passwordController,
                              validator: (value) {
                                return Validator.validatePassword(value ?? "");
                              },
                              style: TextStyle(
                                  fontSize: 14
                              ),
                              decoration: InputDecoration(
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
                                hintText: "Password",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            // SizedBox(height: size.height * 0.02),
                            // GestureDetector(
                            //     onTap: (){
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) => RequestResetPasswordScreen()
                            //           )
                            //       );
                            //     },
                            //     child: Align(
                            //       alignment: Alignment.centerRight,
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.end,
                            //         children: [
                            //           Text(
                            //             "Lupa Password?",
                            //             style: TextStyle(
                            //               fontSize: 12,
                            //               fontWeight: FontWeight.w400,
                            //               color: Colors.grey
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     )
                            // ),
                            SizedBox(height: size.height * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: login,
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15)),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: size.height * 0.03),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterScreen()
                                    )
                                );
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Belum punya akun?",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Daftar disini",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ),
          ]),
        ));
  }
}