import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:work_os_firebase/screens/auth/login_screen.dart';
import 'package:work_os_firebase/screens/task/tasks_screen.dart';
bool? isLogin;

void main()async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if(user == null)
  {
    isLogin = false;
  }
  else
  {
    isLogin =true;
  }
   runApp(  MyApp());
}

class MyApp extends StatelessWidget {
    MyApp({Key? key}) : super(key: key);
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffEDE7DC),
      ),
      debugShowCheckedModeBanner: false,
      home:isLogin == false ?  const LoginScreen() : const TasksScreen(),
    );

    }
}
