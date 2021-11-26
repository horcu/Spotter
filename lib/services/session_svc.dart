import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:spotter/enums/partenum.dart';
import 'package:spotter/models/equipment.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/models/part.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/models/session.dart';
import 'package:table_calendar/table_calendar.dart';

class SessionSvc extends ChangeNotifier {
  final String _dbPartRecommendationKey = 'schedule';
  final String _dbExercisesKey = 'exercises';
  final String sessionsKey = 'sessions';
  final String _selectedExercisesKey = 'selectedExercises';
  final String _activeSessionExistsKey = 'sessionStarted';
  final String _currentSessionMillis = 'sessionMillis';
  final String _selectedPartsKey = 'selectedParts';
  final String _sessionPausedKey = 'sessionPaused';
  final String _dbPartsKey = 'parts';
  final String _dbEquipmentKey = 'equipment';

  late Session _session;
  var loggedExercises = <SessionExercise>[];
  late Box<dynamic> _db ;

   late bool timerPaused = false;

  var _timerNotStarted = true;

  var _start = 0;
  static Timer? _timer;

  late LinkedHashMap<DateTime, List<Event>> kEvents;

  /// Example events.
  ///
  /// Using a [LinkedHashMap] is highly recommended if you decide to use a map.


   Event getEventData(item, index) {
    // var rec = getRecommendedWorkoutPartForTheDay();
     var dayInt = index == 0 ? kFirstDay.weekday :
     kFirstDay.weekday + index;
     var recsByDay = getRecommendedWorkoutPartForTheDay(dayInt);

    return Event(recsByDay [index].name, "");
  }

  SessionSvc(Box<dynamic> db){
    _session = Session();
    _db = db;
    _session.exercises = [];

    // testing
     //_delete(sessionsKey);
   // end testing

    if(timerHasNotStarted) {
     _start = 0 ;
    }

    int allyear = 365;
    final _kEventSource = {

      for (var item in List.generate(allyear, (index) => index))
        DateTime.utc(kFirstDay.year, kFirstDay.month, item)
            : List.generate(getNumberOfExercises(item), (index) => getEventData(item, index))
    };

    kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_kEventSource);


  }

  bool get timerHasNotStarted => _timerNotStarted;
  get start => this.getSessionTime();

  void add(SessionExercise exercise) {
    _session.exercises.add(exercise);
  }

  void remove(SessionExercise exercise) {
    if(_session.exercises.contains(exercise)) {
      _session.exercises.remove(exercise);
    }
  }



  void replace(String exerciseId, SessionExercise newExercise) {
    var ex = _session.exercises.firstWhereOrNull((element) => element.id ==
        exerciseId);
    if(ex != null) {
      _session.exercises.add(newExercise);
    }
  }

  void _delete(key){
    _db.delete(key);
  }

  void save(){

    // get the list of old sessions
    var sessions = _db.containsKey(sessionsKey) ? _db.get
      (sessionsKey).cast<Session>() : <Session>[];


      // save the session entries separate for use with detecting last time used
      // the equipment and how much weight/distance/ whatever was used/consumed
     // loggedExercises.forEach((element) {
     //   var name = element.equipment.toString();
     //   _db.put(name, element.name);
     // });

      // save the session to the existing list
    _session.exercises = loggedExercises;
      sessions.add(_session);

      // save the list with the new session added
      _db.put(sessionsKey, sessions);

      // This call tells the widgets that are listening to this model to
    // rebuild.
    notifyListeners();
  }

  getExistingSessionsByPart(String key) async{
    return _db.containsKey(key) ? await _db.get(key) : [];
  }

  List<Part> getRecommendedWorkoutPartForTheDay(dayInteger) {
    var allRec = _db.containsKey(_dbPartRecommendationKey)
        ? _db.get(_dbPartRecommendationKey)
        : [];

    List recs = allRec?.toList();
    var day = getStringDayByDayId(dayInteger);
    var rec = recs
        .firstWhereOrNull((r) => r.day == day);

    var workout = rec?.workout;
    List<Part> partList = [];
    var woList = workout?.toList() ?? [];
    var l = [];
    for(var i = 0; i < parts.length; i++) {
      var p = parts[i];
      var n = p.name;
      if(woList.contains(n.toLowerCase())){
        partList.add(p);
      }
    }
     return partList; // Part.values.firstWhere((e) => e.name == rec.);
  }

  static getStringDayByDayId(id){

    switch(id) {
      case 7:
      return "Sunday";
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return "Monday";
    }
  }

  getAllExercisesByPart(String partName) {
    var results =  _db.containsKey(_dbExercisesKey) ?  _db.get(_dbExercisesKey) : [];
    var resList = [];
    results.forEach((res) => {
      resList.add(Exercise(name: res.name, part: res.part, equipment: res.equipment, history: res.history))
    });
    if(resList.isNotEmpty) {
      var pName = partName.toLowerCase();
      var list =  resList.where((e) => e.part == pName).toList();
      return list;
    }
  }

  getDb(){
    return _db;
  }

  closeDb(){
    if(_db.isOpen) {
      _db.close();
    }
  }

  getLastLoggedSessionForEquipment(name){
    if(_db.containsKey(name)){
      return _db.get(name);
    }
    return {};
  }

  logExercise(SessionExercise exercise) {
    if(!loggedExercises.contains(exercise)) {
      loggedExercises.add(exercise);
    }
  }

  checkIn(){
   // if(_db.containsKey(_sessionStartedKey)){
      _db.put(_activeSessionExistsKey, true);
  //  }
  }

  checkOut(){
    _db.put(_activeSessionExistsKey, false);
    flushSelectedExercises();
  }

  void saveSelectedExercises(List<dynamic> selectedExercises) {
    _db.put(_selectedExercisesKey, selectedExercises);
  }

  List<dynamic> getSelectedExercises() {
   if(_db.containsKey(_selectedExercisesKey)) {
     return _db.get(_selectedExercisesKey);
   }
   return <dynamic>[];
  }

  void flushSelectedExercises(){
    if(_db.containsKey(_selectedExercisesKey)) {
      _db.delete(_selectedExercisesKey);
    }
  }

  void saveSelectedParts(List<dynamic> selectedParts) {
    _db.put(_selectedPartsKey, selectedParts);
  }

  List<dynamic> getSelectedParts() {
    if(_db.containsKey(_selectedPartsKey)) {
      return _db.get(_selectedPartsKey);
    }
    return <dynamic>[];
  }

  bool activeSessionExists() {
    return _db.get(_activeSessionExistsKey) == true;
  }

  @override
  void dispose() {
    checkOut();
    _timer?.cancel();
    super.dispose();
  }

  void saveMillis(millis) {
    _db.put(_currentSessionMillis, millis);
  }

  void startTimer(int timerDuration) {

    _timer?.cancel();

      _start = timerDuration;

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) => {
          if (_start < 0) {
            timer.cancel()
          } else {
            if(timerPaused == false) {
              _start = _start + 1
            }else {
              //paused//
            }
          }
        },

    );
    _timerNotStarted = false;
  }

  void pauseTimer() {
    _timer?.cancel();

  }

  void unpauseTimer() => startTimer(_start);

  bool get isTimerPaused{
    return timerPaused;
  }

  List<Session> getHistoricalTimeline() {
    var result = _db.get(sessionsKey);
    return result?.cast<Session>() ?? <Session>[];
  }

  List<Part> get parts{
    return _db.get(_dbPartsKey).cast<Part>() ?? <Part>[];
  }
  List<Equipment> get  equipment{
    return _db.get(_dbEquipmentKey).cast<Equipment>() ?? <Equipment>[];
  }

  getPartIcon(String partName) {
    return parts.firstWhere((element) => element.name == partName);
  }

  getEquipmentIcon(String ename) {
    return equipment.firstWhere((element) => element.name == ename);
  }

  getSessionTime() {
    return _start;
  }

  static int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }
}

  // ..addAll({
  //   kToday: [
  //     const Event('Back', 'Sunday'),
  //     const Event('Shoulders', 'Sunday'),
  //   ],
  //});

  int getNumberOfExercises(int item) {
    return 2;
}

/// Example event class.
class Event {
  final String title;
  final String day;

  const Event(this.title, this.day);

  @override
  String toString() => title;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);