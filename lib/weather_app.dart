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
  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    getUserLocation();
    getName();
  }

  Tween<double> _tween = Tween(begin: 0.75, end: 2);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  CollectionReference? users; // Add This
  FirebaseAuth? auth;
  Weather? weather;
  Weather? weather2;
  Weather? weather3;
  Position? position;
  bool _initialized = false;
  bool _error = false;

  String location_1lat = "";
  String location_1lon = "";
  String name1 = "";
  String wallpaper1 = "";

  String location_2lat = "";
  String location_2lon = "";

  String location_3lat = "";
  String location_3lon = "";

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

  Future getWeatherData1() async {
    try {
      var response = await Dio().get(
          'https://api.openweathermap.org/data/2.5/onecall',
          queryParameters: {
            "lat": name[('locations')][("location_1")][("lat")].toString(),
            "lon": name[('locations')][("location_1")][("lon")].toString(),
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

  Future getWeatherData2() async {
    try {
      var response = await Dio().get(
          'https://api.openweathermap.org/data/2.5/onecall',
          queryParameters: {
            "lat": name[('locations')][("location_2")][("lat")].toString(),
            "lon": name[('locations')][("location_2")][("lon")].toString(),
            "appid": "767033a203c2a38ef86c24a3abcf1788",
            "units": "metric",
          });
      print(response);
      setState(() {
        weather2 = Weather.fromJson(response.data);
      });
    } catch (e) {
      print(e);
    }
  }

  Future getWeatherData3() async {
    try {
      var response = await Dio().get(
          'https://api.openweathermap.org/data/2.5/onecall',
          queryParameters: {
            "lat": name[('locations')][("location_3")][("lat")].toString(),
            "lon": name[('locations')][("location_3")][("lon")].toString(),
            "appid": "767033a203c2a38ef86c24a3abcf1788",
            "units": "metric",
          });
      print(response);
      setState(() {
        weather3 = Weather.fromJson(response.data);
      });
    } catch (e) {
      print(e);
    }
  }

  getUserLocation() async {
    position = await _determinePosition();
    getWeatherData1();
    getWeatherData2();
    getWeatherData3();
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
            "location_1": {
              "lat": location_1lat,
              "lon": location_1lon,
              "name": name1,
              "wallpaper": wallpaper1
            },
            "location_2": {"lat": location_1lat, "lon": location_1lon},
            "location_3": {"lat": location_3lat, "lon": location_3lon},
          }
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  late var name;
  Future<void> getName() async {
    DocumentSnapshot ds =
        await users!.doc(FirebaseAuth.instance.currentUser!.uid).get();
    name = ds.data();
    print(name);
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
          title: TabBar(
            tabs: <Widget>[
              Tab(
                child: Image.network(
                    'http://openweathermap.org/img/wn/${weather?.current.weather.first.icon ?? "09d"}@2x.png'),
              ),
              Tab(
                child: Image.network(
                    'http://openweathermap.org/img/wn/${weather2?.current.weather.first.icon ?? "10d"}@2x.png'),
              ),
              Tab(
                child: Image.network(
                    'http://openweathermap.org/img/wn/${weather3?.current.weather.first.icon ?? "10d"}@2x.png'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SafeArea(
              child: RefreshIndicator(
                onRefresh: getWeatherData1,
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
                      // child: Text(
                      //   name[('locations')][("location_1")][("name")]
                      //       .toString(),
                      //   style: TextStyle(
                      //     height: 3,
                      //     fontWeight: FontWeight.w900,
                      //     fontSize: 35,
                      //     color: Colors.grey.shade900,
                      //   ),
                      //   textAlign: TextAlign.center,
                      // ),
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
                      child: TextFormField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        initialValue: position?.latitude.toString() ?? "Lat",
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Latitude',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onChanged: (Text) {
                          setState(() {
                            location_1lat = Text;
                          });
                          print(location_1lat);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 9, left: 9),
                      // width: 300,
                      height: 350,
                      alignment: Alignment.bottomCenter,
                      child: TextFormField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        initialValue: position?.longitude.toString() ?? "Lat",
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Longitude',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onChanged: (Text) {
                          setState(() {
                            location_3lon = Text;
                          });
                          print(location_1lon);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 9, left: 9),
                      // width: 300,
                      height: 400,
                      alignment: Alignment.bottomCenter,
                      child: TextFormField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onChanged: (Text) {
                          setState(() {
                            name1 = Text;
                          });
                          print(name1);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 9, left: 9),
                      // width: 300,
                      height: 450,
                      alignment: Alignment.bottomCenter,
                      child: TextFormField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        initialValue: position?.latitude.toString() ?? "Lat",
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Latitude',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onChanged: (Text) {
                          setState(() {
                            location_1lat = Text;
                          });
                          print(location_1lat);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 390),
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            getName();
                            addLocation(FirebaseAuth.instance.currentUser!.uid);
                          },
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 390),
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            initializeFlutterFire();
                            getName();
                            getWeatherData1();
                            getWeatherData2();
                            getWeatherData3();
                          },
                          child: const Text(
                            "Refresh",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: RefreshIndicator(
                onRefresh: getWeatherData2,
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
                        weather2?.timezone ?? "...",
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
                        "${weather2?.current.temp} C",
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
                        "Humidity ${weather2?.current.humidity.toString()}%",
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
                      child: TextFormField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        initialValue: position?.latitude.toString() ?? "Lat",
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Latitude',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onChanged: (Text) {
                          setState(() {
                            location_1lat = Text;
                          });
                          print(location_1lat);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 9, left: 9),
                      // width: 300,
                      height: 350,
                      alignment: Alignment.bottomCenter,
                      child: TextFormField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        initialValue: position?.longitude.toString() ?? "Lat",
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Longitude',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onChanged: (Text) {
                          setState(() {
                            location_3lon = Text;
                          });
                          print(location_1lon);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 9, left: 9),
                      // width: 300,
                      height: 400,
                      alignment: Alignment.bottomCenter,
                      child: TextFormField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onChanged: (Text) {
                          setState(() {
                            name1 = Text;
                          });
                          print(name1);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 9, left: 9),
                      // width: 300,
                      height: 450,
                      alignment: Alignment.bottomCenter,
                      child: TextFormField(
                        // obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        initialValue: position?.latitude.toString() ?? "Lat",
                        keyboardType: TextInputType.name,
                        keyboardAppearance: Brightness.dark,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Latitude',
                        ),
                        // onChanged: (Text) {
                        //   // print(Text);
                        // },
                        onChanged: (Text) {
                          setState(() {
                            location_1lat = Text;
                          });
                          print(location_1lat);
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 390),
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            getName();
                            addLocation(FirebaseAuth.instance.currentUser!.uid);
                          },
                          child: const Text(
                            "Save Changes",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 390),
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            initializeFlutterFire();
                            getName();
                            getWeatherData1();
                            getWeatherData2();
                            getWeatherData3();
                          },
                          child: const Text(
                            "Refresh",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                  ],
                ),
              ),
            ),
            SafeArea(
              child: RefreshIndicator(
                backgroundColor: Colors.white,
                color: Colors.black,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                onRefresh: getWeatherData3,
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
                    Container(
                      child: IconButton(
                          onPressed: () {
                            addLocation(FirebaseAuth.instance.currentUser!.uid);
                          },
                          color: Colors.black,
                          icon: Icon(Icons.add_location)),
                    ),
                    ListView(
                      children: [
                        // ignore: unnecessary_string_escapes
                        Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            weather3?.timezone ?? "...",
                            style: TextStyle(
                              height: 2,
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
                              // height: -1,
                              fontWeight: FontWeight.w900,
                              fontSize: 70,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 9, left: 9),
                          // width: 300,
                          alignment: Alignment.center,
                          child: TextFormField(
                            // obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            initialValue:
                                position?.latitude.toString() ?? "Lat",
                            keyboardType: TextInputType.name,
                            keyboardAppearance: Brightness.dark,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: 'Latitude',
                            ),
                            onChanged: (Text) {
                              setState(() {
                                location_1lat = Text;
                              });
                              print(location_1lat);
                            },
                            onSaved: (Text) {
                              setState(() {
                                location_1lat = Text.toString();
                              });
                              print(location_1lat);
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 9, left: 9),
                          // width: 300,
                          // height: 350,
                          alignment: Alignment.bottomCenter,
                          child: TextFormField(
                            // obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            initialValue:
                                position?.longitude.toString() ?? "Lat",
                            keyboardType: TextInputType.name,
                            keyboardAppearance: Brightness.dark,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: 'Longitude',
                            ),
                            onChanged: (Text) {
                              setState(() {
                                location_1lon = Text;
                              });
                              print(location_1lon);
                            },
                            onSaved: (Text) {
                              setState(() {
                                location_1lon = Text.toString();
                              });
                              print(location_1lat);
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 9, left: 9),
                          // width: 300,
                          // height: 400,
                          alignment: Alignment.bottomCenter,
                          child: TextFormField(
                            // obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.name,
                            keyboardAppearance: Brightness.dark,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                            // onChanged: (Text) {
                            //   // print(Text);
                            // },
                            onChanged: (Text) {
                              setState(() {
                                name1 = Text;
                              });
                              print(name1);
                            },
                            onSaved: (Text) {
                              setState(() {
                                name1 = Text.toString();
                              });
                              print(location_1lat);
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 9, left: 9),
                          // width: 300,
                          // height: 450,
                          alignment: Alignment.bottomCenter,
                          child: TextFormField(
                            // obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            initialValue:
                                position?.latitude.toString() ?? "Lat",
                            keyboardType: TextInputType.name,
                            keyboardAppearance: Brightness.dark,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: 'Wallpaper',
                            ),
                            // onChanged: (Text) {
                            //   // print(Text);
                            // },
                            onChanged: (Text) {
                              setState(() {
                                wallpaper1 = Text;
                              });
                              print(location_1lat);
                            },
                            onSaved: (Text) {
                              setState(() {
                                wallpaper1 = Text.toString();
                              });
                              print(location_1lat);
                            },
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.only(top: 390),
                          alignment: Alignment.center,
                          child: TextButton(
                              onPressed: () {
                                getName();
                                addLocation(
                                    FirebaseAuth.instance.currentUser!.uid);
                              },
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        Container(
                          // padding: EdgeInsets.only(bottom: 390),
                          alignment: Alignment.center,
                          child: TextButton(
                              onPressed: () {
                                initializeFlutterFire();
                                getName();
                                getWeatherData1();
                                getWeatherData2();
                                getWeatherData3();
                              },
                              child: const Text(
                                "Refresh",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Humidity ${weather?.current.humidity.toString()}%",
                            style: const TextStyle(
                              // height: 20,
                              fontWeight: FontWeight.w900,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
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
