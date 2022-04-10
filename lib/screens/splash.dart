import 'package:catchi/main.dart';
import 'package:catchi/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


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

// const spinner = SpinKitFoldingCube(
//   color: Colors.deepOrange,
//   size: 80.0,
//   duration: Duration(seconds: 4),
// );

  
class SplashLoad extends StatelessWidget {
  const SplashLoad({ Key? key }) : super(key: key);
  static const Widget spinner = SpinKitRipple(color: Colors.white);
  static const String id = 'splashScreen';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: spinner,
      ),
    );
  }

}


// class SplashScreen extends StatefulWidget {
//   static const String id = 'splashScreen';
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   // @override
//   // void initState() {
//   //   try{
//   //   super.initState();
//   //   Firebase.initializeApp().whenComplete(() {
//   //     print("Firebase init success!");
//   //     setState(() {});
//   //   });
//   //   }catch (e){
//   //     print('Firebase init failed w/ error: $e');
//   //     //pass to login screen "Cant login" if init app fails
//   //     return;
//   //   }
//   // }

//   // Center firebase_error() {
//   //   return Center(child: const Text('Firebase init failed'));
//   // }

//   // show_spinner() {
//   //   @override
//   //   Widget build(BuildContext context) {
//   //     return Container(
//   //       child: spinner,
//   //     );
//   //   }
//   // }
//   final spinner = SpinKitRipple(color: Colors.white);
//    @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black54,
//       body: Center(
//         child: spinner,
//       ),
//     );
//   }


// //  @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder(
// //       // Initialize FlutterFire
// //       future: Firebase.initializeApp(),
// //       builder: (context, snapshot) {
// //         // Check for errors
// //         if (snapshot.hasError) {
// //           return firebase_error();
// //         }

// //         // Once complete, show your application
// //         if (snapshot.connectionState == ConnectionState.done) {
// //          return MyApp();
// //         }

// //         // Otherwise, show something whilst waiting for initialization to complete
// //         return show_spinner();
// //       },
// //     );
// //   }

// }
