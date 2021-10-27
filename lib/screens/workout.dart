import 'package:flutter/material.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/workout_details.dart';

class Workout extends StatefulWidget {
  const Workout(this.title, this.svc);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final SessionSvc svc;
  final String title;

  @override
  State<Workout> createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final PageController controller = PageController(initialPage: 0);
    var allExercises = widget.svc.getAllExercisesByPart(widget.title);
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
    PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      scrollDirection: Axis.horizontal,
      controller: controller,
      children:  <Widget>[
         Center( // replace hard coded title with value from list when
           // returned from hive/db
          child:  WorkoutDetailsStatefulWidget(allExercises[0].name, widget.svc,
          allExercises[0]),
        ),
        Center(
          child:  WorkoutDetailsStatefulWidget(allExercises[1].name, widget.svc,
              allExercises[1]),
        ),
        Center(
          child:  WorkoutDetailsStatefulWidget(allExercises[2].name, widget.svc,
              allExercises[2]),
        ),
        Center(
          child:  WorkoutDetailsStatefulWidget(allExercises[3].name, widget.svc,
              allExercises[3]),
        ),
        Center(
          child:  WorkoutDetailsStatefulWidget(allExercises[4].name, widget.svc,
              allExercises[4]),
        ),
        Center(
          child:  WorkoutDetailsStatefulWidget(allExercises[5].name, widget.svc,
              allExercises[5]),
        )
      ],
    )
);
  }
}