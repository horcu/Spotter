
import 'package:hive/hive.dart';
import 'package:spotter/enums/part.dart';

part 'recommendation.g.dart';

@HiveType(typeId: 7)
class Recommendation {

  @HiveField(0)
  String day;
  @HiveField(1)
  var workout = [];

  Recommendation({required this.day, required this.workout});

  Recommendation._({required this.day, required this.workout});

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation._(
      day: json['day'],
      workout: json['workout'],
    );
  }
}