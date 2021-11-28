import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:profile/model/weather_model.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
// import 'package:weather_app/views/add_user.dart';

class WeatherApp extends StatefulWidget {
  WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  Tween<double> _tween = Tween(begin: 0.75, end: 2);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  CollectionReference? users; // Add This
  FirebaseAuth? auth;
  Weather? weather;
  Position? position;
  bool _initialized = false;
  bool _error = false;

  String location_1 = "";
  String Location_2 = "";
  String Location_3 = "";
  String Location_4 = "";
  String Location_5 = "";

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      users = FirebaseFirestore.instance.collection('users'); //Add This
      auth = FirebaseAuth.instance;
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          print('User is signed in!');
        }
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  Future getWeatherData() async {
    try {
      var response = await Dio().get(
          'https://api.openweathermap.org/data/2.5/onecall',
          queryParameters: {
            "lat": position?.latitude,
            "lon": position?.longitude,
            "appid": "767033a203c2a38ef86c24a3abcf1788",
            "units": "metric",
          });
      print(response);
      setState(() {
        weather = Weather.fromJson(response.data);
      });
    } catch (e) {
      print(e);
    }
  }

  getUserLocation() async {
    position = await _determinePosition();
    getWeatherData();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // CollectionReference users = FirebaseFirestore.instance.collection('users'); //Remove this

  Future<void> addLocation(String uid) {
    // Call the user's CollectionReference to add a new user
    return users!
        .doc(uid)
        .set({
          "locations": {
            "location_1": location_1,
            "location_2": Location_2,
            "location_3": "Location",
            "location_4": "Location",
            "location_5": "Location",
            "location_6": "Location",
            "location_7": "Location",
          }
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    var tempinput = weather?.current.temp;
    var temp = double.parse(tempinput?.toStringAsFixed(1) ?? "0");
    var icon = weather?.current.weather.first.icon ?? "01d";
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                icon: Icon(Icons.beach_access_sharp),
              ),
              Tab(
                icon: Icon(Icons.brightness_5_sharp),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SafeArea(
              child: RefreshIndicator(
                onRefresh: getWeatherData,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/img/wallpaper.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // ignore: unnecessary_string_escapes
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        weather?.timezone ?? "",
                        style: TextStyle(
                          height: 3,
                          fontWeight: FontWeight.w900,
                          fontSize: 35,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "$temp C",
                        style: const TextStyle(
                          height: -1,
                          fontWeight: FontWeight.w900,
                          fontSize: 70,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Humidity ${weather?.current.humidity.toString()}%",
                        style: const TextStyle(
                          height: 20,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: IconButton(
                          onPressed: () {
                            addLocation(FirebaseAuth.instance.currentUser!.uid);
                          },
                          color: Colors.black,
                          icon: Icon(Icons.add_location)),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 9, left: 9),
                      // width: 300,
                      alignment: Alignment.center,
                      child: TextField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Location_1',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onSubmitted: (Text) {
                          setState(() {
                            location_1 = Text;
                          });
                          print(location_1);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 90),
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            addLocation(FirebaseAuth.instance.currentUser!.uid);
                          },
                          icon: Icon(Icons.add)),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: RefreshIndicator(
                onRefresh: getWeatherData,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/img/wallpaper.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // ignore: unnecessary_string_escapes
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        weather?.timezone ?? "",
                        style: TextStyle(
                          height: 3,
                          fontWeight: FontWeight.w900,
                          fontSize: 35,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "$temp C",
                        style: const TextStyle(
                          height: -1,
                          fontWeight: FontWeight.w900,
                          fontSize: 70,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Humidity ${weather?.current.humidity.toString()}%",
                        style: const TextStyle(
                          height: 20,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: IconButton(
                          onPressed: () {
                            addLocation(FirebaseAuth.instance.currentUser!.uid);
                          },
                          color: Colors.black,
                          icon: Icon(Icons.add_location)),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 9, left: 9),
                      // width: 300,
                      alignment: Alignment.center,
                      child: TextField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Location_1',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onSubmitted: (Text) {
                          setState(() {
                            location_1 = Text;
                          });
                          print(location_1);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 90),
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            addLocation(FirebaseAuth.instance.currentUser!.uid);
                          },
                          icon: Icon(Icons.add)),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: RefreshIndicator(
                onRefresh: getWeatherData,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/img/wallpaper.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // ignore: unnecessary_string_escapes
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        weather?.timezone ?? "",
                        style: TextStyle(
                          height: 3,
                          fontWeight: FontWeight.w900,
                          fontSize: 35,
                          color: Colors.grey.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "$temp C",
                        style: const TextStyle(
                          height: -1,
                          fontWeight: FontWeight.w900,
                          fontSize: 70,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Humidity ${weather?.current.humidity.toString()}%",
                        style: const TextStyle(
                          height: 20,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      child: IconButton(
                          onPressed: () {
                            addLocation(FirebaseAuth.instance.currentUser!.uid);
                          },
                          color: Colors.black,
                          icon: Icon(Icons.add_location)),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 9, left: 9),
                      // width: 300,
                      alignment: Alignment.center,
                      child: TextField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Location_1',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onSubmitted: (Text) {
                          setState(() {
                            location_1 = Text;
                          });
                          print(location_1);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 90),
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            addLocation(FirebaseAuth.instance.currentUser!.uid);
                          },
                          icon: Icon(Icons.add)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
