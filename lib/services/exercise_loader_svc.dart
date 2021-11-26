
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:spotter/models/equipment.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/models/part.dart';
import 'package:spotter/models/schedule.dart';
import 'package:uuid/uuid.dart';

class ExerciseLoader extends ChangeNotifier {

  final String _dbExercisesKey = 'exercises';
  final String _dbScheduleKey = 'schedule';
  final String _dbPartsKey = 'parts';
  final String _dbEquipmentKey = 'equipment';
  final String _dbSessionsKey = 'sessions';
  final String _selectedExercisesKey = 'selectedExercises';
  final String _activeSessionExistsKey = 'sessionStarted';
  final String _currentSessionMillis = 'sessionMillis';
  final String _selectedPartsKey = 'selectedParts';
  final String _sessionPausedKey = 'sessionPaused';

  late Box _db;
  var exList;
  var recommendations;
  var parts;
  var equipment;

  ExerciseLoader(Box<dynamic> db){
    _db = db;
  }

  Future seedDb() async {
    try {
     // deleteAllFromDb();
      await loadRecommendationsFromJson();
      await loadExercisesFromJson();
      await loadPartsFromJson();
      await loadEquipmentFromJson();

    } catch (e) {
      print(e);
    }
  }

  loadExercisesFromJson()  {
    var id = '';
    return getExercisesFromJsonList()
        .then((value) => exList = value)
    .then((value) => {
      exList.toList().forEach((li) =>  assignId(li))
    })
    .then((value) => saveExercisesToDb());
  }

  loadRecommendationsFromJson() {
    return getRecommendationsFromJsonList()
        .then((value) => recommendations = value)
        .then((value) => saveRecommendationToDb());
  }

  loadPartsFromJson() {
    return getPartsFromJsonList()
        .then((value) => parts = value)
        .then((value) => savePartsToDb());
  }

  loadEquipmentFromJson() {
    return getEquipmentFromJsonList()
        .then((value) => equipment = value)
        .then((value) => saveEquipmentToDb());
  }

  saveExercisesToDb(){
  // if(!_db.containsKey(_dbExercisesKey)) {
      _db.put(_dbExercisesKey, exList);
  // }
  }

  saveRecommendationToDb(){
  // if(!_db.containsKey(_dbRecommendationsKey)){
      _db.put(_dbScheduleKey, recommendations);
 //  }
  }

  savePartsToDb() {
    // if(!_db.containsKey(_dbPartsKey)){
    _db.put(_dbPartsKey, parts);
    //  }
  }

  saveEquipmentToDb(){
    // if(!_db.containsKey(_dbEquipmentKey)){
    _db.put(_dbEquipmentKey, equipment);
    //  }
  }



  Future getExercisesFromJsonList() async {
    final String response = await rootBundle.loadString('_json/exercises.json');
    return await json.decode(response)["exercises"].map((data) => Exercise.fromJson(data))
        .toList();
  }

  Future getRecommendationsFromJsonList() async {
    final String response = await rootBundle.loadString('_json/schedule.json');
    return await json.decode(response)["schedule"].map((data) => Schedule
        .fromJson(data))
        .toList();
  }

  Future getEquipmentFromJsonList() async {
    final String response = await rootBundle.loadString('_json/equipment.json');
    return await json.decode(response)["equipment"].map((data) => Equipment.fromJson(data))
        .toList();
  }

  Future getPartsFromJsonList() async {
    final String response = await rootBundle.loadString('_json/parts.json');
    return await json.decode(response)["parts"].map((data) => Part.fromJson(data))
        .toList();
  }
  assignId(li) {
    li.id = const Uuid().v1();
  }

  void deleteAllFromDb() {
    _db.delete(_dbExercisesKey);
    _db.delete(_dbEquipmentKey);
    _db.delete(_dbPartsKey);
    _db.delete(_dbScheduleKey);
    _db.delete(_dbSessionsKey);
    _db.delete(_selectedExercisesKey);
    _db.delete(_activeSessionExistsKey);
    _db.delete(_currentSessionMillis);
    _db.delete(_selectedExercisesKey);
    _db.delete(_sessionPausedKey);
  }
}