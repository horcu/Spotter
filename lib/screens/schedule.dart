import 'package:flutter/material.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';

import '../main.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key, required this.title, required this.svc}) : super
      (key: key);
  final String title;
  final SessionSvc svc;

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TopBar(
        onTitleTapped: (){},
        title: widget.title,
        onPressed: (){ Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(db: widget.svc.getDb(), title: 'Spotter',)
            ));},
        child: const Icon(Icons.arrow_back),
        svc: widget.svc,
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text("Session Schedule")
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveSchedule,

        tooltip: 'save',
        child: const Icon(Icons.save_rounded),
      ),
      //bottomSheet:  widget.svc.getSessionBar(),// T// This trailing comma
    // makes auto-formatting nicer for build methods.
    );
  }

  @override
  void initState() {
    // TODO: put timer here so that it fires every second once started



















    super.initState();
  }
  void saveSchedule() {
  }
}