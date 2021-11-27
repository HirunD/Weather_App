import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:profile/Todoli.dart';
import 'package:profile/todolist.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

@override
class _MyHomePageState extends State<MyHomePage> {
  double opacityLevel = 1.0;

  String finalText = "";
  String dateText = "";
  bool isPassword = false;
  List<TODOitem> todoList = [];
  List<String> tododate = [];
  final _controller = TextEditingController();
  final _controller2 = TextEditingController();
  bool _visibility = true; //new reminder widget visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: const Text(
          "To-Do List",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          // ListView(
          //   shrinkWrap: true, //Add this or remove the ListView.
          //   children: [
          //     Container(
          //       width: 50,
          //       height: 50,
          //     ),
          //   ],
          // ),
          Container(
            //Add This
            width: 20,
            height: 20,
          ),
          Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize
                  .min, //Add this when you are using Column inside a ListView
              children: [
                TextField(
                  keyboardType: TextInputType.name,
                  autocorrect: true,
                  keyboardAppearance: Brightness.dark,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Enter the Reminder',
                  ),
                  controller: _controller,
                  onChanged: (Text) {
                    print(Text);
                    setState(() {
                      finalText = Text;
                    });
                  },
                  onSubmitted: (Text) {
                    _controller.clear();
                    setState(() {
                      todoList.add(TODOitem(finalText, false));
                    });
                  },
                ),
                SizedBox(
                  width: 20,
                  height: 20,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  autocorrect: true,
                  keyboardAppearance: Brightness.dark,
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Add a note',
                  ),
                  controller: _controller2,
                  onChanged: (Text) {
                    print(Text);
                    setState(() {
                      dateText = Text;
                    });
                  },
                  onSubmitted: (Text) {
                    _controller.clear();
                    setState(() {
                      todoList.add(TODOitem(finalText, false));
                    });
                  },
                ),
              ],
            ),
          ),
          ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: todoList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var todoItem = todoList.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Dismissible(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            // BoxShadow(
                            //   color: Colors.grey.withOpacity(0.5),
                            //   spreadRadius: 5,
                            //   blurRadius: 7,
                            //   offset: const Offset(0, 3),
                            // ),
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                todoItem.isDone ? Colors.white : Colors.white,
                                todoItem.isDone
                                    ? Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)]
                                    : Colors.black
                              ])),
                      child: SwitchListTile(
                        title: AnimatedTextKit(
                          repeatForever: false,
                          isRepeatingAnimation: todoItem.isDone ? true : false,
                          animatedTexts: [
                            TyperAnimatedText(
                              todoItem.titel,
                              textStyle: TextStyle(
                                fontSize: 32.0,
                                color: todoItem.isDone
                                    ? Colors.black
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              speed: const Duration(milliseconds: 400),
                            ),
                          ],
                        ),
                        // IconButton(
                        //   alignment: Alignment.bottomRight,
                        //   icon: const Icon(Icons.close),
                        //   onPressed: () {
                        //     setState(() {
                        //       todoList.removeAt(index);
                        //     });
                        //   },
                        value: todoItem.isDone,
                        onChanged: (val) {
                          setState(() {
                            todoItem.isDone = val;
                          });
                          todoItem.isDone
                              ? Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.scale,
                                      alignment: Alignment.bottomCenter,
                                      child: TodoList(
                                        todoitem: todoItem,
                                      )))
                              : print(Text);
                        },
                      ),
                    ),
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        todoItem;
                      });
                    }),
              );
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      // onPressed: () => myFocusNode.requestFocus(),
      // backgroundColor: Colors.black,
      // )
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
