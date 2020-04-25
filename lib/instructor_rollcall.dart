import 'package:flutter/material.dart';
import 'package:student_names/login_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_names/instructor_absences.dart';

class InstructorRollcall extends StatefulWidget {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  var documentid;
  InstructorRollcall(this.studentName, this.studentPic, this.documentid);
  @override
  _InstructorRollcallState createState() =>
      _InstructorRollcallState(studentName, studentPic, documentid);
}

class _InstructorRollcallState extends State<InstructorRollcall> {
  List<String> studentName = new List<String>();
  List<String> studentPic = new List<String>();
  var documentid;
  TextEditingController courseName = new TextEditingController();
  TextEditingController rowCount = new TextEditingController();
  TextEditingController columnCount = new TextEditingController();
  _InstructorRollcallState(this.studentName, this.studentPic, this.documentid);
  final GlobalKey<ScaffoldState> scaffoldRevKey =
      new GlobalKey<ScaffoldState>();
  Map<String, String> student =
      new Map(); //Picture URL will be key in case of identical names
  var gridMainAxis = 0; //0 when rowCount >= columnCount, 1 otherwise
  var started = false; //Whether rollcall is in the process of happening
  var displayName = " "; //Name displayed in the listtile
  var displayPic = ""; //Picture URL for the listtile
  var cur =
      -1; //Current index of image displayed in listtile (used when filling)
  var gridPic = List<String>.filled(2,
      "http://bigwhitebox.org/box.gif"); //To keep track of which pic URL is in which box
  var loading = true;
  var absences = [];
  var currDt = DateTime.now();

  //For retrieving from Firestore

  void _getRoll() async {
    await Firestore.instance
        .collection('/Classes')
        .document(documentid)
        .collection('Roll')
        .document('GridPics')
        .get()
        .then((document) {
      print('Gotten List');
      print(document['Pictures']);
      print((document['Pictures']).runtimeType);
      if ((document['Pictures']).isEmpty) {}
      setState(() {
        gridPic = List<String>.from(document['Pictures']);
      });
    });

    await Firestore.instance
        .collection('/Classes')
        .document(documentid)
        .get()
        .then((document) {
      print('Gotten Nums');
      if (document['Columns'] != "0" && document['Rows'] != "0") {
        setState(() {
          rowCount.text = document['Rows'];
          columnCount.text = document['Columns'];
        });
        print("rows" + rowCount.text);
        print("column" + columnCount.text);
      } else {
        print("No rows and columns");
        setState(() {
          rowCount.text = 0.toString();
          columnCount.text = 1.toString();
        });
      }
    });

    setState(() {
      loading = false;
    });
  }

  void _setRoll() async {
    Firestore.instance.collection('Classes').document(documentid).updateData({
      'Rows': rowCount.text,
      'Columns': columnCount.text,
    });
    Firestore.instance
        .collection('Classes')
        .document(documentid)
        .collection('Roll')
        .document('GridPics')
        .setData({
      'Pictures': gridPic,
    });
    //.then((_) {setState(() {});});
    Firestore.instance
        .collection('Classes')
        .document(documentid)
        .collection('Roll')
        .document((currDt.month).toString() + '-' + (currDt.day).toString() + '-' + (currDt.year).toString()).setData({
      ((currDt.month).toString() + '/' + (currDt.day).toString()): absences,
    });
    print("Roll recorded");
  }

  @override
  void initState() {
    super.initState();
    _getRoll();
    print(gridPic);

    //Pretty much just fills in the map
    for (var i = 0; i < studentPic.length; i++) {
      student[studentPic[i]] = studentName[i];
    }
  }

  rollCallStart() {
    absences = [];
    int curCells = rowCount.text.isEmpty
        ? 0
        : int.parse(rowCount.text) *
            (columnCount.text.isNotEmpty ? int.parse(columnCount.text) : 1);
    print("cells: " + curCells.toString());
    if (curCells == 0) {
      return;
    }
    setState(() {
      started = true;
      cur = 0;
      gridPic = List<String>.filled(
          int.parse(rowCount.text) * int.parse(columnCount.text),
          'http://bigwhitebox.org/box.gif');
      displayPic = studentPic[cur]; //Picture URL for the listtile
      displayName = student[displayPic]; //Name displayed in the listtile
    });
  }

  //Adds student to the absence list of that day
  void isAbsent() async {
    absences.add(studentName[cur]);
    setState(() {
      cur++;
      if (cur == studentPic.length) {
        //All students placed
        print("rollcall end");
        started =
            false; //So that clicking on the boxes now will call showCell instead of fillCell
        cur = -1;
        displayPic = ""; //Picture URL for the listtile
        displayName = " "; //Name displayed in the listtile
        //SAVE STATE OF ROLLCALL IN FIRESTORE HERE
        _setRoll();
      } else {
        displayPic = studentPic[cur];
        displayName = studentName[cur];
      }
    });
  }

  fillCell(index) {
    //If rollcall is in progress, pressing a grid square will fill it in with the student's picture
    setState(() {
      print("fillcell");
      gridPic[index] = studentPic[cur]; //cur increments by one every time,
      displayPic = studentPic[cur];
      displayName = studentName[cur];
      cur++;
      if (cur == studentPic.length) {
        //All students placed
        print("rollcall end");
        started = false; //So that clicking on the boxes now will call showCell instead of fillCell
        cur = -1;
        displayPic = ""; //Picture URL for the listtile
        displayName = " "; //Name displayed in the listtile
        //SAVE STATE OF ROLLCALL IN FIRESTORE HERE
        _setRoll();
      } else {
        displayPic = studentPic[cur];
        displayName = studentName[cur];
      }
    });
  }

  showCell(index) {
    //If rollcall is not in progress, pressing a square will display the student name at the bottom
    print("showcell");
    setState(() {
      displayPic = gridPic[index];
      displayName = gridPic[index] == 'http://bigwhitebox.org/box.gif'
          ? " "
          : student[displayPic];
    });
  }

  showEditCourseNameDialog(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;

    Widget nameField = Row(
      children: <Widget>[
        Container(
          width: width / 5,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Rows',
            ),
            controller: rowCount,
          ),
        ),
        Text(' X '),
        Container(
          width: width / 5,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Columns',
            ),
            controller: columnCount,
          ),
        ),
      ],
    );

    // set up the button
    Widget changeButton = FlatButton(
      child: Text("Confirm",
          style: TextStyle(
            color: Color(0xFF249e7e),
          )),
      onPressed: () {
        //Change grid dimensions, reset boxes
        if (rowCount.text.isNotEmpty && columnCount.text.isNotEmpty) {
          if (int.parse(rowCount.text) == 0 ||
              int.parse(columnCount.text) == 0) {
            gridMainAxis = 0;
            rowCount.text = 0.toString();
            columnCount.text = 1.toString();
          } else if (int.parse(columnCount.text) == 0) {
            gridMainAxis = 1;
            rowCount.text = 1.toString();
          } else if ((int.parse(rowCount.text) >=
                  int.parse(columnCount.text)) &&
              int.parse(columnCount.text) <= 7) {
            // Just do horizontal scrolling if too many columns
            gridMainAxis = 0;
          } else {
            gridMainAxis = 1;
          }
          setState(() {
            displayName = " "; //Name displayed in the listtile
            displayPic = ""; //Picture URL for the listtile
            gridPic = List<String>.filled(
                int.parse(rowCount.text) * int.parse(columnCount.text),
                'http://bigwhitebox.org/box.gif');
          });
        }
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Change Dimensions of Grid"),
      actions: [
        nameField,
        changeButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3E5E7),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Center(child: Text('        Rollcall')),
          backgroundColor: Color(0xFF249e7e),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.calendar_today,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InstructorAbsences(documentid))),
            ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            Container(
              height: MediaQuery.of(context).size.height / 2 - 25,
              child: GridView.count(
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                childAspectRatio: 1,
                shrinkWrap: true,
                scrollDirection: gridMainAxis == 1
                    ? Axis.horizontal
                    : Axis
                        .vertical, //Vertical scrolling if there are more rows, vice versa (Unless there are just too many columns)
                crossAxisCount: gridMainAxis == 1
                    ? (rowCount.text.isNotEmpty ? int.parse(rowCount.text) : 1)
                    : (columnCount.text.isNotEmpty
                        ? int.parse(columnCount.text)
                        : 1), //Changes depending on what the scrollDirection is
                children: List.generate(
                    rowCount.text.isEmpty
                        ? 0
                        : int.parse(rowCount.text) *
                            (columnCount.text.isNotEmpty
                                ? int.parse(columnCount.text)
                                : 1), (index) {
                  //0 is default when row and columns are unset
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: ButtonTheme(
                        minWidth: 500,
                        child: RaisedButton(
                          color: Color(0xFF249e7e),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child:
                                //Text('$index'),
                                Container(
                                    height: 75, //This and width are going to have to use MediaQuery sizes to adjust, also crossAxisCount and itemcount..
                                    width: 75,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: loading == true
                                          ? NetworkImage(
                                              'http://bigwhitebox.org/box.gif')
                                          : NetworkImage(gridPic[
                                              index]), //studentPic[i] otherwise
                                    ))),
                          ),
                          onPressed: () =>
                              started ? fillCell(index) : showCell(index),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Spacer(),
            started
                ? ButtonTheme(
                    buttonColor: Color(0xFF249e7e),
                    height: MediaQuery.of(context).size.height / 20,
                    child: RaisedButton(
                        elevation: 25,
                        onPressed: () => isAbsent(),
                        child: Text(
                          'This Student is Absent',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  )
                : Spacer(),
            Container(
              height: MediaQuery.of(context).size.height / 6, //150
              child: Card(
                  color: Color(0xFF249e7e),
                  child: Row(
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height / 6,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: displayPic == ""
                                      ? NetworkImage(
                                          'http://bigwhitebox.org/box.gif')
                                      : NetworkImage(
                                          displayPic), //studentPic[i] otherwise
                                  fit: BoxFit.fill))),
                      Spacer(),
                      Center(
                          child: Text(
                              displayName, //student[studentPic[i]] otherwise
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ))),
                      Spacer(),
                    ],
                  )
//                ListTile(
//                  isThreeLine: true,
//                  subtitle: Text(""),
//                  leading: Container(
//                      height: 150,
//                      width: 150,
//                      decoration: BoxDecoration(
//                          image: DecorationImage(
//                        image: displayPic == "" ? NetworkImage('http://bigwhitebox.org/box.gif') : NetworkImage(displayPic), //studentPic[i] otherwise
//                            fit: BoxFit.fill
//                      ))),
//                  title: Text(
//                    displayName, //student[studentPic[i]] otherwise
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 30,
//                    ),
//                  ),
//                ),
                  ),
            ),
            ButtonTheme(
              buttonColor: Color(0xFF249e7e),
              height: MediaQuery.of(context).size.height / 20,
              child: RaisedButton(
                  elevation: 25,
                  onPressed: () => rollCallStart(),
                  child: Text(
                    'Start Rollcall',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
