// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartAdapter extends TypeAdapter<Part> {
  @override
  final int typeId = 10;

  @override
  Part read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Part.chest;
      case 1:
        return Part.arm;
      case 2:
        return Part.leg;
      case 3:
        return Part.back;
      case 4:
        return Part.core;
      case 5:
        return Part.glute;
      case 6:
        return Part.cardio;
      case 7:
        return Part.shoulder;
      case 8:
        return Part.none;
      default:
        return Part.chest;
    }
  }

  @override
  void write(BinaryWriter writer, Part obj) {
    switch (obj) {
      case Part.chest:
        writer.writeByte(0);
        break;
      case Part.arm:
        writer.writeByte(1);
        break;
      case Part.leg:
        writer.writeByte(2);
        break;
      case Part.back:
        writer.writeByte(3);
        break;
      case Part.core:
        writer.writeByte(4);
        break;
      case Part.glute:
        writer.writeByte(5);
        break;
      case Part.cardio:
        writer.writeByte(6);
        break;
      case Part.shoulder:
        writer.writeByte(7);
        break;
      case Part.none:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
