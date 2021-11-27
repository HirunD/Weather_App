import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:profile/calander.dart';
import 'package:profile/log_in.dart';
import 'package:profile/sign_up.dart';
import 'package:profile/splash_screen.dart';
import 'package:profile/Todoli.dart';
import 'package:profile/weather_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}
