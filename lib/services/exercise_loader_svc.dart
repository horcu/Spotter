
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:spotter/models/exercise.dart';
import 'package:spotter/models/recommendation.dart';
import 'package:uuid/uuid.dart';

class ExerciseLoader {

  final String _dbExercisesKey = 'exercises';
  final String _dbRecommendationsKey = 'recommendations';
  late Box _db;
  var exList;
  var recommendations;

  ExerciseLoader(Box<dynamic> db){
    _db = db;
  }

  seedDb() async {
    try {
      loadExercisesFromJson();
      loadRecommendationsFromJson();

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

  saveExercisesToDb(){
  // if(!_db.containsKey(_dbExercisesKey)) {
      _db.put(_dbExercisesKey, exList);
  // }
  }

  saveRecommendationToDb(){
  // if(!_db.containsKey(_dbRecommendationsKey)){
      _db.put(_dbRecommendationsKey, recommendations);
 //  }
  }

  Future getExercisesFromJsonList() async {
    final String response = await rootBundle.loadString('_json/exercises.json');
    return await json.decode(response)["exercises"].map((data) => Exercise.fromJson(data))
        .toList();
  }

  Future getRecommendationsFromJsonList() async {
    final String response = await rootBundle.loadString('_json/recommendation.json');
    return await json.decode(response)["recommedations"].map((data) => Recommendation.fromJson(data))
        .toList();
  }

  assignId(li) {
    var id = const Uuid();
    li.id = id;
  }

}