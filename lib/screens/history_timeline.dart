import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spotter/models/session.dart';
import 'package:spotter/presentation/spotter_icons.dart';
import 'package:spotter/presentation/parts_icons.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';
import 'package:timelines/timelines.dart';
import '../main.dart';

class HistoryTimeline extends StatefulWidget {
  SessionSvc svc;

  HistoryTimeline({required this.svc});

  @override
  _State createState() => _State();
}

class _State extends State<HistoryTimeline> {
  @override
  Widget build(BuildContext context) {
    List<Session> sessions = widget.svc.getHistoricalTimeline();

    return Scaffold(
      appBar: TopBar(
        onTitleTapped: () {},
        title: 'History',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        db: widget.svc.getDb(),
                        title: 'Spotter',
                      )));
        },
        child: const Icon(Icons.arrow_back),
        svc: widget.svc,
      ),
      body: Timeline.tileBuilder(
        builder: TimelineTileBuilder.fromStyle(
          contentsAlign: ContentsAlign.alternating,
          contentsBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                margin: const EdgeInsets.all(4),
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child:  Column(
                      children: getExercisesForSession(sessions[index])
                    )
                )),
          ),
          itemCount: sessions.length,
        ),
      ),
    );
  }

  getExercisesForSession(Session session) {
    return [
      Row(
      children: [
        Text(DateFormat.Md().format(DateTime.parse(session.date.toString())),
           ),
        const Spacer(flex: 30,),
        const Icon(Icons.timer_rounded,  size: 13, color: Colors.grey),
        const Spacer(flex: 1,),
        Text(session.duration.toString(), style: const TextStyle( fontSize:
        14, color: Colors.grey),),
        const Spacer(flex: 1,),
      ]),
      Row(
        children: const [
          Spacer(flex: 11,)
            ]

      ),
      Row(
          children: const [
            Text('-------', style: TextStyle(fontSize: 12, fontWeight:
            FontWeight.bold),),
          ]
      ),
      
      SizedBox(
          height: 50,
          child: ListView.builder(
            reverse: true,
              itemCount: session.exercises.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Icon(getIcon(session.exercises[index].equipmentUsed), size: 12, color: Colors
                    .black45,),
                    const Spacer(flex: 1,),
                    const Icon(Spotter.dumbell2, size: 12, color: Colors
                        .black45,),
                    const Spacer(flex: 1,),
                    Text(session.exercises[index].name, style:
                     const TextStyle(fontSize: 10),),
                    const Spacer(flex: 200,),
                    Text(session.exercises[index].weight.toString(),
                        style: const TextStyle(color: Colors.black87,
                            fontSize: 10)),
                    const Spacer(flex: 1,),
                    const Text('|', style:  TextStyle(color: Colors.black87,fontSize: 8)),
                    Text(double.parse(session.exercises[index].rep)
                        .toInt().toString(), style: const TextStyle(color:
                    Colors.black87, fontSize: 10)),
                    const Spacer(flex: 1,)
                  ],
                );
              })
      )
    ];
  }

  IconData? getIcon(String name) {
    return Parts().getByName(name);
  }
}
