
import 'package:flutter/material.dart';
import 'package:spotter/enums/partenum.dart';
import 'package:spotter/models/part.dart';
import 'package:spotter/screens/exercises.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';

import '../main.dart';

class Parts extends StatefulWidget {
  SessionSvc svc;
  var title;
  List<Part> selectedParts = [];
  List<String> allPartIds = [];

  Parts(this.svc, this.title);

  @override
  State<Parts> createState() => _partState();
}

class _partState extends State<Parts> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: TopBar(
        onTitleTapped: () {
        },
        title: widget.title,
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
          itemCount: widget.svc.parts.length,
          itemBuilder: (context, index) {
            var selected = widget.svc.parts[index];
            var isSelected = widget.allPartIds.contains(selected.name);
            return Card(
                color: Colors.blueGrey,
                child: ListTile(
                    textColor: Colors.white,
                    onTap: () {
                      setState(() {

                        if (!isSelected) {
                          widget.selectedParts.add(selected);
                          widget.allPartIds.add(selected.name);
                        } else {
                          widget.selectedParts.removeWhere((element) => element.name == selected.name);
                          widget.allPartIds.remove(selected.name);
                        }

                        widget.svc.saveSelectedParts(widget.selectedParts);
                      });
                    },
                    title: Text(selected.name, style: TextStyle(fontSize:
                    isSelected ? 20 : 18),),
                    subtitle: const Text(''),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blueGrey,
      onPressed: startWorkout,
      tooltip: 'Start Session',
      child: const Icon(Icons.arrow_right_alt),
    ),
     // bottomSheet:  widget.svc.getSessionBar() // This trailing c,
    );
  }

  void startWorkout() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Exercises(svc: widget.svc, parts: widget.selectedParts)
        ));
  }
}