import 'package:flutter/material.dart';
import 'dart:math';


class InstructorTest extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  InstructorTest(this.studentName, this.studentPic);

  @override
  _InstructorTestState createState() => _InstructorTestState(studentName, studentPic);
}

class _InstructorTestState extends State<InstructorTest> {
    List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  _InstructorTestState(this.studentName, this.studentPic);

  PageController pC = new PageController();

  int answer = -1;

  @override
  void initState() {
    _shuffleStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFC3C5C7),
      floatingActionButton: FloatingActionButton(
        onPressed: answer != -1 ? () => pC.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic) : null,
        child: Icon(Icons.keyboard_arrow_right),
      ),
      body: SafeArea(
        bottom: true,
        child: PageView.builder(
          controller: pC,
          onPageChanged: ((_){
            setState(() {
              answer = -1;
            });
          }),
          itemCount: studentName.length,
          physics: new NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index){
            return Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height/2-75,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          studentPic[index],
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent chunk){
                            if(chunk == null){
                              return child;
                            }
                            else{
                              return Center(
                                child: CircularProgressIndicator(
                                value: chunk.expectedTotalBytes != null ? chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes : null,
                              ));
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            RadioListTile(
                              value: 0,
                              groupValue: answer, 
                              onChanged: _selectAnswer,
                            ),
                            RadioListTile(
                              value: 1,
                              groupValue: answer, 
                              onChanged: _selectAnswer,
                            ),
                            RadioListTile(
                              value: 2,
                              groupValue: answer, 
                              onChanged: _selectAnswer,
                            ),
                            RadioListTile(
                              value: 3,
                              groupValue: answer, 
                              onChanged: _selectAnswer,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
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

  _getAnswers(){

    for(int i = 0; i < 3; i++){

    }
  }

  _selectAnswer(int index){
    print(index);
    setState(() {
      answer = index;
    });
  }

  processAnswer(){

  }
}

