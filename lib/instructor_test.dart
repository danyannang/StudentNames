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

  List<String> answers = new List<String>();
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
          itemCount: studentName.length + 1,
          physics: new NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index){
            return Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    index < studentName.length ? _question(index) :
                    _finishedScreen(),
                  ],
                )
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
    answers.add(givenAnswer);
  }

  Widget _question(int index){
    return Container(
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
                      )
                    );
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: answerCont,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
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
        ],
      )
    );
  }

  _finishedScreen(){
    return Column(
      children: <Widget>[
        Container(
          height: 525,
          child: ListView.builder(
            itemCount: answers.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 7),
                          height: 150,
                          width: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                studentPic[index],
                              )
                            ),
                          )
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            studentName[index].toLowerCase().contains(answers[index].toLowerCase())  ? Icon(Icons.check, color: Color(0xFF249e7e), size: 45,) : 
                              Icon(Icons.close, color: Colors.red, size: 45),
                            Text("Correct Answer:", style: TextStyle(fontSize: 20),),
                            Text(studentName[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            SizedBox(height: 10),
                            Text("Your Answer:", style: TextStyle(fontSize: 20),),
                            Text(answers[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width-50,
                      margin: EdgeInsets.only(left: 25, right: 25),
                      decoration: BoxDecoration(
                        color: studentName[index].toLowerCase().contains(answers[index].toLowerCase()) ? Color(0xFF249e7e) : Colors.red,
                      ),
                    ),
                  ],
                )
              );
            }
          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height-555,
        )
      ],
    );
  }
}