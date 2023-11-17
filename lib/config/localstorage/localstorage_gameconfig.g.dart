// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localstorage_gameconfig.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalStorageGameConfigAdapter
    extends TypeAdapter<LocalStorageGameConfig> {
  @override
  final int typeId = 0;

  @override
  LocalStorageGameConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalStorageGameConfig(
      fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalStorageGameConfig obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.menuScoreLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalStorageGameConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
