import 'package:flutter/material.dart';
import 'instructor_course_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_names/login_home.dart';
import 'package:student_names/instructor_add_course.dart';
import 'package:student_names/instructor_remove_course.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:student_names/login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn;


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
  List<DocumentSnapshot> documents = new List<DocumentSnapshot>();

  //On initialization, get the list of all the instructor's classes from firestore.
  void _getClasses() async {
    documents.clear();
    id = await getUID();
    await Firestore.instance.collection('/Classes').getDocuments().then((docs){
      print(docs);
      docs.documents.forEach((doc){
        if(doc.data['ID'] == id){
          documents.add(doc);
        }
      });
    });

    classes = documents.length;
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
      child: Text("Add Course", style: TextStyle(color: Color(0xFF249e7e))),
      onPressed: () {
        Navigator.of(context).pop();
        _addClass();
      },
    );

    Widget removeButton = FlatButton(
      child: Text("Remove Course", style: TextStyle(color: Color(0xFF249e7e))),
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
      backgroundColor: Color(0xFFC3C5C7),
      appBar: AppBar(
        centerTitle: true,
        title: Center(child: const Text('Your Courses')),
        backgroundColor: Color(0xFF249e7e),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.all_out),
            onPressed: () async{
              Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new LoginPage()));            
              await _googleSignIn.signOut();
              await _auth.signOut();
            },
          ),
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
            if(documents.length > 0){
              return ButtonTheme(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    elevation: 25,
                    onPressed: () async{
                      await Firestore.instance.collection('/Classes').document(documents[index].documentID).collection('Students').getDocuments().then((dat){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => InstructorCourseHome(dat.documents, documents[index]))).then((_){
                          _getClasses();
                        });
                        setState((){});
                      });
                    },
                    child: Text(documents[index]['Name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    color: Color(0xFF249e7e),
                  ),
                ),
              );
            }
            else{
              return Text("");
            }
          }
        ),
      )
    );
  }
}


