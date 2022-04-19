import 'package:catchi/screens/baits.dart';
import 'package:catchi/screens/catch.dart';
import 'package:catchi/screens/dashboard.dart';
import 'package:catchi/screens/locations.dart';
import 'package:catchi/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main(List<String> args) async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  } catch (e) {
    print(e);
  }
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
        initialRoute: Dashboard.id,
        routes: {
          LoginScreen.id: (context) => const LoginScreen(),
          Dashboard.id: (context) => const Dashboard(),
          CatchPg.id: (context) => const CatchPg(),
          BaitsPg.id: (context) => BaitsPg(),
          LocationsPg.id: (context) => const LocationsPg(),
        });
  }
}

void logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}
