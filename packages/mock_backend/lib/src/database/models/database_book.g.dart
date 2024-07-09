// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DatabaseBookAdapter extends TypeAdapter<DatabaseBook> {
  @override
  final int typeId = 0;

  @override
  DatabaseBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DatabaseBook(
      id: fields[0] as int,
      title: fields[1] as String,
      description: fields[3] as String,
      author: fields[2] as String,
      publicationDate: fields[4] as DateTime,
      image: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DatabaseBook obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.publicationDate)
      ..writeByte(5)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatabaseBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
