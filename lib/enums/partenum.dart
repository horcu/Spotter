import 'package:hive/hive.dart';

part 'partenum.g.dart';

@HiveType(typeId: 10)
enum PartEnum {
@HiveField(0)
  chest,
@HiveField(1)
  arm,
@HiveField(2)
  leg,
@HiveField(3)
  back,
@HiveField(4)
  core,
@HiveField(5)
 glute,
@HiveField(6)
 cardio,
@HiveField(7)
shoulder,
@HiveField(8)
  none
}

extension PartExtension on PartEnum {

  String get name {
    switch (this) {
      case PartEnum.chest:
        return 'Chest';
      case PartEnum.back:
        return 'Back';
      case PartEnum.arm:
        return 'Arm';
      case PartEnum.core:
        return 'Core';
      case PartEnum.leg:
        return 'Leg';
      case PartEnum.glute:
        return 'Glute';
      case PartEnum.shoulder:
        return 'Shoulder';
      case PartEnum.cardio:
        return 'Cardio';
      default:
        return 'None';
    }
  }

}