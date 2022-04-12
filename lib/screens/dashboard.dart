import 'dart:async';
import 'package:catchi/screens/baits.dart';
import 'package:catchi/screens/catch.dart';
import 'package:catchi/screens/locations.dart';
import 'package:flutter/material.dart';
import 'loading.dart';

class Dashboard extends StatefulWidget {
  static const id = 'dashboard';
  String get label => 'Catch Log';
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _loading = false;

  run_timer() {
    setState(() => _loading = true);
    print('waiting 2 secs');
    Timer(const Duration(seconds: 2), () {
      print('...done');
      setState(() => _loading = false);
    });
  }

  Widget reuseableBtn(String label, String routeName) {
    return SizedBox(
      height: 200,
      width: 200,
      child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, routeName),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 50,
            ),
          )),
    );
  }



  @override
  Widget build(BuildContext context) {
    return _loading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(title: Text(widget.label)),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SizedBox(height: 15),
                    reuseableBtn('My Baits', BaitsPg.id),
                    reuseableBtn('Locations', LocationsPg.id),
                    reuseableBtn('Add Catch!', CatchPg.id),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     reuseableBtn('My Baits', run_timer),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          );
  }
}
