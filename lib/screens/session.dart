
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:spotter/enums/equipment.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/screens/exercises.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';
import 'package:spotter/widgets/workout_details.dart';
import 'package:uuid/uuid.dart';

class WorkoutSession extends StatefulWidget {

  const WorkoutSession(this.parts, this.title, this.svc, this.selectedExercises);

  final List<dynamic> selectedExercises;
  final SessionSvc svc;
  final String title;
  final List<Part> parts;

  @override
  State<WorkoutSession> createState() => _WorkoutSessionState();
}

class _WorkoutSessionState extends State<WorkoutSession> {
  Equipment selectedEquipment = Equipment.none;

  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {

    final PageController controller = PageController(initialPage: 0);
    var allExercises = [];

    widget.parts.forEach((p) {
      var exs = widget.svc.getAllExercisesByPart(p.name);
      allExercises.addAll(exs);
    });


    // if(widget.svc.getSessionBar().timerSubscription.isPaused) {
    //   widget.svc.getSessionBar().timerSubscription.resume();
    // }

    return
      Scaffold(
        appBar: TopBar(
          onTitleTapped: (){

          },
          title: widget.title,
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Exercises(parts: widget.parts, svc: widget.svc)
              ));

           // widget.svc.getSessionBar().pauseSessionTimer();
            },
          child: const Icon(Icons.arrow_back),
          svc: widget.svc,
        ),
    body:
    PageView.builder(
      controller: controller,
      onPageChanged: getCurrentPage,
       itemCount: widget.selectedExercises.length,
      itemBuilder: (context, position) {
        currentIndex = position;
        return createPage(position, widget.selectedExercises);
      },
    ),

   //bottomSheet: widget.svc.getSessionBar()
        // This trailing comma makes auto-formatting nicer for build methods.
      );
  }

  void getCurrentPage(int value) {
  }

  createPage(position, List<dynamic> exercises) {
    var exercise = exercises[position];
    var part =  widget.parts.firstWhereOrNull((element) => element.name
        .toLowerCase() == exercise.part);
    var equipment = exercise.equipment;
    var id = const Uuid().v1().toString();
    var history = exercise.history ?? {};

    var sessionExercise = SessionExercise(
        id.toString(),
        exercise.name,
        0,
        0,
        '0',
        '0',
        DateTime.now(),
        0,
        true,
        equipment,
        part ?? Part.none,
        0,
        0,
        0,
        0,
        history,'');

    // pass in the last exercise similar to this new one
    // changes will then be made to it to save the next
    return WorkoutDetailsStatefulWidget(exercise.name, widget.svc, sessionExercise);
  }
}