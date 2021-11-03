
import 'package:hive/hive.dart';
import 'package:spotter/enums/partenum.dart';

part 'recommendation.g.dart';

@HiveType(typeId: 7)
class Recommendation {
  @HiveField(0)
  String id;
  @HiveField(1)
  String day;
  @HiveField(2)
  var workout = [];

  Recommendation({required this.id, required this.day, required this.workout});

  Recommendation._({required this.id, required this.day, required this.workout});

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation._(
      id: json['id'],
      day: json['day'],
      workout: json['workout'],
    );
  }
}