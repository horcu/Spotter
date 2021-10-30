import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/enums/equipment.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/excercise_entry.dart';
import 'package:spotter/models/history.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/models/session.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:uuid/uuid.dart';

/// This is the stateful widget that the main application instantiates.
class WorkoutDetailsStatefulWidget extends StatefulWidget {
  WorkoutDetailsStatefulWidget(this.title, this.svc, this.sessionExercise);

  SessionSvc svc;
  String title;
  var weightDropdownValue;
  var repDropdownValue;
  var exerciseDuration = 0;
  SessionExercise sessionExercise;
  Equipment? equipmentType = Equipment.none;

  @override
  State<WorkoutDetailsStatefulWidget> createState() => Workoutdetails();
}

class Workoutdetails extends State<WorkoutDetailsStatefulWidget> {
  var currentRecommendationModel = {};
  int selectedIndex = 0;

  var _currentDistanceSliderValue = 0.0;
  var _currentDurationSliderValue = 0.0;
  var _currentRepsSliderValue = 0.0;

  var _currentWeightSliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
   // return Consumer<Session>(builder: (context, session, child) {

    List<String> doubleList = List<String>.generate(25, (int index) => '${index * 5 + 1}');
    List<DropdownMenuItem> menuItemList = doubleList.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList();
    var exName = widget.sessionExercise.part.name.toString().toLowerCase();

    var history = widget.sessionExercise.history;;
    // set the default settings
    if(history != null && history.isNotEmpty) {
      var svd = history[selectedIndex]['duration'].toString();
      var parsed = svd != '' ? int.parse(svd) : 0;
      var converted = convertTime(parsed) ?? 0;
      _currentDurationSliderValue = converted.toDouble();

      var dist  = history[selectedIndex]['distance'].toString();
      _currentDistanceSliderValue = dist != '' ? double.parse(dist) : 0.0;

      var rep = history[selectedIndex]['rep'].toString();
      _currentRepsSliderValue = rep != '' ? double.parse(rep) : 0.0;

      var weight = history[selectedIndex]['weight'].toString();
      _currentWeightSliderValue = weight != '' ? double.parse(weight) : 0.0;
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
              selectedIndex = index;
            });
          },
          isSelected: List<bool>.generate(widget.sessionExercise.equipment.length, (index) { return selectedIndex == index;}),
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
           floatingActionButton: FloatingActionButton(
             onPressed: showActionMenu,
             tooltip: 'Log',
             child: const Icon(Icons.save_rounded),
           ) // This trailing comma makes auto-formatting nicer for build methods.
       );
   // });
  }

  void getEquipmentHistory(Equipment newValue) {
   // currentRecommendationModel = widget.svc.getAllExercisesByPart(newValue.name);
  }

  showActionMenu() {
    // actually show the floating button menu with options
    // for logging, editing exercise and checking out of a session
    // var newEntry = widget.sessionExercise;
    // widget.svc.loggedExercises.add(newEntry);

    widget.svc.flushSelectedExercises();
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
    return "Reps: " + _currentRepsSliderValue.toString();
  }

   getWeightText() {
    return "Weight: " + _currentWeightSliderValue.toString();
  }

   getDistanceText() {
    return "Distance: " + _currentDistanceSliderValue.toString();
  }

   getDurationText() {
    return "Duration: " + _currentDurationSliderValue.toString();
  }
}
