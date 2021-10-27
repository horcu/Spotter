

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/excercise_entry.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/models/session.dart';

class SessionSvc extends ChangeNotifier {
  final String _dbKey = 'daily_session';
  final String _dbPartRecommendationKey = 'part_day_recommendation';
  final String _dbExercisesKey = 'exercises';
  var key = '';
  late Session _session;
  var _oldSessions = <dynamic>[];
  var loggedExercises = <Exercise>[];
  late Box<dynamic> _db;

  SessionSvc(Box<dynamic> db){
    _session = Session();
    _db = db;
    _session.exerciseEntries = <ExerciseEntry>[];
    key = _dbKey + "_" + _session.part.name;
    _oldSessions =  getExistingSessionsByPart(key);
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
    _oldSessions.add(_session);
    _db.put(key, _oldSessions );

    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  getExistingSessionsByPart(String key) {
    return _db.containsKey(key) ? _db.get(key) : [];
  }

  getRecommendedWorkoutPartForTheDay() {
    var key = _dbPartRecommendationKey;
    var allRec = _db.containsKey(_dbPartRecommendationKey) ? _db.get
      (_dbPartRecommendationKey): [];

    List recs = allRec.toList();
    var rec = recs
        .firstWhereOrNull((r) => r.day == DateTime.now().weekday.toString());

    return rec?.part ?? Part.none;
  }

  List<Exercise> getAllExercisesByPart(String partName) {
    return _db.containsKey(_dbExercisesKey) ? _db.get(_dbExercisesKey) : [];
  }

  logExercise(Exercise exercise) {
    if(!loggedExercises.contains(exercise)) {
      loggedExercises.add(exercise);
    }
  }

  checkIn(){}

  checkOut(){}
}