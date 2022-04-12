import 'dart:async';
import 'package:catchi/screens/dashboard.dart';
import 'package:catchi/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'loading.dart';

// Implement login page later. Focus on local storage now and 
// allow the sign up option later (to sync). 

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const id = "login";
  final String label = 'Login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? user;
  bool _loading = false;
  late String email;
  late String password;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /* Stream is listening for auth changes. Select local storage 
  *  when signed out and Firebase when signed in. Immediately sync
  *  data upon sign in, to pull in anything added from local or website.
  */
  setStorage(user) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        print('..use local storage!');
        // useLocalStorage();
      } else {
        print('User is signed in!');
        print('..use Firestore!');
        // syncData();
        // useFirestore();
      }
    });
  }

  googleLoginWrapper() async {
    setState(() => _loading = true);
    final googUser = signInWithGoogle();
    if (googUser != null) {
      user = FirebaseAuth.instance.currentUser;
      print('Logged in as: ${user?.email}');
    }
    Timer(const Duration(seconds: 3), () {
      //Callback to choose local or Firestore db, should know if logged in or not by now...
      setState(() {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=>const Dashboard(),
          fullscreenDialog: true));
        _loading = false;
      });
    });
  }

  emailPwLoginWrapper() async {
    setState(() { _loading = true;  });
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      // if (user != null) {
      // currentUser = await _auth.currentUser();
      // print('logged in as ${currentUser.email}');
      // Navigator.pushReplacementNamed(context, MenusScreen.id);
      // }
    } catch (e) {
      print('Could not sign in!');
      print('signInWithEmailAndPassword error: $e');
      const start = '[';
      const end = ']';
      final startIndex = e.toString().indexOf(start);
      final endIndex = e
          .toString()
          .indexOf(end, startIndex + start.length);
      final err = e
          .toString()
          .substring(startIndex + start.length, endIndex);
      switch (err) {
        case 'firebase_auth/network-request-failed':
          print('No network!');
          // set to use local storage here
          break;
        default:
          print('Unknown error: $err');
          break;
      }
    }
    setState(() {
      _loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return _loading
        ? const LoadingScreen()
        : Scaffold(
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
                    onPressed: () {
                      googleLoginWrapper();
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
