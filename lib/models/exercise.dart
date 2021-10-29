
import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 6)
class Exercise {
  @HiveField(3)
  var id;
  @HiveField(0)
  var name;
  @HiveField(1)
  var part;
  @HiveField(2)
  var equipment;

  Exercise({this.name, this.part, this.equipment, this.id});

  Exercise._({this.name, this.part, this.equipment, this.id});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise._(
      name: json['name'],
      part: json['part'],
      equipment: json['equipment']
    );
  }
}

