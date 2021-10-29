import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/enums/equipment.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/excercise_entry.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/models/session.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:uuid/uuid.dart';

/// This is the stateful widget that the main application instantiates.
class WorkoutDetailsStatefulWidget extends StatefulWidget {
  WorkoutDetailsStatefulWidget(this.title, this.svc, this.exercise);

  SessionSvc svc;
  String title;
  var weightDropdownValue;
  var repDropdownValue;
  var exerciseDuration = 0;
  SessionExercise exercise;
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

  @override
  Widget build(BuildContext context) {
   // return Consumer<Session>(builder: (context, session, child) {

    List<String> doubleList = List<String>.generate(25, (int index) => '${index * 5 + 1}');
    List<DropdownMenuItem> menuItemList = doubleList.map((val) => DropdownMenuItem(value: val, child: Text(val))).toList();
    var exName = widget.exercise.part.name.toString().toLowerCase();

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
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          children: List<Widget>.generate(widget.exercise.equipment.length, (index) {
            var equipment = widget.exercise.equipment[index];
            return SizedBox(
              width: 200,
                height: 125,
                child: Center( child: Text(equipment.toString(),style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 30,
                    color: Colors.blueGrey)))
            );
          }),
          onPressed: (int index) {
            setState(() {
              selectedIndex = index;

              if(widget.exercise.equipment[index] != 'none') {
                var history = widget.svc.getLastLoggedSessionForEquipment(
                    widget.exercise.equipment[index]);
              }
            });
          },
          isSelected: List<bool>.generate(widget.exercise.equipment.length, (index) { return selectedIndex == index;}),
        ),
         const Spacer(
           flex: 1,
         ),
         if (exName == 'cardio') Column(
           children: [
             const Text( "Duration: ",
               style: TextStyle(
                   fontWeight: FontWeight.normal,
                   fontSize: 20,
                   color: Colors.blueGrey),
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
             const Text( "Distance: ",
               style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 20,
                   color: Colors.blueGrey),
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
             const Text( "Reps: ",
               style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 20,
                   color: Colors.blueGrey),
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
        ) else Column(
            children: [
              const Text( "Weight",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.blueGrey),
              ),
            Slider(
              value: _currentDurationSliderValue,
              min: 0,
              max: 400,
              divisions: 80,
              label: _currentDurationSliderValue.round().toString() + ' lbs',
              onChanged: (double value) {
                setState(() {
                  _currentDurationSliderValue = value;
                });
              },
            ),
              const Text( "Rep: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blueGrey),
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
             onPressed: showActionMenu(),
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
    var newEntry = widget.exercise;
    widget.svc.loggedExercises.add(newEntry);
  }
}
