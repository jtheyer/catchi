import 'package:flutter/material.dart';

class LocationsPg extends StatefulWidget {
  static const id = 'locationsPg';
  const LocationsPg({ Key? key }) : super(key: key);

  @override
  State<LocationsPg> createState() => _LocationsPgState();
}

class _LocationsPgState extends State<LocationsPg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: const Text('locations page'),
        ),
      ),
    );
  }
}