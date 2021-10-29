import 'package:hive/hive.dart';

part 'part.g.dart';

@HiveType(typeId: 10)
enum Part {
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
  none
}

extension PartExtension on Part {

  String get name {
    switch (this) {
      case Part.chest:
        return 'Chest';
      case Part.back:
        return 'Back';
      case Part.arm:
        return 'Arm';
      case Part.core:
        return 'Core';
      case Part.leg:
        return 'Leg';
      case Part.glute:
        return 'Glute';
      case Part.cardio:
        return 'Cardio';
      default:
        return 'None';
    }
  }

}