import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybookapp/Chat.dart';
import 'package:mybookapp/login.dart';

class AdminAnswers extends StatefulWidget {
  AdminAnswers({this.id, this.email});
  String id;
  String email;
  @override
  _AdminAnswersState createState() => _AdminAnswersState();
}

class _AdminAnswersState extends State<AdminAnswers> {
  final databaseReference = FirebaseFirestore.instance;
  List<String> list = [];
  List<String> ques = [];
  bool isLoading = true;
  // Future<void> signOut() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> getData() async {
    ques = [];
    list = [];
    try {
      final questions = await databaseReference
          .collection('Questions')
          .doc("4hhMWKARNQGXtN40UyUQ")
          .get();
      if (questions != null) {
        for (int i = 1; i <= 20; i++) {
          ques.add(questions.data()['question$i']);
        }
      }

      final snapshot =
          await databaseReference.collection('Users').doc(widget.id).get();
      if (snapshot != null) {
        for (int i = 1; i <= 20; i++) {
          list.add(snapshot.data()['answer$i']);
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) => Chat(),
      //     ));
      //   },
      //   child: Icon(Icons.inbox),
      // ),
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text(widget.email),
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
      body: isLoading
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
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                              elevation: 5,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                      child: Text(
                                    "Q${index + 1}: ${ques[index]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                      child: Text(
                                    "${list[index]}",
                                    style: TextStyle(fontSize: 17),
                                  )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )),
                        );
                      }),
                )
              ],
            ),
    );
  }
}
