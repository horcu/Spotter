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
import 'package:spotter/widgets/topbar.dart';
import 'enums/part.dart';
import 'models/exercise.dart';
import 'models/history.dart';
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
  Hive.registerAdapter(HistoryAdapter());

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
      child: MaterialApp(

          theme: ThemeData(
              appBarTheme: const AppBarTheme(
                color: Colors.white,
              )),
          home: MyHomePage(title: 'NO DAYS OFF !!', db:
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
       appBar: TopBar(
         onTitleTapped: (){},
         title: widget.title,
         onPressed: (){},
         child: const Icon(Icons.home),
       ),
      // AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(

                backgroundColor: MaterialStateProperty.all<Color>(Colors
                    .white),
              ), onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodaysWorkout(parts:
                parts, svc: _sSvc)),
              );
            }, child: const Text(
              "CHECK IN",
              style:  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 28
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
