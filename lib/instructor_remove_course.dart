import 'package:flutter/material.dart';
import 'instructor_course_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_names/login_home.dart';

//Going to be changed to a listview builder instead...
/*
 * Home page for the instructors.
 */
class InstructorRemoveCourse extends StatefulWidget {
  @override
  _InstructorRemoveCourseState createState() => _InstructorRemoveCourseState();
}

class _InstructorRemoveCourseState extends State<InstructorRemoveCourse> {
  var snapShot;
  String id;
  var classes;
  List<DocumentSnapshot> documents = new List<DocumentSnapshot>();

  showEditClassesDialog(BuildContext context, var index) {
    // set up the button
    Widget addButton = FlatButton(
      child: Text("Confirm", style: TextStyle(color: Color(0xFF249e7e))),
      onPressed: () async {
        await Firestore.instance.collection('/Classes').document(documents[index].documentID).delete().then((_){
            _getClasses();
            setState((){});
          });
        Navigator.of(context).pop();
      },
    );

    Widget removeButton = FlatButton(
      child: Text("Cancel", style: TextStyle(color: Color(0xFF249e7e))),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Are you sure you want to delete this class?"),
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
                color: Color(0xFF249e7e),
                icon: Icon(
                  Icons.settings,
                ),
                onPressed: () {
                  null;
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        onPressed: () async{
                          showEditClassesDialog(context, index);
//                          await Firestore.instance.collection('/Classes').document(documents[index].documentID).collection('Students').getDocuments().then((dat){
//                            Navigator.push(context,MaterialPageRoute(builder: (context) => InstructorCourseHome(dat.documents, documents[index]))).then((_){
//                              _getClasses();
//                            });
//                            setState((){});
//                          });
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


