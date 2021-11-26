import 'dart:async';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:spotter/enums/equipmentenum.dart';
import 'package:spotter/enums/partenum.dart';
import 'package:spotter/models/equipment.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/models/part.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/screens/exercises.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';
import 'package:spotter/widgets/workout_details.dart';
import 'package:uuid/uuid.dart';

class WorkoutSession extends StatefulWidget {
  var sessionExercise;

   WorkoutSession(
      this.parts, this.title, this.svc, this.selectedExercises);

  final List<dynamic> selectedExercises;
  final SessionSvc svc;
  final String title;
  final List<Part> parts;

  @override
  State<WorkoutSession> createState() => _WorkoutSessionState();
}

class _WorkoutSessionState extends State<WorkoutSession> {
  EquipmentEnum selectedEquipment = EquipmentEnum.none;

  int currentIndex = 0;

  var isTimerPaused = false;
  int exerciseDuration = 0;


  var isDialOpen = ValueNotifier<bool>(false);
  var customDialRoot = false;
  var speedDialDirection = SpeedDialDirection.up;
  var buttonSize = 56.0;
  var childrenButtonSize = 56.0;
  var extend = false;
  var visible = true;
  var rmicons = false;

  @override
  Widget build(BuildContext context) {

    final PageController controller = PageController(initialPage: 0);
    var allExercises = [];

    widget.parts.forEach((p) {
      var exs = widget.svc.getAllExercisesByPart(p.name);
      allExercises.addAll(exs);
    });

    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: TopBar(
          onTitleTapped: () {},
          title: widget.title,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Exercises(parts: widget.parts, svc: widget.svc)));
          },
          child: const Icon(Icons.arrow_back),
          svc: widget.svc,
        ),
        body: PageView.builder(
          controller: controller,
          onPageChanged: getCurrentPage,
          itemCount: widget.selectedExercises.length,
          itemBuilder: (context, position) {
            currentIndex = position;
            return createPage(position, widget.selectedExercises);
          },
        ),
       // floatingActionButton:
//         SpeedDial(
//       backgroundColor: Colors.white,
//       foregroundColor: Colors.blueGrey,
//       animatedIcon: AnimatedIcons.menu_close,
//       animatedIconTheme: IconThemeData(size: 22.0),
//       // / This is ignored if animatedIcon is non null
//       // child: Text("open"),
//       // activeChild: Text("close"),
//       icon: Icons.save,
//       activeIcon: Icons.close,
//       spacing: 3,
//       openCloseDial: isDialOpen,
//       childPadding: const EdgeInsets.all(5),
//       spaceBetweenChildren: 4,
//       dialRoot: customDialRoot
//           ? (ctx, open, toggleChildren) {
//         return ElevatedButton(
//           onPressed: toggleChildren,
//           style: ElevatedButton.styleFrom(
//             primary: Colors.green,
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 22, vertical: 18),
//           ),
//           child: const Text(
//             "Custom Dial Root",
//             style: TextStyle(fontSize: 17),
//           ),
//         );
//       }
//           : null,
//       buttonSize: 56, // it's the SpeedDial size which defaults to 56 itself
//       // iconTheme: IconThemeData(size: 22),
//       label: extend
//           ? const Text("Open")
//           : null, // The label of the main button.
//       /// The active label of the main button, Defaults to label if not specified.
//       activeLabel: extend ? const Text("Close") : null,
//
//       /// Transition Builder between label and activeLabel, defaults to FadeTransition.
//       // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
//       /// The below button size defaults to 56 itself, its the SpeedDial childrens size
//       childrenButtonSize: childrenButtonSize,
//       visible: visible,
//       direction: speedDialDirection,
//       switchLabelPosition: false,
//
//       /// If true user is forced to close dial manually
//       closeManually: false,
//
//       /// If false, backgroundOverlay will not be rendered.
//       renderOverlay: false,
//       // overlayColor: Colors.black,
//       // overlayOpacity: 0.5,
//       onOpen: () => debugPrint('OPENING DIAL'),
//       onClose: () => debugPrint('DIAL CLOSED'),
//       useRotationAnimation: true,
//       tooltip: 'Open Speed Dial',
//       heroTag: 'speed-dial-hero-tag',
//       // foregroundColor: Colors.black,
//       // backgroundColor: Colors.white,
//       // activeForegroundColor: Colors.red,
//       // activeBackgroundColor: Colors.blue,
//       elevation: 8.0,
//       isOpenOnStart: false,
//       animationSpeed: 200,
//       shape: customDialRoot
//           ? const RoundedRectangleBorder()
//           : const StadiumBorder(),
//       // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       children: [
//         SpeedDialChild(
//           child: !rmicons ? const Icon(Icons.book_rounded) : null,
//           backgroundColor: Colors.green,
//           foregroundColor: Colors.white,
//           label: 'Log Exercise',
//           onTap: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                     backgroundColor: Colors.green,
//                     content: Text(("Exercise logged"))));
// \
//             var id = const Uuid().v1().toString();
//             var newEntry = widget.sessionExercise;
//             newEntry.id = id;
//             newEntry.duration = exerciseDuration;
//
//             newEntry.weight = newEntry.weight == 0 ? newEntry.lastWeight
//                 : newEntry.weight;
//
//             newEntry.duration = newEntry.duration == 0 ? newEntry
//                 .lastDuration
//                 : widget.svc.start;
//
//             newEntry.distance = newEntry.distance == 0.0 ? newEntry
//                 .lastDistance
//                 : newEntry.distance;
//
//             newEntry.rep = newEntry.rep == '0' ? newEntry
//                 .lastRep
//                 : newEntry.rep;
//
//             newEntry.equipmentUsed = newEntry.equipment[selectedEquipmentIndex].name;
//
//             widget.svc.loggedExercises.add(newEntry);
//
//           },
//         ),
//         SpeedDialChild(
//           child: widget.svc.timerHasNotStarted ? const Icon(Icons
//               .play_arrow_rounded): isTimerPaused ? const Icon(Icons
//               .play_arrow_rounded) :  const Icon(Icons
//               .pause_circle_rounded) ,
//           backgroundColor: Colors.deepOrange,
//           foregroundColor: Colors.white,
//           label: widget.svc.timerHasNotStarted  ? 'Start Session' :
//           isTimerPaused ?
//           'Resume Session' : 'Pause '
//               'Session',
//           onTap: ()  {
//             ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar( backgroundColor: Colors.green, content: Text
//                   (widget.svc.timerHasNotStarted ?
//                 'Starting session ...' :
//                 isTimerPaused
//                     ? "Starting session ..."
//                     : "Pausing session ...")));
//
//             if(widget.svc.timerHasNotStarted) {
//               widget.svc.startTimer(0);
//             } else if (!widget.svc.timerHasNotStarted) {
//               if(isTimerPaused){
//                 widget.svc.unpauseTimer();
//                 setState(() {
//                   isTimerPaused = false;
//                 });
//
//               } else {
//                 widget.svc.pauseTimer();
//                 setState(() {
//                   isTimerPaused = true;
//                 });
//
//               }
//             }
//           },
//         ),
//         SpeedDialChild(
//           child: !rmicons ? const Icon(Icons.stop) : null,
//           backgroundColor: Colors.red,
//           foregroundColor: Colors.white,
//           label: 'Checkout',
//           visible: true,
//           onTap: () {
//
//             ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                     backgroundColor: Colors.green,
//                     content: Text(("Checking out ... "))));
//
//             // save all logged exercises to db
//             widget.svc.save();
//             widget.svc.checkOut();
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         Checkout(title: 'All Done', duration:
//                         widget.svc.start.toString(), svc:
//                         widget.svc,)
//                 ));
//           },
//           //onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
//         ),
//       ],
//     ),

        bottomSheet:
        Container(

          color: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              getElapsedTime(),
              style: const TextStyle(
                  color: Colors.white,
                  backgroundColor: Colors.blueGrey,
                  fontSize: 14,
                  fontFamily: 'Helvetica',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  void getCurrentPage(int value) {}

  createPage(position, List<dynamic> exercises) {
    var exercise = exercises[position];
    Part p = widget.parts
        .firstWhere((element) => element.name.toLowerCase() == exercise.part);

    var equipment = exercise.equipment;
    var equipmentList = <Equipment>[];
    equipment.toList().forEach((e) =>
        equipmentList.add(Equipment(id: e, name: e, icon: '', color: '')));

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
        equipmentList,
        p,
        0,
        0,
        0,
        0,
        history,
        '');

    // pass in the last exercise similar to this new one
    // changes will then be made to it to save the next
    return WorkoutDetailsStatefulWidget(
        exercise.name, widget.svc, sessionExercise);
  }

  String getElapsedTime() {
    var hr = ((widget.svc.start / (60 * 60)) % 60)
        .floor()
        .toString()
        .padLeft(2, '0');
    var min = ((widget.svc.start / 60) % 60).floor().toString().padLeft(2, '0');
    var sec = (widget.svc.start % 60).floor().toString().padLeft(2, '0');

    return "$hr:$min:$sec";
  }
}
