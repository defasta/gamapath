import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gamapath/screens/home_screen.dart';
import 'package:gamapath/screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  var token = await storage.read(key: 'token');
  print("Token : $token");
  runApp(MaterialApp(
    title: 'Gamapath',
    theme: ThemeData(
      primarySwatch: Colors.blue
    ),
    debugShowCheckedModeBanner: false,
    home: token == null ? LoginScreen() : HomeScreen(),
    //home: LoginScreen(),
  ));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gamapath',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(),
//     );
//   }
// }
