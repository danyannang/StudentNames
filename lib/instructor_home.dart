import 'package:flutter/material.dart';
import 'instructor_course_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_names/login_home.dart';
import 'package:student_names/instructor_add_course.dart';
import 'package:student_names/instructor_remove_course.dart';


//Going to be changed to a listview builder instead...
/*
 * Home page for the instructors.
 */
class InstructorHome extends StatefulWidget {
  @override
  _InstructorHomeState createState() => _InstructorHomeState();
}

class _InstructorHomeState extends State<InstructorHome> {
  var snapShot;
  String id;
  var classes;
  QuerySnapshot result;
  List<DocumentSnapshot> documents;

  //On initialization, get the list of all the instructor's classes from firestore.
  void _getClasses() async {
    id = await getUID();
    print(id);
    result = await Firestore.instance.collection(id + 'CLASSES').getDocuments();
    print(result);
    documents = result.documents;
    classes = documents.length;
    print(documents);
    print(classes);
    setState((){});
  }

  void _addClass() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorAddCourse())).then((_){
      _getClasses();
      setState((){});});
  }

  void _deleteClass() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorRemoveCourse()));
  }

  showEditClassesDialog(BuildContext context) {
    // set up the button
    Widget addButton = FlatButton(
      child: Text("Add Course"),
      onPressed: () {
        Navigator.of(context).pop();
        _addClass();
      },
    );

    Widget removeButton = FlatButton(
      child: Text("Remove Course"),
      onPressed: () {
        Navigator.of(context).pop();
        _deleteClass();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Edit List of Courses"),
      actions: [
        addButton,
        removeButton,
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
    _getClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Center(child: const Text('Your Courses')),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: () {
                showEditClassesDialog(context);
              }, //Add course, remove course
            )
          ]
        ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: new ListView.builder(
          itemCount: classes,
          itemBuilder: (BuildContext context, int index) { //Just has a blank before the list of class names is loaded.
            if (documents == null) {
              return Text('');
            }
            else
            return ButtonTheme(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    elevation: 25,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InstructorCourseHome())),
                    child: Text(
                      documents[index].documentID,
                    )),
              ),
            );
          }
        ),
      )
    );
  }
}


