import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotter/models/session.dart';

class SessionBar extends StatefulWidget {

  @override
  _SessionBarState createState() => _SessionBarState();
}

class _SessionBarState extends State<SessionBar> {

  bool flag = true;
  late Stream<int> timerStream;
  late  bool timerStarted = false;

  late String hoursStr = '00';
  late String minutesStr = '00';
  late String secondsStr = '00';

  late StreamSubscription<int> timerSubscription;

  @override
  Widget build(BuildContext context) {

     var hr = hoursStr;
     var min = minutesStr;
     var sec = secondsStr;

    return  SizedBox(
        height: 30,
          width: 150,
          child : Row(
            children: [
              const Spacer(flex: 1,),
              const Icon(Icons.timer_rounded, color: Colors.grey,),
              Text(
                " $hr:$min:$sec",
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey
                ),
              ),
              const Spacer(flex: 10),
            ],
          )
      // Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //
      //       const SizedBox(height: 20.0),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
                // ElevatedButton(
                //   onPressed: () {
                //     timerStream = stopWatchStream();
                //     timerSubscription = timerStream.listen((int newTick) {
                //       setState(() {
                //         hoursStr = ((newTick / (60 * 60)) % 60)
                //             .floor()
                //             .toString()
                //             .padLeft(2, '0');
                //         minutesStr = ((newTick / 60) % 60)
                //             .floor()
                //             .toString()
                //             .padLeft(2, '0');
                //         secondsStr =
                //             (newTick % 60).floor().toString().padLeft(2, '0');
                //       });
                //     });
                //   },
                //   child: const Text(
                //     'START',
                //     style: TextStyle(
                //       fontSize: 20.0,
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 40.0),
                // ElevatedButton(
                //   onPressed: () {
                //     timerSubscription.cancel();
                //     // timerStream = null;
                //     setState(() {
                //       hoursStr = '00';
                //       minutesStr = '00';
                //       secondsStr = '00';
                //     });
                //   },
                //   child: const Text(
                //     'RESET',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 20.0,
                //     ),
                //   ),
        //         // ),
        //       ],
        //     ),
        //   ],
        // ),
    );
  }

  Stream<int> stopWatchStream() {
    StreamController<int> streamController = StreamController<int>(
      onListen: null,
      onCancel: null,
      onResume: null,
      onPause: null,
    );;
    late Timer timer;
    Duration timerInterval = const Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer.cancel();
        // timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void tick(_) {
      counter++;
      streamController.add(counter);
      // if (!flag) {
      //   stopTimer();
      //  }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

   void initSessionTimer() {
     timerStream = stopWatchStream();
      timerSubscription = timerStream.listen((int
     newTick) {

       hoursStr = ((newTick / (60 * 60)) % 60)
           .floor()
           .toString()
           .padLeft(2, '0');
       minutesStr = ((newTick / 60) % 60)
           .floor()
           .toString()
           .padLeft(2, '0');
       secondsStr =
           (newTick % 60).floor().toString().padLeft(2, '0');
     });

   }
}