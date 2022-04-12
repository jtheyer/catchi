import 'package:flutter/material.dart';

class CatchPg extends StatefulWidget {
  static const id = 'catchPg';
  const CatchPg({ Key? key }) : super(key: key);

  @override
  State<CatchPg> createState() => _CatchPgState();
}

class _CatchPgState extends State<CatchPg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: const Text('catch page'),
        ),
      ),
    );
  }
}