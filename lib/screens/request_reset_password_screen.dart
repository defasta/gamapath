import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamapath/screens/verify_code_screen.dart';

import '../core/api_client.dart';
import '../utils/validator.dart';

class RequestResetPasswordScreen extends StatefulWidget{
  const RequestResetPasswordScreen({Key? key});

  @override
  State<RequestResetPasswordScreen> createState() => _RequestResetPasswordScreen();
}

class _RequestResetPasswordScreen extends State<RequestResetPasswordScreen>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  Future<void> requestResetPassword() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Mohon tunggu...'),
        backgroundColor: Colors.green,
      ));

      dynamic res = await _apiClient.requestResetPassword(
        emailController.text,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Kode verifikasi terkirim!'),
          backgroundColor: Colors.green,
        ));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyCodeScreen(email: emailController.text) )
        );
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
          child: Stack(
            children: [
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
                                SizedBox(height: size.height * 0.04),
                                Container(
                                  child: Text(
                                    "Masukkan email Anda untuk mendapatkan kode verifikasi",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.03),
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
                                SizedBox(height: size.height * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: requestResetPassword,
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 15)),
                                        child: const Text(
                                          "Minta Kode Verifikasi",
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
                              ]
                          ),
                        ),
                      ),
                  ),
                ),
              )
              )]
          ),
        )
    );
  }

}