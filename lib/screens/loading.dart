import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       children: const <Widget>[
  //         SpinKitChasingDots(
  //           color: Colors.red,
  //           size: 50.0,
  //         ),
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // child: Text('Loading......'),
        child: SpinKitRipple(
          color: Colors.deepOrangeAccent,
          size: 800,),
      ),
    );
  }
}
