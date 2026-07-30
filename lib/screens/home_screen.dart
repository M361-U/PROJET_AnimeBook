import 'package:flutter/material.dart';
import '../models/utilisateur_model.dart';
import '../services/oeuvre_service.dart';

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

  // Palette de couleurs globale du projet
  static const Color backgroundColor = Color(0xFF0F111A);
  static const Color cardBackgroundColor = Color(0xFF1B1D2A);
  static const Color primaryOrange = Color(0xFFD6432C);
  static const Color lightText = Colors.white;
  static const Color mutedText = Color(0xFFA0A5BD);
  static const Color borderColor = Color(0xFF2C2F45);

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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primaryOrange.withOpacity(0.5)),
              ),
              child: const Icon(
                Icons.movie_filter_rounded,
                color: primaryOrange,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "AnimeBook",
              style: TextStyle(
                color: lightText,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Message de bienvenue ---
              Text(
                "Bonjour, ${widget.utilisateur.nomUtilisateur} 👋",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: lightText,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Voici un aperçu de votre carnet d'otaku",
                style: TextStyle(color: mutedText, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // --- Cartes de statistiques ---
              Row(
                children: [
                  Expanded(
                    child: _CarteStat(
                      titre: "Animés",
                      valeur: _nombreAnimes.toString(),
                      icone: Icons.tv_rounded,
                      couleurIcone: primaryOrange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _CarteStat(
                      titre: "Films",
                      valeur: _nombreFilms.toString(),
                      icone: Icons.movie_rounded,
                      couleurIcone: const Color(
                        0xFFE88A3C,
                      ), // Teinte orangée secondaire
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Card Dernier ajout ---
              Container(
                decoration: BoxDecoration(
                  color: cardBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryOrange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.new_releases_outlined,
                      color: primaryOrange,
                    ),
                  ),
                  title: const Text(
                    "Dernier ajout",
                    style: TextStyle(
                      color: lightText,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    _dernierAjout ?? "Aucune œuvre pour l'instant",
                    style: const TextStyle(color: mutedText, fontSize: 13),
                  ),
                ),
              ),

              const Spacer(),

              // --- Bouton Ajouter une œuvre ---
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: naviguer vers l'écran d'ajout d'œuvre
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  "Ajouter une œuvre",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryOrange,
                  foregroundColor: lightText,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
              ),
              const SizedBox(height: 12),

              // --- Bouton Voir le catalogue ---
              OutlinedButton.icon(
                onPressed: () {
                  // TODO: naviguer vers l'écran du catalogue
                },
                icon: const Icon(Icons.grid_view_rounded, color: lightText),
                label: const Text(
                  "Voir le catalogue",
                  style: TextStyle(
                    color: lightText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: borderColor),
                  backgroundColor: cardBackgroundColor.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
  final Color couleurIcone;

  static const Color cardBackgroundColor = Color(0xFF1B1D2A);
  static const Color lightText = Colors.white;
  static const Color mutedText = Color(0xFFA0A5BD);
  static const Color borderColor = Color(0xFF2C2F45);

  const _CarteStat({
    required this.titre,
    required this.valeur,
    required this.icone,
    required this.couleurIcone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: couleurIcone.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icone, color: couleurIcone, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            valeur,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: lightText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titre,
            style: const TextStyle(
              color: mutedText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
