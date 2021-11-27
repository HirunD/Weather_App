import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:profile/log_in.dart';
import 'package:profile/weather_app.dart';

import 'calander.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
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
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    "Welcome",
                    textStyle: const TextStyle(
                      fontSize: 70,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 200),
                  )
                ],
                stopPauseOnTap: false,
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue,
                  ),
                  width: 300,
                  height: 50,
                  padding: EdgeInsets.all(8),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'See the Calender',
                        textStyle: const TextStyle(
                          fontSize: 32.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 200),
                      ),
                      TypewriterAnimatedText(
                        'Make a Todo list',
                        textStyle: const TextStyle(
                          fontSize: 32.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 200),
                      ),
                      TypewriterAnimatedText(
                        'Work in Progress',
                        textStyle: const TextStyle(
                          fontSize: 32.0,
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                    repeatForever: true,
                    isRepeatingAnimation: true,
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.scale,
                                alignment: Alignment.bottomCenter,
                                child: MyHomePage(
                                  title: '',
                                )));
                      },
                      child: const Text("To Do list")),
                  TextButton(
                      autofocus: true,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext contect) =>
                                    calenderPage()));
                      },
                      child: const Text("Calender")),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Work in progress",
                        style: TextStyle(color: Colors.yellow),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
