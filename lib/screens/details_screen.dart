import 'package:flutter/material.dart';
import '../models/oeuvre_model.dart';
import '../services/oeuvre_service.dart';
import 'oeuvre_form_page.dart';

class DetailsScreen extends StatelessWidget {
  final Oeuvre oeuvre;

  const DetailsScreen({super.key, required this.oeuvre});

  void _confirmerSuppression(BuildContext context) {
    final oeuvreService = OeuvreService();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer "${oeuvre.titre}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await oeuvreService.supprimerOeuvre(oeuvre);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${oeuvre.titre} a été supprimé')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = oeuvre.imagePath != null && oeuvre.imagePath!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'œuvre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OeuvreFormPage(oeuvre: oeuvre)),
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            tooltip: 'Supprimer',
            onPressed: () => _confirmerSuppression(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 140,
                height: 190,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: hasImage
                    ? Image.network(oeuvre.imagePath!, fit: BoxFit.cover,webHtmlElementStrategy: WebHtmlElementStrategy.fallback,)
                    : Center(
                        child: Text(
                          oeuvre.titre.isNotEmpty ? oeuvre.titre[0].toUpperCase() : '?',
                          style: const TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                oeuvre.titre,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(oeuvre.type)),
                Chip(label: Text(oeuvre.genre)),
                Chip(label: Text(oeuvre.statut)),
              ],
            ),
            const Divider(height: 32),
            const Text('Informations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildInfoRow(context, Icons.star, 'Note', '${oeuvre.note.toStringAsFixed(1)} / 10'),
            _buildInfoRow(context, Icons.calendar_today, 'Année de sortie', '${oeuvre.anneeSortie}'),
            if (oeuvre.nombreEpisodes != null)
              _buildInfoRow(context, Icons.tv, 'Nombre d\'épisodes', '${oeuvre.nombreEpisodes}'),
            if (oeuvre.studio != null && oeuvre.studio!.isNotEmpty)
              _buildInfoRow(context, Icons.business, 'Studio', oeuvre.studio!),
            _buildInfoRow(
              context,
              Icons.date_range,
              'Date de visionnage',
              '${oeuvre.dateVisionnage.day}/${oeuvre.dateVisionnage.month}/${oeuvre.dateVisionnage.year}',
            ),
            const Divider(height: 32),
            const Text('Commentaire / Avis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                oeuvre.commentaire.isNotEmpty
                    ? oeuvre.commentaire
                    : 'Aucun commentaire ajouté pour le moment.',
                style: TextStyle(
                  fontStyle: oeuvre.commentaire.isNotEmpty ? FontStyle.normal : FontStyle.italic,
                  color: oeuvre.commentaire.isNotEmpty ? Colors.white : Colors.white54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.white54),
          const SizedBox(width: 10),
          Text('$label : ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}