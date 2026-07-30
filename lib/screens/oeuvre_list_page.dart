import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/oeuvre_model.dart';
import 'oeuvre_form_page.dart';

class OeuvreListPage extends StatelessWidget {
  const OeuvreListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Oeuvre>('oeuvres');

    return Scaffold(
      appBar: AppBar(title: const Text('Mes œuvres')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Oeuvre> oeuvres, child) {
          if (oeuvres.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Aucune œuvre pour l’instant. Appuyez sur + pour ajouter une œuvre.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final keys = oeuvres.keys.cast<dynamic>().toList();
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: keys.length,
            separatorBuilder: (context, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final key = keys[index];
              final oeuvre = oeuvres.get(key);
              if (oeuvre == null) {
                return const SizedBox.shrink();
              }
              return Card(
                child: ListTile(
                  leading: oeuvre.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(oeuvre.imagePath!),
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey.shade200,
                          ),
                          child: const Icon(Icons.movie, color: Colors.grey),
                        ),
                  title: Text(oeuvre.titre),
                  subtitle: Text('${oeuvre.type} • ${oeuvre.genre}'),
                  trailing: const Icon(Icons.edit),
                  onTap: () async {
                    final result = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => OeuvreFormPage(oeuvre: oeuvre),
                      ),
                    );
                    if (result == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Modifications enregistrées.'),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const OeuvreFormPage()),
          );
          if (result == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Œuvre ajoutée avec succès.')),
            );
          }
        },
      ),
    );
  }
}
