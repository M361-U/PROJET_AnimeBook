import 'package:hive/hive.dart';
import '../models/utilisateur_model.dart';

/// Service d'authentification local, indépendant de l'UI (testable seul,
/// comme le service Oeuvre de la Personne 1).
class AuthService {
  static const String boxName = 'users';

  Box<Utilisateur> get _box => Hive.box<Utilisateur>(boxName);

  /// Utilisateur actuellement connecté (null si personne n'est connecté).
  Utilisateur? utilisateurConnecte;

  /// Inscription. Retourne un message d'erreur (String) si échec,
  /// ou null si l'inscription a réussi.
  Future<String?> inscrire({
    required String nomUtilisateur,
    required String email,
    required String motDePasse,
    required String confirmationMotDePasse,
  }) async {
    if (nomUtilisateur.trim().isEmpty ||
        email.trim().isEmpty ||
        motDePasse.isEmpty) {
      return "Tous les champs sont obligatoires.";
    }

    if (motDePasse != confirmationMotDePasse) {
      return "Les mots de passe ne correspondent pas.";
    }

    if (motDePasse.length < 6) {
      return "Le mot de passe doit contenir au moins 6 caractères.";
    }

    final dejaUtilise = _box.values.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );
    if (dejaUtilise) {
      return "Un compte existe déjà avec cet e-mail.";
    }

    final nouvelUtilisateur = Utilisateur(
      nomUtilisateur: nomUtilisateur.trim(),
      email: email.trim(),
      motDePasse: motDePasse,
    );

    await _box.add(nouvelUtilisateur);
    return null;
  }

  /// Connexion. Retourne l'utilisateur si succès, null si échec.
  Utilisateur? connecter({required String email, required String motDePasse}) {
    try {
      final utilisateur = _box.values.firstWhere(
        (u) =>
            u.email.toLowerCase() == email.trim().toLowerCase() &&
            u.motDePasse == motDePasse,
      );
      utilisateurConnecte = utilisateur;
      return utilisateur;
    } catch (e) {
      return null;
    }
  }

  void deconnecter() {
    utilisateurConnecte = null;
  }
}
