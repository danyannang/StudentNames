import 'package:flutter/material.dart';

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
      backgroundColor: Color(0xFFE3E5E7),
      appBar: AppBar(
        title: Text("Student View"),
        backgroundColor: Color(0xFF249e7e),
      ),
      body: Container(
        child: GridView.count(
          childAspectRatio: .65,
          // padding: const EdgeInsets.all(4.0),
          crossAxisCount: 2,
          children: List.generate(
            studentName.length,
            (index) {
              return Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 7),
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          studentPic[index],
                        )
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 15.0),
                          blurRadius: 6.0
                        ),
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 7.5),
                          blurRadius: 3.0
                        )
                      ]
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, -15.0),
                          blurRadius: 6.0
                        ),
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 15.0),
                          blurRadius: 6.0
                        ),
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 7.5),
                          blurRadius: 3.0
                        )
                      ]
                    ),
                    child: Text(studentName[index], style: TextStyle(color: Color(0xFF249e7e), fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
