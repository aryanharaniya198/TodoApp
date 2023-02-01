import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todoapp/Service/Auth_Service.dart';
import 'package:todoapp/screens/AddTodo.dart';
import 'package:todoapp/screens/HomeScreen.dart';
import 'package:todoapp/screens/SignUp.dart';
import 'package:todoapp/screens/SignIn.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = SignUpPage();
  AuthClass authClass = AuthClass();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async
  {
    String? token = await authClass.getToken();
    if(token!=null)
      {
        setState(() {
          currentPage = SignUpPage();
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: currentPage
    );
  }
}
