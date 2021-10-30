import 'package:flutter/material.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/screens/workout.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';

import '../main.dart';
import 'categories.dart';

class TodaysWorkout extends StatefulWidget {
  List<Part> parts;
  SessionSvc svc;
  List<String> selectedExerciseIds = [];
  List<dynamic> selectedExercises = [];

  TodaysWorkout({required this.parts, required this.svc});

  @override
  State<TodaysWorkout> createState() => _TodaysWorkoutState();
}

class _TodaysWorkoutState extends State<TodaysWorkout> {
  @override
  Widget build(BuildContext context) {
    var title = '';
    widget.parts.forEach((p) {
      title = title == '' ? title + p.name : title + ' | ' + p.name;
    });

    var allExercises = [];
    widget.parts.forEach((p) {
      var exs = widget.svc.getAllExercisesByPart(p.name);
      allExercises.addAll(exs);
    });

    widget.selectedExercises = widget.svc.getSelectedExercises();
    if(widget.selectedExercises.isNotEmpty) {
      for (var ex in widget.selectedExercises)
      {
        if(!widget.selectedExerciseIds.contains(ex.name)) {
          widget.selectedExerciseIds.add(ex.name);
        }}
    }
    return Scaffold(
      appBar: TopBar(
        onTitleTapped: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Workout(widget.parts, title, widget.svc, widget.selectedExercises)));
        },
        title: title.toUpperCase(),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: title, db: widget.svc.getDb())));
        },
        child: const Icon(Icons.arrow_back),
      ),
      body: ListView.builder(
          itemCount: allExercises.length,
          itemBuilder: (context, index) {
            var selected = allExercises[index];
            var isSelected = widget.selectedExerciseIds.contains(selected.name);
            return Card(
                child: ListTile(
                    onTap: () {
                      setState(() {

                        if (!isSelected) {
                          widget.selectedExerciseIds.add(selected.name);
                          widget.selectedExercises.add(selected);
                        } else {
                          widget.selectedExerciseIds.remove(selected.name);
                          widget.selectedExercises.removeWhere((x) => x.name == selected.name);
                        }

                        widget.svc.saveSelectedExercises(widget.selectedExercises);
                      });
                    },
                    title: Text(selected.name, style: TextStyle(fontSize: isSelected ? 26 : 24),),
                    subtitle: Text(selected.part),
                    leading:
                        isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 24.0,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                              )
                            : const Icon(
                                Icons.add,
                                color: Colors.orange,
                                size: 24.0,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                              ),
                    trailing: const Text("")));
          }),
    );
  }
}
