import 'package:flutter/material.dart';
import 'package:spotter/enums/partenum.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/models/part.dart';
import 'package:spotter/screens/session.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';

import '../main.dart';
import 'categories.dart';

class Exercises extends StatefulWidget {
  List<Part> parts;
  SessionSvc svc;
  List<String> selectedExerciseIds = [];
  List<dynamic> selectedExercises = [];

  Exercises({required this.parts, required this.svc});

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    if (widget.selectedExercises.isNotEmpty) {
      for (var ex in widget.selectedExercises) {
        if (!widget.selectedExerciseIds.contains(ex.name)) {
          widget.selectedExerciseIds.add(ex.name);
        }
      }
    }
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: TopBar(
          onTitleTapped: () {},
          title: 'Exercises',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyHomePage(db: widget.svc.getDb(), title: 'Spotter',)
                ));
          },
          child: const Icon(Icons.arrow_back),
          svc: widget.svc,
        ),
        body: ListView.builder(
            itemCount: allExercises.length,
            itemBuilder: (context, index) {
              var selected = allExercises[index];
              var isSelected = widget.selectedExerciseIds.contains(
                  selected.name);
              return Card(
                  color: Colors.blueGrey,
                  child: ListTile(
                      textColor: Colors.white,
                      onTap: () {
                        setState(() {
                          if (!isSelected) {
                            widget.selectedExerciseIds.add(selected.name);
                            widget.selectedExercises.add(selected);
                          } else {
                            widget.selectedExerciseIds.remove(selected.name);
                            widget.selectedExercises.removeWhere((x) =>
                            x.name == selected.name);
                          }

                          widget.svc.saveSelectedExercises(
                              widget.selectedExercises);
                        });
                      },
                      title: Text(selected.name,
                        style: TextStyle(fontSize: isSelected ? 20 : 18),),
                      subtitle: Text(selected.part),
                      leading:
                      isSelected
                          ? const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 20.0,
                        semanticLabel:
                        'Text to announce in accessibility modes',
                      )
                          : const Icon(
                        Icons.add,
                        color: Colors.orange,
                        size: 20.0,
                        semanticLabel:
                        'Text to announce in accessibility modes',
                      ),
                      trailing: const Text("")));
            }),
        floatingActionButton:
        Stack(
          children: <Widget>[
            Padding(padding: const EdgeInsets.only(right: 66),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    onPressed: addNewExercise,
                    tooltip: 'add exercise',
                    child: const Icon(Icons.add_rounded),
                  ),
                )),

            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                onPressed: startWorkout,
                tooltip: 'Start Session',
                child: Icon(Icons.arrow_right_alt),
              ),
            ),
          ],
        )

      //  bottomSheet:  widget.svc.getSessionBar(),// T
    );
  }

  void startWorkout() {
    // check in
    widget.svc.checkIn();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkoutSession(widget.parts, 'Session', widget.svc, widget
                    .selectedExercises)));
  }


  addNewExercise() {
    // show a bottomsheet omaybe that allows you to add a name and choose a
    // target area to associate it with as well as default
    // weight/rep/distance/duration
    return showModalBottomSheet(
      backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             Row(
               children:[
               Text('Name'),
                 // TextField(
                 //   controller: _controller,
                 //     onSubmitted:(e){}
                 // )
          ]
             ),
              ListTile(
                title: Text('Target Area'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Weight'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Rep'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Distance'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Duration'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: RawMaterialButton(
                  fillColor: Colors.orangeAccent,
                  elevation: 8,
                  onPressed: () {  },
                  child: Text('Save'),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
