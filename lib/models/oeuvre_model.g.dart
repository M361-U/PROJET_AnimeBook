// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oeuvre_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OeuvreAdapter extends TypeAdapter<Oeuvre> {
  @override
  final int typeId = 0;

  @override
  Oeuvre read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Oeuvre(
      titre: fields[0] as String,
      type: fields[1] as String,
      genre: fields[2] as String,
      nombreEpisodes: fields[3] as int?,
      studio: fields[4] as String?,
      anneeSortie: fields[5] as int,
      dateVisionnage: fields[6] as DateTime,
      statut: fields[7] as String,
      note: fields[8] as double,
      commentaire: fields[9] as String,
      imagePath: fields[10] as String?,
    )..idUtilisateur = fields[11] as String?;
  }

  @override
  void write(BinaryWriter writer, Oeuvre obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.titre)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.genre)
      ..writeByte(3)
      ..write(obj.nombreEpisodes)
      ..writeByte(4)
      ..write(obj.studio)
      ..writeByte(5)
      ..write(obj.anneeSortie)
      ..writeByte(6)
      ..write(obj.dateVisionnage)
      ..writeByte(7)
      ..write(obj.statut)
      ..writeByte(8)
      ..write(obj.note)
      ..writeByte(9)
      ..write(obj.commentaire)
      ..writeByte(10)
      ..write(obj.imagePath)
      ..writeByte(11)
      ..write(obj.idUtilisateur);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OeuvreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
