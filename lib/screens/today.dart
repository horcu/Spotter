import 'package:flutter/material.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/screens/workout.dart';
import 'package:spotter/services/session_svc.dart';

import 'categories.dart';

class TodaysWorkout extends StatefulWidget {
  Part part;
  SessionSvc svc;

   TodaysWorkout({required this.part, required this.svc});

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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.part.name),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ //
            const Align(
              alignment: Alignment.bottomLeft,
              child:  Text("Select from list below"),
            ),// use a list instead
            const Align(
              alignment: Alignment.bottomLeft,
              child:  Text("Pec Fly"),
            ),
        const Align(
          alignment: Alignment.bottomLeft,
          child:  Text("Dumbell press")),

        const Align(
          alignment: Alignment.bottomLeft,
          child:  Text("Barbell press")),

        const Align(
          alignment: Alignment.bottomLeft,
          child:  Text("Pushups")),

        const Align(
          alignment: Alignment.bottomLeft,
          child:   Text("Dips")),

        const Align(
          alignment: Alignment.bottomLeft,
          child:   Text("Military Press")),

            Column(
              children: [
                Row(
                  children: [

                  ],
                ),

                Row(
                  children: [
                    Spacer(
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
                    Spacer(
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
                          (widget.part.name, widget.svc)),
                      );
                    }, child: const Text(
                      "Get Started",
                      style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 22
                      ),
                    ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Spacer(
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

