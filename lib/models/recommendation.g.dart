// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecommendationAdapter extends TypeAdapter<Recommendation> {
  @override
  final int typeId = 7;

  @override
  Recommendation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recommendation(
      id: fields[0] as String,
      day: fields[1] as String,
      workout: (fields[2] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recommendation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.workout);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
