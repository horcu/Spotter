import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotter/enums/equipment.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/excercise_entry.dart';
import 'package:spotter/models/exercise.dart';
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
  Exercise exercise;

  Equipment? equipmentType = Equipment.other;

  @override
  State<WorkoutDetailsStatefulWidget> createState() => Workoutdetails();
}

class Workoutdetails extends State<WorkoutDetailsStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Session>(builder: (context, session, child) {
      return Column(children: <Widget>[
        const Spacer(flex: 1),
        const Spacer(
          flex: 1,
        ),
        Row(
          children: [
            const Spacer(
              flex: 1,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.blueGrey),
            ),
            const Spacer(flex: 10),
          ],
        ),
        const Spacer(
          flex: 2,
        ),
        Row(
          children: [
            const Spacer(
              flex: 1,
            ),
            const Text('Equipment'),
            const Spacer(
              flex: 1,
            ),
            DropdownButton<Equipment>(
                value: widget.equipmentType,
                onChanged: (newValue) {
                  setState(() {
                    widget.equipmentType = newValue;
                  });
                },
                items: Equipment.values.map((Equipment classType) {
                  return DropdownMenuItem<Equipment>(
                      value: classType, child: Text(classType.name));
                }).toList()),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        Row(
          children: const [
            Spacer(
              flex: 1,
            ),
            Text('Last Weight'),
            Spacer(
              flex: 1,
            ),
            Text('200lbs'),
            Spacer(
              flex: 1,
            ),
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        Row(
          children: const [
            Spacer(
              flex: 1,
            ),
            Text('Last Rep'),
            Spacer(
              flex: 1,
            ),
            Text('3'),
            Spacer(
              flex: 1,
            )
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        Row(
          children: const [
            Spacer(
              flex: 1,
            ),
            Text('Recommended'),
            Spacer(
              flex: 1,
            ),
            Text('205lbs * 3 reps'),
            Spacer(
              flex: 1,
            ),
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        Row(
          children: [
            const Spacer(
              flex: 1,
            ),
            const Text('Actual'),
            const Spacer(
              flex: 1,
            ),
            DropdownButton<String>(
              value: widget.weightDropdownValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 12,
              elevation: 16,
              style: const TextStyle(color: Colors.blueGrey),
              underline: Container(
                height: 2,
                color: Colors.greenAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  widget.weightDropdownValue = newValue!;
                });
              },
              items:
                  List<String>.generate(75, (int index) => '${index * 5 + 10}')
                      .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text("lbs "),
            const Text(" * "),
            DropdownButton<String>(
              value: widget.repDropdownValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 12,
              elevation: 16,
              style: const TextStyle(color: Colors.blueGrey),
              underline: Container(
                height: 2,
                color: Colors.greenAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  widget.repDropdownValue = newValue!;
                });
              },
              items:
                  List<String>.generate(10, (int index) => '${index * 1 + 1}')
                      .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text(" reps"),
            const Spacer(
              flex: 1,
            ),
          ],
        ),
        const Spacer(
          flex: 2,
        ),
        Row(
          children: [
            const Spacer(
              flex: 1,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              onPressed: () {},
              child: const Text(
                "BACK",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
            ),
            const Spacer(
              flex: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {

                var exEntry = ExerciseEntry(id: const Uuid().toString(),
                    exercise: widget
                    .exercise);
                session.exerciseEntries.add(exEntry);
              },
              child: const Text(
                "LOG",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
          ],
        )
      ]);
    });
  }
}
