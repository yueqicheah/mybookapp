import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybookapp/AdminChat.dart';
import 'package:mybookapp/login.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<String> ques = [];
  bool loading = true;
  String text = '';
  final databaseReference = FirebaseFirestore.instance;
  TextEditingController _textEditingController;

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

  _showDialog(int index, String question) async {
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _textEditingController,
                onChanged: (value) {
                  text = value;
                },
                autofocus: true,
                decoration:
                    InputDecoration(labelText: 'Question', hintText: question),
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          FlatButton(
              child: const Text('SUBMIT'),
              onPressed: () {
                loading = true;
                databaseReference
                    .collection('Questions')
                    .doc("4hhMWKARNQGXtN40UyUQ")
                    .update({
                  "question${index + 1}": text.toString(),
                });
                Navigator.pop(context);
                getQuestion();
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    getQuestion();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // Future<void> signOut() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("HELLO ADMIN BRENDEN"),
          actions: [
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Icon(Icons.inbox),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AdminChat(),
                ));
              },
            ),
            // GestureDetector(
            //   child: Padding(
            //     padding: const EdgeInsets.only(right: 8.0),
            //     child: Icon(Icons.exit_to_app),
            //   ),
            //   onTap: () {
            //     signOut();
            //   },
            // ),
          ],
        ),
        body: loading
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(child: CircularProgressIndicator()))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: ques.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                                elevation: 5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                "Q${index + 1}:\n${ques[index]}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            flex: 8),
                                        Expanded(
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: GestureDetector(
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                                onTap: () {
                                                  _showDialog(
                                                      index, ques[index]);
                                                },
                                              )),
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )),
                          );
                        }),
                  ),
                ],
              ),
      ),
    );
  }
}
