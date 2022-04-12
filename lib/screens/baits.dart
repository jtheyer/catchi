import 'package:flutter/material.dart';

class BaitsPg extends StatefulWidget {
  static const id = 'baitsPg';
  const BaitsPg({ Key? key }) : super(key: key);

  @override
  State<BaitsPg> createState() => _BaitsPgState();
}

class _BaitsPgState extends State<BaitsPg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: const Text('baits page'),
        ),
      ),
    );
  }
}