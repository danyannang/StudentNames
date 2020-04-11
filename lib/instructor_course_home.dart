import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_names/login_home.dart';
import 'package:student_names/instructor_student_view.dart';
import 'package:student_names/instructor_student_review.dart';
import 'package:student_names/instructor_other_home.dart';

/*
 * After selecting a course, an instructor has three different options.
 */
class InstructorCourseHome extends StatefulWidget {
  final List<DocumentSnapshot> docs;
  final DocumentSnapshot doc;
  InstructorCourseHome(this.docs, this.doc);
  @override
  _InstructorCourseHomeState createState() =>
      _InstructorCourseHomeState(docs, doc);
}

class _InstructorCourseHomeState extends State<InstructorCourseHome> {
  String n = "";
  String id = "";
  final List<DocumentSnapshot> docs;
  final DocumentSnapshot doc;
  TextEditingController courseName = new TextEditingController();

  _InstructorCourseHomeState(this.docs, this.doc);

  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();

  void _changeName() async {
    Firestore.instance
        .collection('Classes')
        .document(doc.documentID)
        .updateData({
      'Name': courseName.text,
    }).then((_) {
      n = courseName.text;
      setState(() {});
    });
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
        _changeName();
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
  void initState() {
    super.initState();
    n = doc['Name'];
    _getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3C5C7),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Center(child: Text(n)),
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
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentView(studentName, studentPic))),
                  child: Text(
                    'View Students',
                    style: TextStyle(color: Colors.white, fontSize: 20)
                  )),
            ),
            ButtonTheme(
              buttonColor: Color(0xFF249e7e),
              height: MediaQuery.of(context).size.height / 5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StudentReview(studentName, studentPic))),
                  child: Text(
                    'Review',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ),
            ButtonTheme(
              buttonColor: Color(0xFF249e7e),
              height: MediaQuery.of(context).size.height / 5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorOtherHome(studentName, studentPic))),
                  child: Text(
                    'Test/Games',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ),
          ],
        )),
      ),
    );
  }

  void _getInstructorInfo() async { // Useless in newer version of app
    id = await getUID();
    n = await getName(id);
  }

  getData() {
    print(doc.data['Name']);
    docs.forEach((d) {
      print(d.data['Name']);
    });
  }

  _getStudents(){
    docs.forEach((data) {
      studentName.add(data.data['Name']);
      studentPic.add(data.data['Pic']);
    });
  }
}
