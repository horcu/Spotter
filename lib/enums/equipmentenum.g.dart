// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipmentenum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EquipmentEnumAdapter extends TypeAdapter<EquipmentEnum> {
  @override
  final int typeId = 9;

  @override
  EquipmentEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EquipmentEnum.machine;
      case 1:
        return EquipmentEnum.dumbell;
      case 2:
        return EquipmentEnum.barbell;
      case 3:
        return EquipmentEnum.cable;
      case 4:
        return EquipmentEnum.treadmill;
      case 5:
        return EquipmentEnum.elliptical;
      case 6:
        return EquipmentEnum.ball;
      case 7:
        return EquipmentEnum.rope;
      case 8:
        return EquipmentEnum.plate;
      case 9:
        return EquipmentEnum.none;
      case 10:
        return EquipmentEnum.outdoor;
      default:
        return EquipmentEnum.machine;
    }
  }

  @override
  void write(BinaryWriter writer, EquipmentEnum obj) {
    switch (obj) {
      case EquipmentEnum.machine:
        writer.writeByte(0);
        break;
      case EquipmentEnum.dumbell:
        writer.writeByte(1);
        break;
      case EquipmentEnum.barbell:
        writer.writeByte(2);
        break;
      case EquipmentEnum.cable:
        writer.writeByte(3);
        break;
      case EquipmentEnum.treadmill:
        writer.writeByte(4);
        break;
      case EquipmentEnum.elliptical:
        writer.writeByte(5);
        break;
      case EquipmentEnum.ball:
        writer.writeByte(6);
        break;
      case EquipmentEnum.rope:
        writer.writeByte(7);
        break;
      case EquipmentEnum.plate:
        writer.writeByte(8);
        break;
      case EquipmentEnum.none:
        writer.writeByte(9);
        break;
      case EquipmentEnum.outdoor:
        writer.writeByte(10);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
