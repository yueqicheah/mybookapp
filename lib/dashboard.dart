import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mybookapp/answers.dart';
import 'package:mybookapp/login.dart';
import 'package:toast/toast.dart';

class DashBoardScreen extends StatefulWidget {
  int index = 0;

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final databaseReference = FirebaseFirestore.instance;
  TextEditingController _textEditingController;
  List<String> ques = [];

  bool loading = true;
  bool loading1 = true;

  bool doneQuestion = false;
  String answer = '';

  // Future<void> signOut() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> getQuestion() async {
    ques = [];
    try {
      final questions = await databaseReference
          .collection('Questions')
          .doc("4hhMWKARNQGXtN40UyUQ")
          .get();
      if (questions != null) {
        for (int i = 1; i <= 20; i++) {
          ques.add(questions.data()['question$i']);
        }
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDone() async {
    try {
      final done =
          await databaseReference.collection('Users').doc(userId).get();
      if (done != null) {
        String isDone = done.data()['isDone'];
        if (isDone == "true") {
          doneQuestion = true;
        } else {
          doneQuestion = false;
        }
        setState(() {
          loading1 = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textEditingController = new TextEditingController();
    getDone();
    getQuestion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return doneQuestion
        ? Answers()
        : Scaffold(
            appBar: AppBar(
                // actions: <Widget>[
                //   FlatButton(
                //     child: Text(
                //       'Logout',
                //       style: TextStyle(
                //         fontSize: 18.0,
                //         color: Colors.white,
                //       ),
                //     ),
                //     onPressed: signOut,
                //   ),
                // ],
                ),
            body: loading || loading1
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: CircularProgressIndicator()))
                : Column(
                    children: [
                      SizedBox(
                        height: h / 7,
                      ),
                      Text(
                        "Question " +
                            (widget.index + 1).toString() +
                            " / 20" +
                            "\n" +
                            ques[widget.index],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: h / 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: TextField(
                            controller: _textEditingController,
                            onChanged: (value) {
                              answer = value;
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                hintText: 'Please enter your answer..',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _textEditingController.clear();
                                  },
                                ))),
                      ),
                      SizedBox(
                        height: h / 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: h / 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: RaisedButton(
                                onPressed: () {
                                  print(userId);

                                  if (_textEditingController.text == '' ||
                                      _textEditingController.text.trim() ==
                                          '') {
                                    Toast.show(
                                        "Please enter your answer before submit",
                                        context,
                                        duration: 3,
                                        backgroundColor: Colors.lightBlue,
                                        backgroundRadius: 15,
                                        textColor: Colors.black);
                                    return null;
                                  }
                                  databaseReference
                                      .collection('Users')
                                      .doc(userId)
                                      .update({
                                    "answer${widget.index + 1}": answer,
                                  }).then((value) {
                                    _textEditingController.clear();
                                    setState(() {
                                      widget.index++;
                                    });
                                  });
                                  if (widget.index == 19) {
                                    databaseReference
                                        .collection('Users')
                                        .doc(userId)
                                        .update({
                                      "isDone": "true",
                                    }).then((_) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => Answers(),
                                      ));
                                    });
                                  }
                                },
                                child: Text(
                                  widget.index == 19
                                      ? "See My Answers"
                                      : "Next",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ));
  }
}
