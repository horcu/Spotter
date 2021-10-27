
enum Equipment {
  machine,
  dumbell,
  barbell,
  cable,
  treadmill,
  eliptical,
  other
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
      default:
        return 'Other';
    }
  }

}