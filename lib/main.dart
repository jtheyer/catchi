import 'package:catchi/screens/dashboard.dart';
import 'package:catchi/screens/login.dart';
import 'package:catchi/screens/splash.dart';
import 'package:flutter/material.dart';
import './screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Catchi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: LoginScreen.id,
        routes: {
          SplashLoad.id: (context) => const SplashLoad(),
          LoginScreen.id: (context) => const LoginScreen(),
          Dashboard.id: (context) => const Dashboard()
        });
  }
}
