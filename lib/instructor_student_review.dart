import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:math';

class StudentReview extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  StudentReview(this.studentName, this.studentPic);
  @override
  _StudentReviewState createState() =>
      _StudentReviewState(studentName, studentPic);
}

class _StudentReviewState extends State<StudentReview> {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  _StudentReviewState(this.studentName, this.studentPic);
  final GlobalKey<ScaffoldState> scaffoldRevKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _shuffleStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3C5C7),
      key: scaffoldRevKey,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text("Student Review"),
        backgroundColor: Color(0xFF249e7e),
      ),
      body: Center(
        child: PageView.builder(
          itemCount: studentName.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.all(50),
                child: FlipCard(
                  back: Center(
                    child: Text(studentName[index], style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Color(0xFF249e7e)))
                  ),
                  front: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      studentPic[index], 
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent chunk) {
                        if (chunk == null) {
                          return child;
                        } 
                        else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: chunk.expectedTotalBytes != null
                                ? chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes
                                : null,
                            )
                          );
                        }
                      }, 
                      height: 400
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  _shuffleStudents(){
    for (int i = 0; i < studentName.length-1; ++i){
      int j = Random().nextInt(studentName.length);
      var tempName = studentName[i];
      studentName[i] = studentName[j];
      studentName[j] = tempName;

      var tempPic = studentPic[i];
      studentPic[i] = studentPic[j];
      studentPic[j] = tempPic;
    }
  }

}
