import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/oeuvre_model.dart';
import 'details_screen.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filtreType = 'Tous';
  String _recherche = '';

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
                decoration: const InputDecoration(
                  hintText: 'Rechercher une œuvre...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _recherche = v.trim().toLowerCase()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _filtreType,
                items: const [
                  DropdownMenuItem(value: 'Tous', child: Text('Tous')),
                  DropdownMenuItem(value: 'Anime', child: Text('Anime')),
                  DropdownMenuItem(value: 'Film', child: Text('Film')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _filtreType = value);
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<Oeuvre>('oeuvres').listenable(),
                  builder: (context, Box<Oeuvre> box, _) {
                    List<Oeuvre> resultats = box.values.toList();

                    if (_recherche.isNotEmpty) {
                      resultats = resultats
                          .where((o) => o.titre.toLowerCase().contains(_recherche))
                          .toList();
                    }
                    if (_filtreType != 'Tous') {
                      resultats = resultats.where((o) => o.type == _filtreType).toList();
                    }

                    if (resultats.isEmpty) {
                      return const Center(
                        child: Text('Aucune œuvre trouvée', style: TextStyle(fontSize: 16)),
                      );
                    }

                    return ListView.builder(
                      itemCount: resultats.length,
                      itemBuilder: (context, index) {
                        final oeuvre = resultats[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(oeuvre: oeuvre),
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.all(14),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFF3B82F6),
                              backgroundImage: (oeuvre.imagePath != null &&
                                      oeuvre.imagePath!.isNotEmpty)
                                  ? NetworkImage(oeuvre.imagePath!, webHtmlElementStrategy: WebHtmlElementStrategy.fallback)
                                  : null,
                              child: (oeuvre.imagePath == null || oeuvre.imagePath!.isEmpty)
                                  ? Text(
                                      oeuvre.titre.isNotEmpty
                                          ? oeuvre.titre[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
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
                                  'Statut : ${oeuvre.statut} • Note : ${oeuvre.note.toStringAsFixed(1)}/10',
                                ),
                                Text('Sortie : ${oeuvre.anneeSortie}'),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        );
                      },
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