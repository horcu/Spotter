
import 'package:hive/hive.dart';
import 'package:spotter/enums/equipment.dart';
import 'package:spotter/enums/part.dart';

part 'session_exercise.g.dart';

@HiveType(typeId: 0)
class SessionExercise {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  int weight;
  @HiveField(3)
  final int recommendedWeight;
  @HiveField(4)
  final String lastRep;
  @HiveField(5)
  String rep;
  @HiveField(6)
  final DateTime date;
  @HiveField(7)
  final int lastWeight;
  @HiveField(8)
  bool  increased;
  @HiveField(9)
  final List<dynamic> equipment;
  @HiveField(10)
  final Part part;
  @HiveField(11)
  final int? duration;


  SessionExercise(
      this.id,
      this.name,
      this.weight,
      this.recommendedWeight,
      this.lastRep,
      this.rep,
      this.date,
      this.lastWeight,
      this.increased,
      this.equipment,
      this.part,
      this.duration);

}