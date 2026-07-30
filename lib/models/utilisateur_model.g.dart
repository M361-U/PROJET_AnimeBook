// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'utilisateur_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UtilisateurAdapter extends TypeAdapter<Utilisateur> {
  @override
  final int typeId = 1;

  @override
  Utilisateur read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Utilisateur(
      nomUtilisateur: fields[0] as String,
      email: fields[1] as String,
      motDePasse: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Utilisateur obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nomUtilisateur)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.motDePasse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UtilisateurAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
