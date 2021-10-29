import 'package:flutter/material.dart';
import 'package:spotter/enums/equipment.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/excercise_entry.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/workout_details.dart';
import 'package:uuid/uuid.dart';

class Workout extends StatefulWidget {

  const Workout(this.parts, this.title, this.svc);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final SessionSvc svc;
  final String title;
  final List<Part> parts;

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  Equipment selectedEquipment = Equipment.none;


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final PageController controller = PageController(initialPage: 0);
    var allExercises = [];

    widget.parts.forEach((p) {
      var exs = widget.svc.getAllExercisesByPart(p.name);
      allExercises.addAll(exs);
    });

    return
      Scaffold(
        appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title:
        Row(
          children: [
            Text(widget.title),
            Spacer(flex: 10),
            Text('1: 24 s'),
          ],
        )
    ),
    body:
    PageView.builder(
      controller: controller,
      onPageChanged: getCurrentPage,
       itemCount: allExercises.length,
      itemBuilder: (context, position) {
        return createPage(position, allExercises);
      },
    ),
);
  }

  void getCurrentPage(int value) {
  }

  createPage(position, List<dynamic> exercises) {
    var exercise = exercises[position];
    var part =  widget.parts.firstWhere((element) => element.name.toLowerCase() == exercise.part);
    var equipment = exercise.equipment;
    var id = const Uuid();
    var sessionExercise = SessionExercise(
        id.toString(),
        exercise.name,
        200,
        205,
        '3',
        '4',
        DateTime.now(),
        200,
        true,
        equipment,
        part,
        0);

    // pass in the last exercise similar to this new one
    // changes will then be made to it to save the next
    return WorkoutDetailsStatefulWidget(exercise.name, widget.svc, sessionExercise);
  }
}