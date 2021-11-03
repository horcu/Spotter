import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/enums/equipment.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/screens/history_timeline.dart';
import 'package:spotter/screens/parts.dart';
import 'package:spotter/screens/exercises.dart';
import 'package:spotter/screens/schedule.dart';
import 'package:spotter/services/exercise_loader_svc.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';
import 'enums/part.dart';
import 'models/exercise.dart';
import 'models/history.dart';
import 'screens/session.dart';
import 'models/recommendation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/session.dart';

Future<void> main() async {
  await Hive.initFlutter();
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionSvc(database)),
        ChangeNotifierProvider(create: (_) => ExerciseLoader(database))
      ],
      child: MaterialApp(
          theme: ThemeData(
              appBarTheme: const AppBarTheme(
            color: Colors.green,
          )),
          home: MyHomePage(title: 'NO DAYS OFF !!', db: database)),
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
          onTitleTapped: () {},
          title: 'Spotter',
          onPressed: () {},
          child: const Icon(Icons.home),
          svc: _sSvc,
        ),
        // AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   title: Text(widget.title),
        // ),
        body: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(5, (index) {
              return Center(
                  child: getGridItem(index, parts, _sSvc));
            })));
  }

  List<Part> parseSelectedParts(List<dynamic> selectedParts) {
    return selectedParts.cast<Part>();
  }

  getGridItem(int index, parts, _sSvc) {
    switch (index) {
      case 0:
        return SizedBox.expand( child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HistoryTimeline(svc: _sSvc)),
            );
          },
          child: const Text(
            "History",
            style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
        ));
      case 1:
        return SizedBox.expand( child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Parts(_sSvc, 'Parts')),
            );
          },
          child: const Text(
            "Parts",
            style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
        ));
      case 2:
        return SizedBox.expand( child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Exercises(parts: parts, svc: _sSvc)),
            );
          },
          child: const Text(
            "Exercises",
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
        ));
      case 3:
        return SizedBox.expand( child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Schedule(title: 'Schedule', svc: _sSvc)),
            );
          },
          child: const Text(
            "Schedule",
            style: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
        ));
      case 4:
        return _sSvc.activeSessionExists()
            ? SizedBox.expand( child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkoutSession(
                            parseSelectedParts(_sSvc.getSelectedParts()),
                            'Schedule',
                            _sSvc,
                            _sSvc.getSelectedExercises())),
                  );
                },
                child:
                const Text(
                  "Session",
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ))
            : const SizedBox.expand( child:Text(''));
    }
  }
}
