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
  TextEditingController answerCont = new TextEditingController();

  bool answer = false;

  @override
  void initState() {
    _shuffleStudents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFC3C5C7),
      body: SafeArea(
        bottom: true,
        child: PageView.builder(
          controller: pC,
          onPageChanged: ((_){
            setState(() {
              answer = false;
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
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
                      child: TextField(
                        controller: answerCont,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: answerCont.text == "" ? null : (){
                        _processAnswer(pC.page.ceil());
                        answerCont.clear();
                        pC.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeOutCubic);
                      },
                      child: index == studentName.length-1 ? Text("Submit") : Text("Next"),
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

  _processAnswer(int correctAnswer){
    String answer = studentName[correctAnswer].toLowerCase();
    String givenAnswer = answerCont.text.toLowerCase();
    print(answer);
    print(givenAnswer);
    if(answer == givenAnswer){
      print("correct");
    }
    else{
      print("wrong");
    }
  }
}
