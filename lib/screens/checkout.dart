import 'package:flutter/material.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';

import '../main.dart';

class Checkout extends StatefulWidget {


  const Checkout({Key? key, required this.title, required this.duration,
    required this.svc}) :
        super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String duration;
  final SessionSvc svc;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TopBar(
        title: widget.title,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        child: Icon(Icons.home_rounded), onTitleTapped: (){}, onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(db: widget.svc.getDb(), title: 'Spotter',)
            ));
      }, svc:
      widget
          .svc,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            const Spacer(flex: 2,),
             Text("${DateTime.now().day.toString().padLeft(2,''
                 '0')} / ${DateTime.now().month
                 .toString()
                 .padLeft(2,'0')} / ${DateTime.now().year.toString()}",
              style: const TextStyle( fontSize: 35,
                  fontWeight:  FontWeight
                  .bold),),
             const Spacer(flex: 1,),
             const Text('WORKOUT TIME',
             style: TextStyle(color: Colors.grey,   fontSize: 30, fontWeight:
             FontWeight
            .bold),),
            Text(widget.duration,  style: const TextStyle(color: Colors.grey,fontSize: 25,
                fontWeight:
            FontWeight.normal),),
            const Spacer(flex: 3,),
          ],
        ),
      ),
    );
  }
}