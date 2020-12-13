import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:toast/toast.dart';

class ChatPage extends StatefulWidget {
  ChatPage({this.email, this.id});
  String email;
  String id;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _textEditingController;
  final databaseReference = FirebaseFirestore.instance;
  String text = '';
  File _image;

  // Future<void> signOut() async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> submit() async {
    try {
      if (_textEditingController.text != '' ||
          _textEditingController.text.trim() != '') {
        String x = randomAlphaNumeric(20);
        databaseReference
            .collection("Users")
            .doc(widget.id)
            .collection("Chats")
            .doc(x)
            .set({"message": text, "file": '', "time": DateTime.now()});
        if (_image != null) {
          firebase_storage.Reference ref =
              firebase_storage.FirebaseStorage.instance.ref('/images/$x.jpg');
          await ref.putFile(_image);
          firebase_storage.FirebaseStorage.instance
              .ref('/images/$x.jpg')
              .getDownloadURL()
              .then((value) {
            databaseReference
                .collection("Users")
                .doc(widget.id)
                .collection("Chats")
                .doc(x)
                .set({"message": text, "file": value, "time": DateTime.now()});
          });
        }
        Navigator.pop(context);
        text = '';
      } else {
        Navigator.pop(context);
        Toast.show("Please enter some message before sending", context,
            duration: 3,
            backgroundColor: Colors.lightBlue,
            backgroundRadius: 15,
            textColor: Colors.black);
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<File> getImage() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        _image = image;
      });
      return File(image.path);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = new TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.email}'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add picture and message',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                        Divider(),
                        _image == null
                            ? GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: Container(
                                  height: 200,
                                  child: Center(
                                    child: Icon(Icons.add_a_photo),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  getImage();
                                },
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(_image))),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Message',
                            ),
                            controller: _textEditingController,
                            onChanged: (value) {
                              text = value;
                            },
                            cursorColor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            submit();
                          },
                          child: Center(
                            child: Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              }).then((_) {
            _image = null;
            _textEditingController.clear();
          });
        },
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.id)
              .collection('Chats')
              .orderBy('time', descending: false)
              .snapshots(),
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
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              document.data()['file'] != ''
                                  ? Container(
                                      height: 300,
                                      width: 300,
                                      child: Image.network(
                                          document.data()['file']))
                                  : Container(),
                              Text(
                                document.data()['message'],
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
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
