import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:spotter/enums/equipmentenum.dart';
import 'package:spotter/enums/partenum.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/screens/checkout.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

/// This is the stateful widget that the main application instantiates.
class WorkoutDetailsStatefulWidget extends StatefulWidget {
  WorkoutDetailsStatefulWidget(this.title, this.svc, this.sessionExercise);

  SessionSvc svc;
  String title;
  var weightDropdownValue;
  var repDropdownValue;
  SessionExercise sessionExercise;
  EquipmentEnum? equipmentType = EquipmentEnum.none;

  @override
  State<WorkoutDetailsStatefulWidget> createState() => Workoutdetails();
}

class Workoutdetails extends State<WorkoutDetailsStatefulWidget> {
  int selectedEquipmentIndex = 0;
  int selectedPartIndex = 0;

  var _currentDistanceSliderValue = 0.0;
  var _currentDurationSliderValue = 0.0;
  var _currentRepsSliderValue = 0.0;
  var _currentWeightSliderValue = 0.0;

  bool hasNotLoadedDefaults = true;
  var displayTime = 0;
  int _start = 0;

  static Timer? _timer;

  var isTimerPaused = false;
  int exerciseDuration = 0;

  @override
  Widget build(BuildContext context) {

   // return Consumer<Session>(builder: (context, session, child) {

     if(widget.svc.timerHasNotStarted) {
       _start = 0;
     }

     void startTimer(int timerDuration) {

       _timer?.cancel();
      setState(() {
        _start = timerDuration;
      });
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
            (Timer timer) => setState(
              () {
            if (_start < 0) {
              timer.cancel();
            } else {
              if(widget.svc.timerPaused == false) {
                _start = _start + 1;
                exerciseDuration = _start;
              }else {
                //paused//
              }
            }
          },
        ),
      );

    }

    void pauseTimer() {
        _timer?.cancel();

    }

    void unpauseTimer() => startTimer(_start);

    @override
    void dispose() {
      _timer?.cancel();
      super.dispose();
    }

    var isDialOpen = ValueNotifier<bool>(false);
    var customDialRoot = false;
    var speedDialDirection = SpeedDialDirection.up;
    var buttonSize = 56.0;
    var childrenButtonSize = 56.0;
    var extend = false;
    var visible = true;
    var rmicons = false;


    List<String> doubleList = List<String>.generate(25, (int index) => '${index * 5 + 1}');
    List<DropdownMenuItem> menuItemList = doubleList.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList();
    var exName = widget.sessionExercise.part.name.toString().toLowerCase();

    var history = widget.sessionExercise.history;
    // set the default settings
    if(history != null && history.isNotEmpty && hasNotLoadedDefaults) {
      var svd = history[selectedEquipmentIndex]['duration'].toString();
      var parsed = svd != '' ? int.parse(svd) : 0;
      var converted = convertTime(parsed) ?? 0;
      _currentDurationSliderValue = converted.toDouble();
      widget.sessionExercise.lastDuration = converted;

      var dist  = history[selectedEquipmentIndex]['distance'].toString();
      _currentDistanceSliderValue = dist != '' ? double.parse(dist) : 0.0;
      widget.sessionExercise.lastDistance = dist != '' ? double.parse(dist) : 0.0;

      var rep = history[selectedEquipmentIndex]['rep'].toString();
      _currentRepsSliderValue = rep != '' ? double.parse(rep) : 0.0;
      widget.sessionExercise.lastRep = rep != '' ? double.parse(rep).toString()
          : '0.0';

      var weight = history[selectedEquipmentIndex]['weight'].toString();
      _currentWeightSliderValue = weight != '' ? double.parse(weight) : 0.0;
      widget.sessionExercise.lastWeight = weight != '' ? int.parse(weight) : 0;

      hasNotLoadedDefaults = false;
    }
       return Scaffold(
           body : Column(
             children: <Widget>[
         const Spacer(
           flex: 1,
         ),
         Row(
           children: [
             const Spacer(
               flex: 1,
             ),
             Text(
               widget.title.toUpperCase(),
               style: const TextStyle(
                   fontWeight: FontWeight.normal,
                   fontSize: 36,
                   color: Colors.blueGrey),
             ),
             const Spacer(flex: 10),
           ],
         ),
         const Spacer(
           flex: 1,
         ),
        ToggleButtons(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          children: List<Widget>.generate(widget.sessionExercise.equipment.length, (index) {
            var equipment = widget.sessionExercise.equipment[index];
            return SizedBox(
              width: 100,
                height: 45,
                child: Center( child: Text(equipment.toString(),style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.blueGrey)))
            );
          }),
          onPressed: (int index) {
            setState(() {
              selectedEquipmentIndex = index;
              hasNotLoadedDefaults = true;
            });
          },
          isSelected: List<bool>.generate(widget.sessionExercise.equipment.length, (index) { return selectedEquipmentIndex == index;}),
        ),
         const Spacer(flex: 1),
         if (exName == 'cardio')
              Column(
           children: [
             Row(
               children: [
                 const Spacer(flex: 1),
                 Text( getDurationText(),
                   style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.blueGrey)),
                 const Spacer(flex: 10)
               ],
             ),
             Slider(
               value: _currentDurationSliderValue,
               min: 0,
               max: 200,
               divisions: 40,
               label: _currentDurationSliderValue.round().toString() + ' minutes',
               onChanged: (double value) {
                 setState(() {
                   _currentDurationSliderValue = value;
                   widget.sessionExercise.duration = value.round();
                 });
               },
             ),
             Row(
               children: [
                 const Spacer(flex: 1),
                 Text( getDistanceText(),
                     style: const TextStyle(
                         fontWeight: FontWeight.normal,
                         fontSize: 20,
                         color: Colors.blueGrey)),
                 const Spacer(flex: 10)
               ],
             ),
             Slider(
               value: _currentDistanceSliderValue,
               min: 0,
               max: 10,
               divisions: 10,
               label: _currentDistanceSliderValue.round().toString() + ' miles',
               onChanged: (double value) {
                 setState(() {
                   _currentDistanceSliderValue = value;
                   widget.sessionExercise.distance = value;
                 });
               },
             ),
             Row(
               children: [
                 const Spacer(flex: 1),
                 Text( getRepsText(),
                     style: const TextStyle(
                         fontWeight: FontWeight.normal,
                         fontSize: 20,
                         color: Colors.blueGrey)),
                 const Spacer(flex: 10)
               ],
             ),
             Slider(
               value: _currentRepsSliderValue,
               min: 0,
               max: 10,
               divisions: 10,
               label: 'Reps: ' +  _currentRepsSliderValue.round().toString(),
               onChanged: (double value) {
                 setState(() {
                   _currentRepsSliderValue = value;
                   widget.sessionExercise.rep = value.toString();
                 });
               },
             ),
           ],
        )
         else Column(
            children: [
              Row(
                children: [
                  const Spacer(flex: 1),
                  Text( getWeightText(),
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.blueGrey)),
                  const Spacer(flex: 10)
                ],
              ),
            Slider(
              value: _currentWeightSliderValue,
              min: 0,
              max: 400,
              divisions: 80,
              label: _currentWeightSliderValue.round().toString() + ' lbs',
              onChanged: (double value) {
                setState(() {
                  _currentWeightSliderValue = value;
                  widget.sessionExercise.weight = value.round();
                });
              },
            ),
              Row(
                children: [
                  const Spacer(flex: 1),
                  Text( getRepsText(),
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          color: Colors.blueGrey)),
                  const Spacer(flex: 10)
                ],
              ),
            Slider(
                value: _currentRepsSliderValue,
                min: 0,
                max: 10,
                divisions: 10,
                label: _currentRepsSliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _currentRepsSliderValue = value;
                    widget.sessionExercise.rep = value.toString();
                  });
                },
              ),
            ],
          ),
         const Spacer(
           flex: 2,
         ),
        Row(
          children: const [
            Spacer(
              flex: 1,
            ),
            // ElevatedButton(
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
            //   ),
            //   onPressed: () {},
            //   child: const Text(
            //     "BACK",
            //     style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            //   ),
            // ),
            Spacer(
              flex: 10,
            ),
            // ElevatedButton(
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            //   ),
            //   onPressed: () {
            //     // calculate the changes since the exercise passed in
            //     // add the new exercise
            //     var newEntry = widget.exercise;
            //     widget.svc.loggedExercises.add(newEntry);
            //   },
            //   child: const Text(
            //     "LOG",
            //     style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
            //   ),
            // ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ]),
         floatingActionButton: SpeedDial(
           // animatedIcon: AnimatedIcons.menu_close,
           // animatedIconTheme: IconThemeData(size: 22.0),
           // / This is ignored if animatedIcon is non null
           // child: Text("open"),
           // activeChild: Text("close"),
           icon: Icons.add,
           activeIcon: Icons.close,
           spacing: 3,
           openCloseDial: isDialOpen,
           childPadding: const EdgeInsets.all(5),
           spaceBetweenChildren: 4,
           dialRoot: customDialRoot
               ? (ctx, open, toggleChildren) {
             return ElevatedButton(
               onPressed: toggleChildren,
               style: ElevatedButton.styleFrom(
                 primary: Colors.blue[900],
                 padding: const EdgeInsets.symmetric(
                     horizontal: 22, vertical: 18),
               ),
               child: const Text(
                 "Custom Dial Root",
                 style: TextStyle(fontSize: 17),
               ),
             );
           }
               : null,
           buttonSize: 56, // it's the SpeedDial size which defaults to 56 itself
           // iconTheme: IconThemeData(size: 22),
           label: extend
               ? const Text("Open")
               : null, // The label of the main button.
           /// The active label of the main button, Defaults to label if not specified.
           activeLabel: extend ? const Text("Close") : null,

           /// Transition Builder between label and activeLabel, defaults to FadeTransition.
           // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
           /// The below button size defaults to 56 itself, its the SpeedDial childrens size
           childrenButtonSize: childrenButtonSize,
           visible: visible,
           direction: speedDialDirection,
           switchLabelPosition: false,

           /// If true user is forced to close dial manually
           closeManually: false,

           /// If false, backgroundOverlay will not be rendered.
           renderOverlay: true,
           // overlayColor: Colors.black,
           // overlayOpacity: 0.5,
           onOpen: () => debugPrint('OPENING DIAL'),
           onClose: () => debugPrint('DIAL CLOSED'),
           useRotationAnimation: true,
           tooltip: 'Open Speed Dial',
           heroTag: 'speed-dial-hero-tag',
           // foregroundColor: Colors.black,
           // backgroundColor: Colors.white,
           // activeForegroundColor: Colors.red,
           // activeBackgroundColor: Colors.blue,
           elevation: 8.0,
           isOpenOnStart: false,
           animationSpeed: 200,
           shape: customDialRoot
               ? const RoundedRectangleBorder()
               : const StadiumBorder(),
           // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
           children: [
             SpeedDialChild(
               child: !rmicons ? const Icon(Icons.book_rounded) : null,
               backgroundColor: Colors.green,
               foregroundColor: Colors.white,
               label: 'Log Exercise',
               onTap: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                         backgroundColor: Colors.green,
                         content: Text(("Exercise logged"))));

                 var id = const Uuid().v1().toString();
                 var newEntry = widget.sessionExercise;
                 newEntry.id = id;
                 newEntry.duration = exerciseDuration;

                 newEntry.weight = newEntry.weight == 0 ? newEntry.lastWeight
                : newEntry.weight;

                 newEntry.duration = newEntry.duration == 0 ? newEntry
                     .lastDuration
                     : _start;

                 newEntry.distance = newEntry.distance == 0.0 ? newEntry
                     .lastDistance
                     : newEntry.distance;

                 newEntry.rep = newEntry.rep == '0' ? newEntry
                     .lastRep
                     : newEntry.rep;

                 newEntry.equipmentUsed = newEntry.equipment[selectedEquipmentIndex].name;

                 widget.svc.loggedExercises.add(newEntry);

               },
             ),
             SpeedDialChild(
               child: widget.svc.timerHasNotStarted ? const Icon(Icons
        .play_arrow_rounded): isTimerPaused ? const Icon(Icons
                   .play_arrow_rounded) :  const Icon(Icons
                   .pause_circle_rounded) ,
               backgroundColor: Colors.deepOrange,
               foregroundColor: Colors.white,
               label: widget.svc.timerHasNotStarted  ? 'Start Session' :
            isTimerPaused ?
             'Resume Session' : 'Pause '
                   'Session',
               onTap: ()  {
                 ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar( backgroundColor: Colors.green, content: Text
                        (widget.svc.timerHasNotStarted ?
                      'Starting session ...' :
                         isTimerPaused
                         ? "Starting session ..."
                         : "Pausing session ...")));

                 if(widget.svc.timerHasNotStarted) {
                   widget.svc.startTimer();
                   startTimer(0);
                 } else if (!widget.svc.timerHasNotStarted) {
                   if(isTimerPaused){
                     widget.svc.unpauseTimer();
                     unpauseTimer();
                     setState(() {
                       isTimerPaused = false;
                     });

                   } else {
                     pauseTimer();
                     widget.svc.pauseTimer();
                     setState(() {
                       isTimerPaused = true;
                     });

                   }
                 }
               },
             ),
             SpeedDialChild(
               child: !rmicons ? const Icon(Icons.stop) : null,
               backgroundColor: Colors.red,
               foregroundColor: Colors.white,
               label: 'Checkout',
               visible: true,
               onTap: () {

                 ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                         backgroundColor: Colors.green,
                         content: Text(("Checking out ... "))));

                 // save all logged exercises to db
                 widget.svc.save();
                 widget.svc.checkOut();
                 Navigator.push(
                     context,
                     MaterialPageRoute(
                         builder: (context) =>
                             Checkout(title: 'All Done', duration: getElapsedTime(), svc:
                             widget.svc,)
                     ));
               },
               //onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
             ),
           ],
         ),
         bottomSheet:  SizedBox(
                 height: 40,
                 width: 140,
                 child: Column(
                   children:  <Widget>[
                     Padding(
                       padding: const EdgeInsets.all(0),
                       child: Text(getElapsedTime(),
                         style: const TextStyle(
                             fontSize: 12,
                             fontFamily: 'Helvetica',
                             fontWeight: FontWeight.bold
                         ),
                       ),
                     ),
                   ],
                 )
         ),
       );
   // });
  }



  logExercise() {
    // actually show the floating button menu with options
    // for logging, editing exercise and checking out of a session

// set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("cancel"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: const Text("log"),
      onPressed:  () {
        // close dialog
        Navigator.of(context).pop();

        // save data
        var newEntry = widget.sessionExercise;
        widget.svc.loggedExercises.add(newEntry);

        //check out of the session
        Provider.of<SessionSvc>(context, listen: false).checkOut();

        // navigate to home  ?? // should be to a Checkout page with session
        // details
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(db: widget.svc.getDb(), title: 'Spotter',)
            ));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Log Exercise"),
      content: const Text("Exercise specifics here"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }

  checkout(){
    widget.svc.save();
    widget.svc.checkOut();
  }

   convertTime(int timeInMilliseconds) {
     Duration timeDuration = Duration(milliseconds: timeInMilliseconds);
     return timeDuration.inMinutes;
   }

   getRepsText() {
    return "Reps: " + _currentRepsSliderValue.toString()+ " times";
  }

   getWeightText() {
    return "Weight: " + _currentWeightSliderValue.toString() + " lbs";
  }

   getDistanceText() {
    return "Distance: " + _currentDistanceSliderValue.toString() + " miles";
  }

   getDurationText() {
    return "Duration: " + _currentDurationSliderValue.toString() + " minutes";
  }

  getExerciseEntry() {
    return widget.sessionExercise;
  }

  String getElapsedTime() {
    var hr = ((_start / (60 * 60)) % 60)
                 .floor()
                 .toString()
                 .padLeft(2, '0');
    var         min = ((_start / 60) % 60)
                 .floor()
                 .toString()
                 .padLeft(2, '0');
    var         sec =
                 (_start % 60).floor().toString().padLeft(2, '0');

    return "$hr:$min:$sec";
  }
}
