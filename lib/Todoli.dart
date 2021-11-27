// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:profile/todolist.dart';

class TodoList extends StatefulWidget {
  final TODOitem todoitem;
  const TodoList({Key? key, required this.todoitem}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

String finalText = "";
String dateText = "";
bool isPassword = false;
List<TODOitem> todoList = [];
List<String> tododate = [];
final _controller = TextEditingController();
final _controller2 = TextEditingController();
bool _visibility = true; //new reminder widget visibility

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const Text(
        //   "Edit",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     fontSize: 30,
        //   ),
        // ),
        // leadingWidth: 100,
        title: Text(widget.todoitem.titel),
      ),
      body: TextField(
        keyboardType: TextInputType.name,
        autocorrect: true,
        keyboardAppearance: Brightness.dark,
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          hintText: 'Edit the Reminder',
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
    );
  }
}
