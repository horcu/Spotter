import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/excercise_entry.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/models/session_exercise.dart';
import 'package:spotter/models/session.dart';
import 'package:spotter/widgets/sessionbar.dart';

class SessionSvc extends ChangeNotifier {
  final String _dbKey = 'daily_session';
  final String _dbPartRecommendationKey = 'recommendations';
  final String _dbExercisesKey = 'exercises';
  final String sessionsKey = 'sessions';
  final String _selectedExercisesKey = 'selectedExercises';
  final String _activeSessionExistsKey = 'sessionStarted';
  final String _selectedPartsKey = 'selectedParts';
  var _sessionPausedKey = 'sessionPaused';

  late Session _session;
  var _oldSessions = [];
  var loggedExercises = <SessionExercise>[];
  late Box<dynamic> _db ;
  late SessionBar _bar = SessionBar();



  SessionSvc(Box<dynamic> db){
    _session = Session();
    _db = db;
    _session.exerciseEntries = <ExerciseEntry>[];
    _bar = SessionBar();

  }

  void add(ExerciseEntry exercise) {
    _session.exerciseEntries.add(exercise);
  }

  void remove(ExerciseEntry exercise) {
    if(_session.exerciseEntries.contains(exercise)) {
      _session.exerciseEntries.remove(exercise);
    }
  }

  void replace(String exerciseId, ExerciseEntry newExercise) {
    var ex = _session.exerciseEntries.firstWhereOrNull((element) => element.id ==
        exerciseId);
    if(ex != null) {
      _session.exerciseEntries.add(newExercise);
    }
  }

  void save(){
   // _oldSessions.add(_session);
   // _db.put(key, _oldSessions );

    // save the session entries separate for use with detecting last time used
    // the equipment and how much weight/distance/ whatever was used/consumed
    _session.exerciseEntries.forEach((element) {
      var name = element.exercise.equipment.toString();
      _db.put(name, element.exercise);
    });

    // save the session separate
    _db.put(sessionsKey, _session);

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  getExistingSessionsByPart(String key) async{
    return _db.containsKey(key) ? await _db.get(key) : [];
  }

  getRecommendedWorkoutPartForTheDay() {
    var allRec = _db.containsKey(_dbPartRecommendationKey)
        ? _db.get(_dbPartRecommendationKey)
        : [];

    List recs = allRec?.toList();
    var day = getStringDayByDayId(DateTime.now().weekday);
    var rec = recs
        .firstWhereOrNull((r) => r.day == day);

    var workout = rec?.workout;
    List<Part> partList = [];
    var woList = workout?.toList() ?? [];
    var l = [];
    for(var i = 0; i< Part.values.length; i++) {
      var p = Part.values[i];
      var n = p.name;
      if(woList.contains(n.toLowerCase())){
        partList.add(p);
      }
    }
     return partList; // Part.values.firstWhere((e) => e.name == rec.);
  }

  getStringDayByDayId(id){

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
    super.dispose();
  }

  SessionBar getSessionBar() {
   return _bar;
  }

  toggleTimer(){
    return _db.put(_sessionPausedKey, !_db.get(_sessionPausedKey, defaultValue:
        false)) ;
  }
}