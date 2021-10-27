import 'package:hive/hive.dart';
import 'package:spotter/enums/equipment.dart';
import 'package:spotter/enums/part.dart';
import 'package:spotter/models/exercise.dart';

@HiveType(typeId: 1)
class ExerciseEntry {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final Exercise exercise;


  ExerciseEntry({
    required this.id,
    required this.exercise,
  });

  getlastLogged(){
    // get this info from the database
  }
}
