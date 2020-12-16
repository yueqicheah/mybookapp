import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mybookapp/AdminAnswer.dart';
import 'package:mybookapp/ChatPage.dart';
import 'package:mybookapp/login.dart';

class AdminChat extends StatefulWidget {
  @override
  _AdminChatState createState() => _AdminChatState();
}

class _AdminChatState extends State<AdminChat> {
  String id;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Chat'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: CircularProgressIndicator()));
            }
            if (!snapshot.hasData) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: Text('Nothing here')));
            }
            return ListView(
              children: snapshot.data.docs.map((document) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(document.data()['userId'])
                                    .collection('Chats')
                                    .orderBy('time', descending: false)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot1) {
                                  if (snapshot1.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  }
                                  return Ink(
                                    color: snapshot1.data.docs.length == 0
                                        ? Colors.grey[200]
                                        : Colors.white,
                                    child: ListTile(
                                      leading: GestureDetector(
                                        child: Icon(Icons.assignment_ind),
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => AdminAnswers(
                                                email: document.data()['email'],
                                                id: document.data()['userId']),
                                          ));
                                        },
                                      ),
                                      title: Text(document.data()['email']),
                                      trailing: GestureDetector(
                                        child: Icon(Icons.chat_bubble_outline),
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                email: document.data()['email'],
                                                id: document.data()['userId']),
                                          ));
                                        },
                                      ),
                                    ),
                                  );
                                })),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
