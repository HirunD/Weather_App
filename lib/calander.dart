import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';

class calenderPage extends StatefulWidget {
  calenderPage({Key? key}) : super(key: key);

  @override
  _calenderPageState createState() => _calenderPageState();
}

String finalText = "";
bool isPassword = false;
List<String> todoList = [];
final _controller = TextEditingController();
bool _visibility = false; //new reminder widget visibility

class _calenderPageState extends State<calenderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: const Text(
          "Calander",
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
      ),
      body: SafeArea(
          child: Stack(children: [
        Positioned(
          top: 5,
          left: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            width: 350,
            height: 350,
            child: TableCalendar(
              firstDay: DateTime(2000, 12, 31),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                  rangeHighlightColor: Colors.blue,
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  todayTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Colors.white)),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.white),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: (date, events) {
                print(date.toUtc());
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ),
        ),
        SlidingUpPanel(
          backdropColor: Colors.black,
          backdropEnabled: true,
          isDraggable: true,
          backdropOpacity: 0.5,
          parallaxEnabled: true,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0)),
          parallaxOffset: 10,
          minHeight: 210,
          panel: Center(
              child: Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(08),
              ),
              child: ClipRRect(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(
                      endIndent: 100,
                      indent: 100,
                      thickness: 3,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    const Positioned(
                      width: double.infinity,
                      height: double.infinity,
                      right: 3,
                      child: Text(
                        "Hello User",
                        style: TextStyle(
                          fontSize: 30,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
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
                            onSubmitted: (Text) {
                              setState(() {
                                todoList.add(finalText);
                              });
                            },
                            onChanged: (Text) {
                              print(Text);
                              setState(() {
                                finalText = Text;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 100,
                    //   width: 100,
                    //   child: ListView.builder(
                    //     physics: const BouncingScrollPhysics(),
                    //     shrinkWrap: true,
                    //     itemCount: todoList.length,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return Padding(
                    //           padding: const EdgeInsets.all(10),
                    //           child: SizedBox(
                    //             height: 100,
                    //             width: 100,
                    //             child: SwitchListTile(
                    //                 value: isPassword,
                    //                 onChanged: (val) {
                    //                   setState(() {
                    //                     isPassword = !isPassword;
                    //                   });
                    //                 }),
                    //           ));
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          )),
        )
      ])),
    );
  }
}
