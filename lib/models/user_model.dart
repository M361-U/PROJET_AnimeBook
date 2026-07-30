import 'package:hive/hive.dart';

//part '../screens/user_model.g.dart';

// ⚠️ typeId: 1 -> à adapter si le modèle Oeuvre de la Personne 1
// utilise déjà le typeId 1. Chaque @HiveType doit avoir un typeId UNIQUE
// dans tout le projet (Oeuvre = 0 normalement, User = 1).
@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  String nomUtilisateur;

  @HiveField(1)
  String email;

  @HiveField(2)
  String motDePasse;

  UserModel({
    required this.nomUtilisateur,
    required this.email,
    required this.motDePasse,
  });
}
