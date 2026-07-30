import 'package:hive/hive.dart';
import '../models/oeuvre_model.dart';

class OeuvreService {
  final Box<Oeuvre> _box = Hive.box<Oeuvre>('oeuvres');

  Future<void> ajouterOeuvre(Oeuvre oeuvre) async {
    await _box.add(oeuvre);
  }

  List<Oeuvre> getToutesLesOeuvres() {
    return _box.values.toList();
  }

  Oeuvre? getOeuvreParCle(dynamic key) {
    return _box.get(key);
  }

  Future<void> modifierOeuvre(Oeuvre oeuvre) async {
    await oeuvre.save(); // HiveObject connaît sa propre clé
  }

  Future<void> supprimerOeuvre(Oeuvre oeuvre) async {
    await oeuvre.delete();
  }

  List<Oeuvre> rechercherParTitre(String texte) {
    if (texte.isEmpty) return getToutesLesOeuvres();
    final texteMinuscule = texte.toLowerCase();
    return _box.values
        .where((o) => o.titre.toLowerCase().contains(texteMinuscule))
        .toList();
  }

  List<Oeuvre> filtrerParType(String type) {
    return _box.values.where((o) => o.type == type).toList();
  }

  List<Oeuvre> filtrerParGenre(String genre) {
    return _box.values.where((o) => o.genre == genre).toList();
  }

  List<Oeuvre> filtrerParStatut(String statut) {
    return _box.values.where((o) => o.statut == statut).toList();
  }

  int compterAnimes() {
    return _box.values.where((o) => o.type == 'Anime').length;
  }

  int compterFilms() {
    return _box.values.where((o) => o.type == 'Film').length;
  }

  Oeuvre? getDerniereOeuvreAjoutee() {
    if (_box.isEmpty) return null;
    return _box.values.last;
  }

  // --- Alias pour le tableau de bord (Personne 4) ---
  // Ajoutés pour correspondre aux noms prévus dans le cahier des charges
  // du dashboard. Ils appellent simplement les fonctions déjà existantes
  // ci-dessus, sans dupliquer la logique.

  int nombreAnimes() => compterAnimes();

  int nombreFilms() => compterFilms();

  Oeuvre? derniereOeuvreAjoutee() => getDerniereOeuvreAjoutee();
}
