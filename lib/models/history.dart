
import 'package:hive/hive.dart';

part 'history.g.dart';

@HiveType(typeId: 13)
class History {

  @HiveField(0)
  var weight;
  @HiveField(1)
  var rep;
  @HiveField(2)
  var distance;
  @HiveField(3)
  var duration;
  @HiveField(4)
  var date;
  @HiveField(5)
  var equipment;

  History({this.equipment, this.date, this.distance, this.duration, this.rep, this.weight});
  History._({this.equipment, this.date, this.distance, this.duration, this.rep, this.weight});

  factory History.fromJson(Map<String, dynamic> json) {
    return History._(
        weight: json['weight'],
        rep: json['rep'],
        distance: json['duration'],
        duration: json['duration'],
        date: json['date'],
        equipment: json['equipment'],

    );
  }
}