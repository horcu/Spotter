import 'package:flutter/material.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/screens/workout.dart';
import 'package:spotter/services/session_svc.dart';

import 'categories.dart';

class TodaysWorkout extends StatefulWidget {
  List<Part> parts;
  SessionSvc svc;

   TodaysWorkout({required this.parts, required this.svc});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<TodaysWorkout> createState() => _TodaysWorkoutState();
}

class _TodaysWorkoutState extends State<TodaysWorkout> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var title = '';
    widget.parts.forEach((p) {
      title = title + ', ' +  p.name;
    });
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ //
            const Align(
              alignment: Alignment.bottomLeft,
              child:  Text("Select from list below"),
            ),// use a list instead
            Column(
              children: [
                Row(
                  children: [

                  ],
                ),

                Row(
                  children: [
                    const Spacer(
                      flex: 1,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>
                          (Colors.grey),
                      ), onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Categories(title:
                        'Categories',)),
                      );
                    }, child: const Text(
                      "Change Plan ",
                      style:  TextStyle(fontWeight: FontWeight.normal, fontSize: 18
                      ),
                    ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>
                          (Colors.blueGrey),
                      ), onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Workout
                          (widget.parts, title, widget.svc)),
                      );
                    }, child: const Text(
                      "Get Started",
                      style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 22
                      ),
                    ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ],
            )

          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

