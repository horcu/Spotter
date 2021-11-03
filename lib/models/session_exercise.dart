
import 'package:hive/hive.dart';
import 'package:spotter/models/equipment.dart';
import 'package:spotter/models/part.dart';

part 'session_exercise.g.dart';

@HiveType(typeId: 0)
class SessionExercise {
  @HiveField(0)
  String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  int weight;
  @HiveField(3)
  final int recommendedWeight;
  @HiveField(4)
  String lastRep;
  @HiveField(5)
  String rep;
  @HiveField(6)
  final DateTime date;
  @HiveField(7)
  int lastWeight;
  @HiveField(8)
  bool  increased;
  @HiveField(9)
  List<Equipment> equipment;
  @HiveField(10)
  Part part;
  @HiveField(11)
  int duration;
  @HiveField(12)
  int lastDuration;
  @HiveField(13)
  double distance;
  @HiveField(14)
  double lastDistance;
  @HiveField(15)
  List<dynamic>? history;
  @HiveField(16)
  String equipmentUsed;

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
      this.duration,
      this.lastDuration,
      this.distance,
      this.lastDistance,
      this.history,
      this.equipmentUsed
      );

}