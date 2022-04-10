import 'package:catchi/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = "login";
  final String label = 'Login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final user = FirebaseAuth.instance.currentUser;
  bool _splashing = false;
  late final String email;
  late final String password;

    @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() { 
      print("completed firebase init!");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _splashing ? 
    const SplashLoad() : 
    Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 65.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 80.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (newVal) {
                email = newVal;
              },
              decoration: const InputDecoration(
                hintText: ' E-mail',
              ),
            ),
            TextField(
              obscureText: true,
              onChanged: (newVal) {
                password = newVal;
              },
              decoration: const InputDecoration(
                hintText: ' Password',
              ),
            ),
            // ignore: todo
            //TODO: Add 'Remember me' checkbox (make login persist)
            const SizedBox(
              height: 40.0,
            ),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () async {
                setState(() {
                  _splashing = true;
                });
                try {
                  final user = await _auth.signInWithEmailAndPassword(
                      email: email.trim(), password: password.trim());
                  // if (user != null) {
                    // currentUser = await _auth.currentUser();
                    // print('logged in as ${currentUser.email}');
                    // Navigator.pushReplacementNamed(context, MenusScreen.id);
                  // }
                } catch (e) {
                  print(e);
                }
                setState(() {
                  _splashing = false;
                });
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  )),
            ),
            const SizedBox(
              height: 5.0,
            ),
            ElevatedButton(
              child: const Text('Google Sign-in'),
              onPressed: () async {
                setState(() {
                  _splashing = true;
                });
                try {
                final goog_user = signInWithGoogle();
                const XXXXXXXX = 'x';
                  // if (user != null) {
                  //   // currentUser = await _auth.currentUser();
                  //   // print('logged in as ${currentUser.email}');
                  //   // Navigator.pushReplacementNamed(context, MenusScreen.id);
                  // }
                } catch (e) {
                  print(e);
                }
                setState(() {
                  _splashing = false;
                });
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
