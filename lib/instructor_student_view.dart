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
      appBar: AppBar(
        title: Text("Student View"),
      ),
      body: Container(
        color: Colors.black87,
        child: GridView.count(
          childAspectRatio: .65,
          padding: const EdgeInsets.all(4.0),
          crossAxisCount: 2,
          children: List.generate(
            studentName.length,
            (index) {
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
                  subtitle: Text(
                    studentName[index],
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
