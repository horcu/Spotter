// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EquipmentAdapter extends TypeAdapter<Equipment> {
  @override
  final int typeId = 9;

  @override
  Equipment read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Equipment.machine;
      case 1:
        return Equipment.dumbell;
      case 2:
        return Equipment.barbell;
      case 3:
        return Equipment.cable;
      case 4:
        return Equipment.treadmill;
      case 5:
        return Equipment.eliptical;
      case 6:
        return Equipment.ball;
      case 7:
        return Equipment.none;
      default:
        return Equipment.machine;
    }
  }

  @override
  void write(BinaryWriter writer, Equipment obj) {
    switch (obj) {
      case Equipment.machine:
        writer.writeByte(0);
        break;
      case Equipment.dumbell:
        writer.writeByte(1);
        break;
      case Equipment.barbell:
        writer.writeByte(2);
        break;
      case Equipment.cable:
        writer.writeByte(3);
        break;
      case Equipment.treadmill:
        writer.writeByte(4);
        break;
      case Equipment.eliptical:
        writer.writeByte(5);
        break;
      case Equipment.ball:
        writer.writeByte(6);
        break;
      case Equipment.none:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
