import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/api_client.dart';
import '../utils/validator.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget{
  final String email;
  final String code;
  const ResetPasswordScreen({Key? key, required this.email, required this.code});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreen();
}

class _ResetPasswordScreen extends State<ResetPasswordScreen>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _showPassword = true;

  Future<void> resetPassword() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Mohon tunggu...'),
        backgroundColor: Colors.green,
      ));

      dynamic res = await _apiClient.resetPassword(
        widget.email,
        widget.code,
        passwordController.text,
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password berhasil diubah! Silakan login untuk melanjutkan.'),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
            LoginScreen()), (Route<dynamic> route) => false);
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
                                    "Masukkan kode verifikasi yang telah dikirimkan ke email ${widget.email}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
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
                                SizedBox(height: size.height * 0.03),
                                TextFormField(
                                  obscureText: _showPassword,
                                  controller: confirmPasswordController,
                                  validator: (value) {
                                    return Validator.validatePasswordConfirm(value ?? "", passwordController.text ?? "");
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
                                    hintText: "Konfirmasi Password",
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
                                        onPressed: resetPassword,
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40, vertical: 15)),
                                        child: const Text(
                                          "Ubah Password",
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