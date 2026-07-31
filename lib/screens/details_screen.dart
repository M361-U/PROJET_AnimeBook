import 'package:flutter/material.dart';
import '../models/oeuvre_model.dart';

class DetailsScreen extends StatelessWidget {
  final Oeuvre oeuvre;

  const DetailsScreen({super.key, required this.oeuvre});

  //  Dialogue de confirmation de suppression
  void _confirmerSuppression(BuildContext context) {
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
            onPressed: () {
              // TODO (Jour 2) : Appeler oeuvreService.supprimerOeuvre(oeuvre.id)
              Navigator.of(ctx).pop(); // Ferme le dialogue
              Navigator.of(context).pop(); // Retourne au catalogue
              
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'œuvre'),
        actions: [
          //  Bouton Modifier
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
            onPressed: () {
              // TODO : Naviguer vers la page de modification (Personne 3)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Redirection vers la modification...')),
              );
            },
          ),
          //  Bouton Supprimer
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
            //  En-tête / Affiche de l'œuvre
            Center(
              child: Container(
                width: 140,
                height: 190,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6C4FE),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
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

            //  Titre principal
            Center(
              child: Text(
                oeuvre.titre,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            //  Badges (Type, Genre, Statut)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(oeuvre.type),
                  backgroundColor: Colors.purple.shade50,
                ),
                Chip(
                  label: Text(oeuvre.genre),
                  backgroundColor: Colors.blue.shade50,
                ),
                Chip(
                  label: Text(oeuvre.statut),
                  backgroundColor: Colors.green.shade50,
                ),
              ],
            ),
            const Divider(height: 32),

            //  Informations détaillées
            const Text(
              'Informations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildInfoRow(Icons.star, 'Note', ' ${oeuvre.note.toStringAsFixed(1)} / 5'),
            _buildInfoRow(Icons.calendar_today, 'Année de sortie', '${oeuvre.anneeSortie}'),
            
            // Si ton modèle contient ces champs, tu peux les décommenter :
            // _buildInfoRow(Icons.tv, 'Épisodes / Durée', oeuvre.episodes ?? 'N/A'),
            // _buildInfoRow(Icons.business, 'Studio', oeuvre.studio ?? 'N/A'),
            // _buildInfoRow(Icons.date_range, 'Date de visionnage', oeuvre.dateVisionnage ?? 'N/A'),
            
            const Divider(height: 32),

            // Section Commentaire
            const Text(
              'Commentaire / Avis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Aucun commentaire ajouté pour le moment.',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper pour afficher proprement chaque ligne d'info
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade700),
          const SizedBox(width: 10),
          Text(
            '$label : ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}