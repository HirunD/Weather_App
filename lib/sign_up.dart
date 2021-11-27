import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:profile/log_in.dart';
import 'package:profile/weather_app.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth.instance.authStateChanges().listen((User? user) {});
      setState(() {});
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {});
    }
  }

  String email = "";
  String password = "";

  registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // addUser("name", "company", "age", userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: const Login()));
        print('User is currently signed out!');
      } else {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.scale,
                alignment: Alignment.bottomCenter,
                child: WeatherApp()));
        print('User is signed in!');
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign UP"),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          TextField(
            autocorrect: true,
            keyboardType: TextInputType.name,
            keyboardAppearance: Brightness.dark,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            // onChanged: (Text) {
            //   // print(Text);
            // },
            onChanged: (Text) {
              setState(() {
                email = Text;
              });
              print(email);
            },
          ),
          TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.name,
            keyboardAppearance: Brightness.dark,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            // onChanged: (Text) {
            //   // print(Text);
            // },
            onChanged: (Text) {
              setState(() {
                password = Text;
              });
              print(email);
            },
          ),
          TextButton(onPressed: registerUser, child: Text("Save"))
        ],
      ),
    );
  }
}
