import 'package:flutter/material.dart';
import 'package:student_names/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Names',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SilentLogIn(),
    );
  }
}
