
import 'package:hive/hive.dart';
part 'schedule.g.dart';

@HiveType(typeId: 7)
class Schedule {
  @HiveField(0)
  String id;
  @HiveField(1)
  String day;
  @HiveField(2)
  var workout;

  Schedule({required this.id, required this.day, required this.workout});

  Schedule._({required this.id, required this.day, required this.workout});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule._(
      id: json['id'],
      day: json['day'],
      workout: json['workout'],
    );
  }
}