import 'package:flutter/material.dart';
import '../models/oeuvre_model.dart';
import '../services/oeuvre_service.dart';
import 'details_screen.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final OeuvreService _oeuvreService = OeuvreService();
  final TextEditingController _searchController = TextEditingController();

  List<Oeuvre> _toutesLesOeuvres = [];
  List<Oeuvre> _oeuvresAffichees = [];
  String _filtreType = 'Tous';

  @override
  void initState() {
    super.initState();
    _chargerOeuvres();
  }

  void _chargerOeuvres() {
    setState(() {
      _toutesLesOeuvres = _oeuvreService.getToutesLesOeuvres();
      _appliquerFiltres();
    });
  }

  void _appliquerFiltres() {
    List<Oeuvre> resultats = List.from(_toutesLesOeuvres);

    final recherche = _searchController.text.trim().toLowerCase();
    if (recherche.isNotEmpty) {
      resultats = resultats.where((oeuvre) {
        return oeuvre.titre.toLowerCase().contains(recherche);
      }).toList();
    }

    if (_filtreType != 'Tous') {
      resultats = resultats.where((oeuvre) => oeuvre.type == _filtreType).toList();
    }

    setState(() {
      _oeuvresAffichees = resultats;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher une œuvre...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (_) => _appliquerFiltres(),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _filtreType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                items: const [
                  DropdownMenuItem(value: 'Tous', child: Text('Tous')),
                  DropdownMenuItem(value: 'Anime', child: Text('Anime')),
                  DropdownMenuItem(value: 'Film', child: Text('Film')),
                  DropdownMenuItem(value: 'Série', child: Text('Série')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _filtreType = value;
                    });
                    _appliquerFiltres();
                  }
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _oeuvresAffichees.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune œuvre trouvée',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _oeuvresAffichees.length,
                        itemBuilder: (context, index) {
                          final oeuvre = _oeuvresAffichees[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ListTile(return Card(
  // ... tes propriétés existantes ...
  child: ListTile(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(oeuvre: oeuvre),
        ),
      );
    },
    // ... le reste de ton ListTile (leading, title, subtitle...) ...
  ),
);
                              contentPadding: const EdgeInsets.all(14),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundColor: const Color(0xFF6C4FE0),
                                child: Text(
                                  oeuvre.titre.isNotEmpty
                                      ? oeuvre.titre[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                oeuvre.titre,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('${oeuvre.type} • ${oeuvre.genre}'),
                                  Text(
                                    'Statut : ${oeuvre.statut} • Note : ${oeuvre.note.toStringAsFixed(1)}/5',
                                  ),
                                  Text('Sortie : ${oeuvre.anneeSortie}'),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
