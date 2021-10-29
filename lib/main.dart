import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/enums/equipment.dart';
import 'package:spotter/models/excercise_entry.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/screens/today.dart';
import 'package:hive/hive.dart';
import 'package:spotter/services/exercise_loader_svc.dart';
import 'package:spotter/services/session_svc.dart';
import 'enums/part.dart';
import 'models/exercise.dart';
import 'models/recommendation.dart';
import 'models/session.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExerciseEntryAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(RecommendationAdapter());
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(SessionExerciseAdapter());
  Hive.registerAdapter(EquipmentAdapter());
  Hive.registerAdapter(PartAdapter());

  final Box<dynamic> db = await Hive.openBox('spotter_v1');

  runApp(MyApp(database: db));
}

class MyApp extends StatelessWidget {
  final Box<dynamic> database;

  MyApp({required this.database});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionSvc(database))
      ],
      child: MaterialApp(home: MyHomePage(title: 'NO DAYS OFF !!', db:
      database)),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, required this.db});

  final String title;
  final Box<dynamic> db;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // load exercises if not present
    var exLoader = ExerciseLoader(widget.db);
    exLoader.seedDb();

    // get the session service to use for the new session
    var _sSvc = SessionSvc(widget.db);
     List<Part> parts = _sSvc.getRecommendedWorkoutPartForTheDay();
    // var exercises = _sSvc.getAllExercisesByPart(Part.chest.name);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors
                    .blueGrey),
              ), onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodaysWorkout(parts:
                parts, svc: _sSvc)),
              );
            }, child: const Text(
              "CHECK IN NOW",
              style:  TextStyle(fontWeight: FontWeight.normal, fontSize: 40
              ),
            ),
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
