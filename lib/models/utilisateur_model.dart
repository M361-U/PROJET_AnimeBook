import 'package:hive/hive.dart';

part 'utilisateur_model.g.dart';

@HiveType(typeId: 1)
class Utilisateur extends HiveObject {
  @HiveField(0)
  String nomUtilisateur;

  @HiveField(1)
  String email;

  @HiveField(2)
  String motDePasse;

  Utilisateur({
    required this.nomUtilisateur,
    required this.email,
    required this.motDePasse,
  });
}