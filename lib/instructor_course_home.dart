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
      child: Text("Confirm"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Center(child: Text(n)),
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
              height: MediaQuery.of(context).size.height / 5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => _viewStudents(),
                  child: Text(
                    'View Students',
                  )),
            ),
            ButtonTheme(
              height: MediaQuery.of(context).size.height / 5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Review',
                  )),
            ),
            ButtonTheme(
              height: MediaQuery.of(context).size.height / 5,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Games',
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

  _viewStudents() async {
    List<String> studentName = new List<String>();
    List<String> studentPic = new List<String>();
    docs.forEach((data) {
      studentName.add(data.data['Name']);
      studentPic.add(data.data['Pic']);
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentView(studentName, studentPic)));
  }
}

class StudentView extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  StudentView(this.studentName, this.studentPic);
  @override
  _StudentViewState createState() => _StudentViewState(studentName, studentPic);
}

class _StudentViewState extends State<StudentView> {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  _StudentViewState(this.studentName, this.studentPic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Student View"),
        ),
        body: Container(
            color: Colors.black87,
            child: GridView.count(
                childAspectRatio: .65,
                padding: const EdgeInsets.all(4.0),
                crossAxisCount: 2,
                children: List.generate(studentName.length, (index) {
                  return Card(
                    color: Color.fromRGBO(120, 0, 0, 1),
                    child: ListTile(
                      title: Image.network(
                        studentPic[index],
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent chunk) {
                          if (chunk == null) {
                            return child;
                          } else {
                            return Center(
                                child: CircularProgressIndicator(
                              value: chunk.expectedTotalBytes != null
                                  ? chunk.cumulativeBytesLoaded /
                                      chunk.expectedTotalBytes
                                  : null,
                            ));
                          }
                        },
                        height: 235,
                      ),
                      subtitle: Text(studentName[index],
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  );

                  // return GridTile(
                  //   child: Column(
                  //     children: <Widget>[
                  //       Image.network(studentPic[index],
                  //         loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent chunk){
                  //           if(chunk == null){
                  //             return child;
                  //           }
                  //           else{
                  //             return Center(
                  //               child: CircularProgressIndicator(
                  //                 value: chunk.expectedTotalBytes != null ? chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes : null,
                  //               )
                  //             );
                  //           }
                  //         },
                  //         fit: BoxFit.cover,
                  //         height: 250,
                  //       ),
                  //       Text(studentName[index].toString())
                  //     ],
                  //   )
                  // );
                }))));
  }
}
