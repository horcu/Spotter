// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excercise_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseEntryAdapter extends TypeAdapter<ExerciseEntry> {
  @override
  final int typeId = 1;

  @override
  ExerciseEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseEntry(
      id: fields[0] as String,
      exercise: fields[1] as SessionExercise,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.exercise);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
