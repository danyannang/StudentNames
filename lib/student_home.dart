import 'package:flutter/material.dart';

/*
 * Home page for the students.
 */
class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Center(child: const Text('Home')),
          actions: <Widget>[
            IconButton(
              icon: Icon( //Centering the title...
                null,
              ),
              onPressed: null,
            )
          ]),
      body: Center(
        child: Text("Student Home"),
      ),
    );
  }
}
