import 'package:hive_flutter/hive_flutter.dart';

part 'equipment.g.dart';

@HiveType(typeId: 18)
class Equipment {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon;

  @HiveField(3)
  String color;

  Equipment({required this.id, required this.name, required this.icon, required this.color});
  Equipment._({required this.id, required this.name, required this.icon, required this.color});

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment._(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
    );
  }
}