import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/enums/equipmentenum.dart';
import 'package:spotter/models/equipment.dart';
import 'package:spotter/models/part.dart';
import 'package:spotter/models/schedule.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/presentation/spotter_icons.dart';
import 'package:spotter/screens/history_timeline.dart';
import 'package:spotter/screens/parts.dart';
import 'package:spotter/screens/exercises.dart';
import 'package:spotter/screens/plan.dart';
import 'package:spotter/services/exercise_loader_svc.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';
import 'enums/partenum.dart';
import 'models/exercise.dart';
import 'models/history.dart';
import 'screens/session.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/session.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(SessionAdapter());
  Hive.registerAdapter(SessionExerciseAdapter());
  Hive.registerAdapter(EquipmentEnumAdapter());
  Hive.registerAdapter(PartEnumAdapter());
  Hive.registerAdapter(PartAdapter());
  Hive.registerAdapter(EquipmentAdapter());
  Hive.registerAdapter(HistoryAdapter());

  final Box<dynamic> db = await Hive.openBox('spotter');

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
  late SessionSvc svc;

   MyHomePage({required this.title, required this.db});

  final String title;
  final Box<dynamic> db;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool seedingCompleted = false;

  @override
  Widget build(BuildContext context) {
    // load exercises if not present
    var exLoader = ExerciseLoader(widget.db);

    final seeded = exLoader.seedDb();
    // get the session service to use for the new session
    seeded.then((value) =>  setState((){
      seedingCompleted = true;
    }));

    while(seedingCompleted == false){};

    widget.svc = SessionSvc(widget.db);

    List<Part> parts =  widget.svc.getRecommendedWorkoutPartForTheDay(DateTime.now().weekday);

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: TopBar(
          onTitleTapped: () {},
          title: 'Spotter',
          onPressed: () {},
          child: const Icon(Icons.home),
          svc: widget.svc,
        ),
        body: Column(children: [
          Expanded(
            child: SizedBox(
              child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(4, (index) {
                    return Column(children: [
                      Center(child: getGridItem(index, parts, widget.svc)),
                    ]);
                  })),
            ),
          ),
          // _sSvc.activeSessionExists()
          //     ? SizedBox(
          //         height: 50,
          //         width: 160,
          //         child: ElevatedButton(
          //           style: ButtonStyle(
          //             backgroundColor:
          //                 MaterialStateProperty.all<Color>(Colors.white),
          //           ),
          //           onPressed: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => WorkoutSession(
          //                       parseSelectedParts(_sSvc.getSelectedParts()),
          //                       'Schedule',
          //                       _sSvc,
          //                       _sSvc.getSelectedExercises())),
          //             );
          //           },
          //           child: const InkWell(
          //               child: Text(
          //             "Session",
          //             style: TextStyle(
          //                 color: Colors.blueGrey,
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 28),
          //           )),
          //         ))
          //     : const SizedBox.expand(child: Text('No active sessions'))
        ]),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        onPressed: startSession,
        tooltip: 'Start Session',
        child:   Icon(widget.svc.activeSessionExists() ? Icons
            .play_arrow_rounded :
        Icons.add_rounded),
    ));
  }

  List<Part> parseSelectedParts(List<dynamic> selectedParts) {
    return selectedParts.cast<Part>();
  }



  getGridItem(int index, parts, _sSvc) {
    switch (index) {
      case 0:
        return SizedBox(
            height: 150,
            width: 130,
            child: RawMaterialButton(
              fillColor: Colors.white12,
              focusColor: Colors.white24,
              elevation: 8,
              shape: const CircleBorder(
                  side: BorderSide(
                      color: Colors.white24,
                      width: 2,
                      style: BorderStyle.solid)),
              padding: EdgeInsets.all(30.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Exercises(svc: _sSvc, parts: _sSvc.parts)),
                );
              },
              child: Column(children: const [
                Text(
                  ('EXERCISES'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 10),
                ),
                Spacer(flex: 1),
                Image(
                    image: AssetImage(
                  'images/exercises.png',
                )),
              ]

                  //   Text(
                  //   "History",
                  //   style: TextStyle(
                  //       color: Colors.white,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 28),
                  // ),
                  //  Spacer(flex: 1,),]),
                  ),
              //   Text(
              //   "History",
              //   style: TextStyle(
              //       color: Colors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 28),
              // ),
              //  Spacer(flex: 1,),]),
            ));

      case 1:
        return SizedBox(
            height: 150,
            width: 130,
            child: RawMaterialButton(
                fillColor: Colors.white12,
                focusColor: Colors.white24,
                elevation: 8,
                shape: const CircleBorder(
                    side: BorderSide(
                        color: Colors.white24,
                        width: 2,
                        style: BorderStyle.solid)),
                padding: EdgeInsets.all(25.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Parts(_sSvc, 'Target Areas')),
                  );
                },
                child: Column(children: const [
                  Text(
                    ('TARGET AREAS'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 10),
                  ),
                  Spacer(flex: 1),
                  Image(
                      image: AssetImage(
                    'images/target.png',
                  )),
                ]
                    //   Text(
                    //   "History",
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 28),
                    // ),
                    //  Spacer(flex: 1,),]),
                    )));
      case 2:
        return SizedBox(
            height: 150,
            width: 130,
            child: RawMaterialButton(
                fillColor: Colors.white12,
                focusColor: Colors.white24,
                elevation: 8,
                shape: const CircleBorder(
                    side: BorderSide(
                        color: Colors.white24,
                        width: 2,
                        style: BorderStyle.solid)),
                padding: EdgeInsets.all(30.0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoryTimeline(svc: _sSvc)),
                  );
                },
                child: Column(children: const [
                  Text(
                    ('HISTORY'),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 10),
                  ),
                  Spacer(flex: 1),
                  Image(
                      image: AssetImage(
                    'images/history.png',
                  )),
                ]

                    //   Text(
                    //   "History",
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 28),
                    // ),
                    //  Spacer(flex: 1,),]),
                    )));
      case 3:
        return SizedBox(
            height: 150,
            width: 130,
            child: RawMaterialButton(
              hoverColor: Colors.grey,
              fillColor: Colors.white12,
              focusColor: Colors.white24,
              elevation: 8,
              shape: const CircleBorder(
                  side: BorderSide(
                      color: Colors.white24,
                      width: 2,
                      style: BorderStyle.solid)),
              padding: const EdgeInsets.all(30.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Plan(svc: _sSvc)),
                );
              },
              child: InkWell(
                  child: Column(children: const [
                Text(
                  ('SCHEDULE'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 10),
                ),
                Spacer(flex: 1),
                Image(
                    image: AssetImage(
                  'images/schedule.png',
                )),
              ])),
            ));
    }
  }

   startSession() {
    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutSession(
                              parseSelectedParts(widget.svc.getSelectedParts()),
                              'Schedule',
                              widget.svc,
                              widget.svc.getSelectedExercises())),
                    );
  }
}
