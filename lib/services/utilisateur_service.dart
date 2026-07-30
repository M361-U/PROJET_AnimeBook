import 'package:hive/hive.dart';
import '../models/utilisateur_model.dart';

class UtilisateurService {
  final Box<Utilisateur> _box = Hive.box<Utilisateur>('users');

  Future<String?> inscrire(Utilisateur utilisateur) async {
    
    final emailExiste = _box.values
        .any((u) => u.email.toLowerCase() == utilisateur.email.toLowerCase());

    if (emailExiste) {
      return "Cet e-mail est déjà utilisé.";
    }

    await _box.add(utilisateur);
    return null; 
  }

  
  Utilisateur? connecter(String email, String motDePasse) {
    try {
      return _box.values.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.toLowerCase() &&
            u.motDePasse == motDePasse,
      );
    } catch (e) {
      return null; 
    }
  }

  
  bool emailExiste(String email) {
    return _box.values.any((u) => u.email.toLowerCase() == email.toLowerCase());
  }
}