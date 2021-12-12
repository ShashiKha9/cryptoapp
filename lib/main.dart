import 'package:cryptoapp/pages/coins_screen.dart';
import 'package:cryptoapp/pages/pagescontrol.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageScreen(),
    );
  }
}
