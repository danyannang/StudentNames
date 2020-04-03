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
      backgroundColor: Color(0xFFF3F5F7),
      appBar: AppBar(
        title: Text("Student View"),
      ),
      body: Container(
        // color: Colors.black87,
        child: GridView.count(
          childAspectRatio: .65,
          padding: const EdgeInsets.all(4.0),
          crossAxisCount: 2,
          children: List.generate(studentName.length, (index) {
            return Container(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 2.0),
                              blurRadius: 6.0
                            )
                          ]
                        ),
                        // height: 225,
                        // width: 125,
                        alignment: Alignment.topCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            studentPic[index],
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent chunk) {
                              if (chunk == null) {
                                return child;
                              } 
                              else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: chunk.expectedTotalBytes != null
                                      ? chunk.cumulativeBytesLoaded /
                                          chunk.expectedTotalBytes
                                      : null,
                                  )
                                );
                              }
                            },
                            // fit: BoxFit.cover,
                          ),
                        )
                      ),
                      SizedBox(height:10),
                      Text(studentName[index], style: TextStyle(color: Colors.black, fontSize: 20))
                    ]
                  ),
                ],
              ),
            );
            },
          ),
        ),
      ),
    );
  }
}
