// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_day_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityDayModelAdapter extends TypeAdapter<ActivityDayModel> {
  @override
  final int typeId = 1;

  @override
  ActivityDayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityDayModel(
      date: fields[0] as DateTime,
      activities: (fields[1] as List).cast<String>(),
      mood: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityDayModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.activities)
      ..writeByte(2)
      ..write(obj.mood);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityDayModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
