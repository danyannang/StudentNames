import 'package:flutter/material.dart';
import 'package:student_names/instructor_rollcall.dart';
import 'package:student_names/instructor_test.dart';
import 'package:student_names/instructor_match.dart';

class InstructorOtherHome extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  var documentid;
  InstructorOtherHome(this.studentName, this.studentPic, this.documentid);
  @override
  _InstructorOtherHomeState createState() =>
      _InstructorOtherHomeState(studentName, studentPic, documentid);
}

class _InstructorOtherHomeState extends State<InstructorOtherHome> {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  var documentid;
  TextEditingController courseName = new TextEditingController();
  _InstructorOtherHomeState(this.studentName, this.studentPic, this.documentid);
  final GlobalKey<ScaffoldState> scaffoldRevKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  showEditCourseNameDialog(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    onPressed: () => _testDialog(),
                    child: Text(
                        'Test',
                        style: TextStyle(color: Colors.white, fontSize: 20)
                    )
                  ),
                ),
                ButtonTheme(
                  buttonColor: Color(0xFF249e7e),
                  height: MediaQuery.of(context).size.height / 5,
                  child: RaisedButton(
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("Match"),
                              content: Text("Match the name to each picture"),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorMatch(studentName, studentPic)));
                                  },
                                  child: Text("Ok")
                                )
                              ],
                          );
                        }
                      );
                    },
                    child: Text(
                      'Match',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ),
                ),
                ButtonTheme(
                  buttonColor: Color(0xFF249e7e),
                  height: MediaQuery.of(context).size.height / 5,
                  child: RaisedButton(
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorRollcall(studentName, studentPic, documentid))),
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

  _testDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Test"),
          content: Text("Would you like to test yourself?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text("Yes", style: TextStyle(color: Color(0xFF249e7e))),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorTest(studentName, studentPic)));
              }
            )
          ],
        );
      }
    );
  }
}
