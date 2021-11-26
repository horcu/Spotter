// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partenum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartEnumAdapter extends TypeAdapter<PartEnum> {
  @override
  final int typeId = 10;

  @override
  PartEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PartEnum.chest;
      case 1:
        return PartEnum.arm;
      case 2:
        return PartEnum.leg;
      case 3:
        return PartEnum.back;
      case 4:
        return PartEnum.core;
      case 5:
        return PartEnum.glute;
      case 6:
        return PartEnum.cardio;
      case 7:
        return PartEnum.shoulder;
      case 8:
        return PartEnum.none;
      default:
        return PartEnum.chest;
    }
  }

  @override
  void write(BinaryWriter writer, PartEnum obj) {
    switch (obj) {
      case PartEnum.chest:
        writer.writeByte(0);
        break;
      case PartEnum.arm:
        writer.writeByte(1);
        break;
      case PartEnum.leg:
        writer.writeByte(2);
        break;
      case PartEnum.back:
        writer.writeByte(3);
        break;
      case PartEnum.core:
        writer.writeByte(4);
        break;
      case PartEnum.glute:
        writer.writeByte(5);
        break;
      case PartEnum.cardio:
        writer.writeByte(6);
        break;
      case PartEnum.shoulder:
        writer.writeByte(7);
        break;
      case PartEnum.none:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
