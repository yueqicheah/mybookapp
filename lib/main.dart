import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mybookapp/adminpanel.dart';
import 'package:mybookapp/dashboard.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      home: LoginScreen(),
      duration: 3000,
      imageSize: 150,
      imageSrc: "images/books.png",
      text: "WELCOME MY BOOKS APP",
      textType: TextType.TyperAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      backgroundColor: Colors.green,
    );
  }
}

// class LandingPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.active) {
//           User user = snapshot.data;
//           if (user == null) {
//             return LoginScreen();
//           }
//           if (user.email == 'brenden@gmail.com') {
//             return AdminPanel();
//           }
//           return DashBoardScreen(uid: user.uid);
//         } else {
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
