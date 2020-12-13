import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:mybookapp/adminpanel.dart';
import 'package:mybookapp/dashboard.dart';

String userId;

class LoginScreen extends StatelessWidget {
  final databaseReference = FirebaseFirestore.instance;

  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    return FlutterLogin(
      emailValidator: (value) {
        if (!value.contains('gmail.com'))
          return 'please enter correct email';
        else
          email = value;
      },
      passwordValidator: (value) {
        if (value.length < 6)
          return 'password must be at least 6 characters';
        else
          password = value;
      },
      title: 'My Books App',
      onLogin: (_) async {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        userId = userCredential.user.uid;

        if (email == "brenden@gmail.com" && password == "brenden") {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AdminPanel(),
          ));
        }
      },
      onSignup: (_) async {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        databaseReference
            .collection('Users')
            .doc("${userCredential.user.uid}")
            .set({
          "userId": userCredential.user.uid.toString(),
          "answer1": "",
          "answer2": "",
          "answer3": "",
          "answer4": "",
          "answer5": "",
          "answer6": "",
          "answer7": "",
          "answer8": "",
          "answer9": "",
          "answer10": "",
          "answer11": "",
          "answer12": "",
          "answer13": "",
          "answer14": "",
          "answer15": "",
          "answer16": "",
          "answer17": "",
          "answer18": "",
          "answer19": "",
          "answer20": "",
          "isDone": "false",
          "email": "${userCredential.user.email}"
        });
        userId = userCredential.user.uid;
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DashBoardScreen(),
        ));
      },
      onRecoverPassword: (_) async {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      },
      theme: LoginTheme(
        primaryColor: Colors.teal,
        accentColor: Colors.yellow,
        errorColor: Colors.deepOrange,
        titleStyle: TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'Quicksand',
          letterSpacing: 4,
        ),
        bodyStyle: TextStyle(
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        textFieldStyle: TextStyle(
          color: Colors.orange,
          shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
        ),
        buttonStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.yellow,
        ),
        cardTheme: CardTheme(
          color: Colors.yellow.shade100,
          elevation: 5,
          margin: EdgeInsets.only(top: 15),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
        ),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.purple.withOpacity(.1),
          contentPadding: EdgeInsets.zero,
          errorStyle: TextStyle(
            backgroundColor: Colors.orange,
            color: Colors.white,
          ),
          labelStyle: TextStyle(fontSize: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
            borderRadius: inputBorder,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
            borderRadius: inputBorder,
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade700, width: 7),
            borderRadius: inputBorder,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade400, width: 8),
            borderRadius: inputBorder,
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 5),
            borderRadius: inputBorder,
          ),
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.purple,
          backgroundColor: Colors.pinkAccent,
          highlightColor: Colors.lightGreen,
          elevation: 9.0,
          highlightElevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
