import 'package:hive/hive.dart';

part "equipment.g.dart";

@HiveType(typeId: 9)
enum Equipment {
  @HiveField(0)
  machine,
  @HiveField(1)
  dumbell,
  @HiveField(2)
  barbell,
  @HiveField(3)
  cable,
  @HiveField(4)
  treadmill,
  @HiveField(5)
  eliptical,
  @HiveField(6)
  ball,
  @HiveField(7)
  none
}

extension EquipmentExtension on Equipment {
  String get name {
    switch (this) {
      case Equipment.barbell:
        return 'Barbell';
      case Equipment.cable:
        return 'Cable';
      case Equipment.dumbell:
        return 'Dumbell';
      case Equipment.eliptical:
        return 'Eliptical';
      case Equipment.machine:
        return 'Machine';
      case Equipment.treadmill:
        return 'Treadmill';
      case Equipment.ball:
        return 'Ball';
      default:
        return 'None';
    }
  }
}
