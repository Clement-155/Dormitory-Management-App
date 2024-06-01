import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fp_golekost/login_register/LoginPage/loginPage.dart';
import 'package:fp_golekost/login_register/LoginPage/signupPage.dart';
import 'package:fp_golekost/profile/ViewProfilePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
        seedColor: Color.fromRGBO(143, 148, 251, 1),
        // ···
        brightness: Brightness.dark,
        )),
      home: LoginPage(),
    );
  }
}
