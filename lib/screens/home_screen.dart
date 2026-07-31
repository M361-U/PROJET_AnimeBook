import 'package:flutter/material.dart';
import '../models/utilisateur_model.dart';
import '../services/oeuvre_service.dart';
import 'oeuvre_form_page.dart';
import 'catalogue_screen.dart';

class HomeScreen extends StatefulWidget {
  final Utilisateur utilisateur;

  const HomeScreen({super.key, required this.utilisateur});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _oeuvreService = OeuvreService();

  int _nombreAnimes = 0;
  int _nombreFilms = 0;
  String? _dernierAjout;

  @override
  void initState() {
    super.initState();
    _chargerStatistiques();
  }

  void _chargerStatistiques() {
    setState(() {
      _nombreAnimes = _oeuvreService.nombreAnimes();
      _nombreFilms = _oeuvreService.nombreFilms();
      _dernierAjout = _oeuvreService.derniereOeuvreAjoutee()?.titre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AnimeBook")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bonjour, ${widget.utilisateur.nomUtilisateur} 👋",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _CarteStat(
                      titre: "Animés",
                      valeur: _nombreAnimes.toString(),
                      icone: Icons.tv_rounded,
                      couleur: const Color(0xFF6C4FE0),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _CarteStat(
                      titre: "Films",
                      valeur: _nombreFilms.toString(),
                      icone: Icons.movie_rounded,
                      couleur: const Color(0xFFE0854F),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.new_releases_outlined),
                  title: const Text("Dernier ajout"),
                  subtitle: Text(
                    _dernierAjout ?? "Aucune œuvre pour l'instant",
                  ),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OeuvreFormPage()),
    );
    _chargerStatistiques();
  },
  icon: const Icon(Icons.add),
  label: const Text("Ajouter une œuvre"),
  style: FilledButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14),
  ),
),
const SizedBox(height: 12),
OutlinedButton.icon(
  onPressed: () async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CatalogueScreen()),
    );
    _chargerStatistiques();
  },
  icon: const Icon(Icons.grid_view_rounded),
  label: const Text("Voir le catalogue"),
  style: OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14),
  ),
),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarteStat extends StatelessWidget {
  final String titre;
  final String valeur;
  final IconData icone;
  final Color couleur;

  const _CarteStat({
    required this.titre,
    required this.valeur,
    required this.icone,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: couleur.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: couleur, size: 28),
            const SizedBox(height: 8),
            Text(
              valeur,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: couleur,
              ),
            ),
            Text(titre, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
