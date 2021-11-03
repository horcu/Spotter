import 'package:hive_flutter/hive_flutter.dart';

part 'part.g.dart';

@HiveType(typeId: 17)
class Part {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon;

  Part({required this.id, required this.name, required this.icon});
  Part._({required this.id, required this.name, required this.icon});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part._(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
    );
  }
}