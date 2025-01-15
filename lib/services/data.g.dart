// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveDataBaseAdapter extends TypeAdapter<HiveDataBase> {
  @override
  final int typeId = 1;

  @override
  HiveDataBase read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveDataBase(
      currentSongIndex: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveDataBase obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.currentSongIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveDataBaseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
