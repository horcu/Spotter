import 'package:hive/hive.dart';

part "equipmentenum.g.dart";

@HiveType(typeId: 9)
enum EquipmentEnum {
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
  elliptical,
  @HiveField(6)
  ball,
  @HiveField(7)
  rope,
  @HiveField(8)
  plate,
  @HiveField(9)
  none,
@HiveField(10)
outdoor
}

extension EquipmentExtension on EquipmentEnum {
  String get name {
    switch (this) {
      case EquipmentEnum.barbell:
        return 'Barbell';
      case EquipmentEnum.cable:
        return 'Cable';
      case EquipmentEnum.dumbell:
        return 'Dumbell';
      case EquipmentEnum.elliptical:
        return 'Elliptical';
      case EquipmentEnum.machine:
        return 'Machine';
      case EquipmentEnum.treadmill:
        return 'Treadmill';
      case EquipmentEnum.ball:
        return 'Ball';
      case EquipmentEnum.rope:
        return 'Rope';
      case EquipmentEnum.plate:
        return 'Plate';
      case EquipmentEnum.outdoor:
        return 'Outdoor';
      default:
        return 'None';
    }
  }
}
