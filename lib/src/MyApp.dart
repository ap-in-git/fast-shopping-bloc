import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Shopping using Sqlite',
      home: HomeScreen(),
    );

  }
}