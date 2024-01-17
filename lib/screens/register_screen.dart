import 'dart:ui';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gamapath/screens/login_screen.dart';
import 'package:gamapath/utils/validator.dart';

import '../core/api_client.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _showPassword = true;
  bool _showPasswordConfirm = true;

  String? selectedRole;
  String? selectedProgram;
  String? selectedProgramId;
  final List<String> _listRole = ["Mahasiswa", "Dosen", "Umum"];
  final List<String> _listProgram = ["Reguler", "Internasional"];

  Future<void> register() async {

    if(selectedRole == null || selectedProgram == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Mohon lengkapi data!"),
        backgroundColor: Colors.red.shade300,
      ));
    }

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Mohon tunggu...'),
        backgroundColor: Colors.green,
      ));

      dynamic res = await _apiClient.register(
        nameController.text,
        emailController.text,
        passwordController.text,
        selectedProgramId!,
        nimController.text,
        groupController.text,
        selectedRole!
      );

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Daftar akun berhasil! Silakan login untuk melanjutkan.'),
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
          child: Stack(children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: Container(
                width: size.width,
                height: size.height,
                padding: const EdgeInsets.symmetric(vertical: 30),
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                "Silakan daftar akun Anda disini.",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.04),
                            InputDecorator(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                labelText: 'Daftar Sebagai',
                                border:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    '-',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: _listRole
                                      .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  value: selectedRole,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedRole = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                return Validator.validateText(value ?? "");
                              },
                              style: TextStyle(
                                fontSize: 14
                              ),
                              decoration: InputDecoration(
                                hintText: "Nama",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
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
                            SizedBox(height: size.height * 0.03),
                            InputDecorator(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                labelText: 'Program',
                                border:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  hint: Text(
                                    '-',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  items: _listProgram
                                      .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                  icon: const Icon(Icons.arrow_drop_down),
                                  iconSize: 24,
                                  elevation: 16,
                                  value: selectedProgram,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedProgram = value;
                                      if(value == "Reguler"){
                                        selectedProgramId = "1";
                                      }else{
                                        selectedProgramId = "2";
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            TextFormField(
                              controller: groupController,
                              validator: (value) {
                                return Validator.validateText(value ?? "");
                              },
                              style: TextStyle(
                                  fontSize: 14
                              ),
                              decoration: InputDecoration(
                                hintText: "Kelompok",
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            TextFormField(
                              controller: nimController,
                              validator: (value) {
                                return Validator.validateText(value ?? "");
                              },
                              style: TextStyle(
                                  fontSize: 14
                              ),
                              decoration: InputDecoration(
                                hintText: "NIM",
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
                            SizedBox(height: size.height * 0.03),
                            TextFormField(
                              obscureText: _showPasswordConfirm,
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
                                            () => _showPasswordConfirm = !_showPasswordConfirm);
                                  },
                                  child: Icon(
                                    _showPasswordConfirm
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
                                    onPressed: register,
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 15)),
                                    child: const Text(
                                      "Daftar",
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
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Sudah punya akun?",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Login disini",
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