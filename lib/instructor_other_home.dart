import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';
import 'package:student_names/instructor_rollcall.dart';

class InstructorOtherHome extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  InstructorOtherHome(this.studentName, this.studentPic);
  @override
  _InstructorOtherHomeState createState() =>
      _InstructorOtherHomeState(studentName, studentPic);
}

class _InstructorOtherHomeState extends State<InstructorOtherHome> {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  TextEditingController courseName = new TextEditingController();
  _InstructorOtherHomeState(this.studentName, this.studentPic);
  final GlobalKey<ScaffoldState> scaffoldRevKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  showEditCourseNameDialog(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    Widget nameField = Center(
      child: Container(
        width: width / 1.5,
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Your course\'s new name',
          ),
          controller: courseName,
        ),
      ),
    );

    // set up the button
    Widget changeButton = FlatButton(
      child: Text("Confirm", style: TextStyle(color: Color(0xFF249e7e),)),
      onPressed: () {
        //method()
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Change Name of Course"),
      actions: [
        nameField,
        changeButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3E5E7),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Center(child: Text('Other')),
          backgroundColor: Color(0xFF249e7e),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: () {
                showEditCourseNameDialog(context);
              },
            )
          ]),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ButtonTheme(
                  buttonColor: Color(0xFF249e7e),
                  height: MediaQuery.of(context).size.height / 5,
                  child: RaisedButton(
                      elevation: 25,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                          'Placeholder',
                          style: TextStyle(color: Colors.white, fontSize: 20)
                      )),
                ),
                ButtonTheme(
                  buttonColor: Color(0xFF249e7e),
                  height: MediaQuery.of(context).size.height / 5,
                  child: RaisedButton(
                      elevation: 25,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Placeholder',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ),
                ButtonTheme(
                  buttonColor: Color(0xFF249e7e),
                  height: MediaQuery.of(context).size.height / 5,
                  child: RaisedButton(
                      elevation: 25,
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorRollcall(studentName, studentPic))),
                      child: Text(
                        'Rollcall',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                ),
              ],
            )),
      ),
    );
  }
}
