import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_names/login_home.dart';

/*
 * After selecting a course, an instructor has three different options.
 */
class InstructorCourseHome extends StatefulWidget {
  final List<DocumentSnapshot> docs;
  final DocumentSnapshot doc;
  InstructorCourseHome(this.docs, this.doc);
  @override
  _InstructorCourseHomeState createState() => _InstructorCourseHomeState(docs, doc);
}

class _InstructorCourseHomeState extends State<InstructorCourseHome> {

  String name = "";
  String id = "";
  final List<DocumentSnapshot> docs;
  final DocumentSnapshot doc;

  _InstructorCourseHomeState(this.docs, this.doc);

  @override
  void initState() {
    _getInstructorInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(child: Text(doc.data['Name'])),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: null,
            )
          ]
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => getData(),),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ButtonTheme(
              height: MediaQuery.of(context).size.height/5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'View Students',
                  )
              ),
            ),
            ButtonTheme(
              height: MediaQuery.of(context).size.height/5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Review',
                  )
              ),
            ),
            ButtonTheme(
              height: MediaQuery.of(context).size.height/5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Games',
                  )
              ),
            ),
          ],
        )),
      ),
    );
  }

  void _getInstructorInfo() async{
    id = await getUID();
    name = await getName(id);
  }

  getData(){
    print(doc.data['Name']);
    docs.forEach((d){
      print(d.data['Name']);
    });
  }
}