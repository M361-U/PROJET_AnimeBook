import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/oeuvre_model.dart';
import '../services/oeuvre_service.dart';

class OeuvreFormPage extends StatefulWidget {
  final Oeuvre? oeuvre;

  const OeuvreFormPage({super.key, this.oeuvre});

  @override
  State<OeuvreFormPage> createState() => _OeuvreFormPageState();
}

class _OeuvreFormPageState extends State<OeuvreFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _genreController = TextEditingController();
  final _nombreEpisodesController = TextEditingController();
  final _studioController = TextEditingController();
  final _anneeSortieController = TextEditingController();
  final _commentaireController = TextEditingController();

  String _type = 'Anime';
  String _statut = 'À regarder';
  double _note = 5.0;
  DateTime _dateVisionnage = DateTime.now();
  String? _imagePath;

  final _service = OeuvreService();

  bool get _isEditing => widget.oeuvre != null;
  bool get _isAnime => _type == 'Anime';

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final oeuvre = widget.oeuvre!;
      _titreController.text = oeuvre.titre;
      _type = oeuvre.type;
      _genreController.text = oeuvre.genre;
      _nombreEpisodesController.text = oeuvre.nombreEpisodes?.toString() ?? '';
      _studioController.text = oeuvre.studio ?? '';
      _anneeSortieController.text = oeuvre.anneeSortie.toString();
      _dateVisionnage = oeuvre.dateVisionnage;
      _statut = oeuvre.statut;
      _note = oeuvre.note;
      _commentaireController.text = oeuvre.commentaire;
      _imagePath = oeuvre.imagePath;
    } else {
      _anneeSortieController.text = DateTime.now().year.toString();
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _genreController.dispose();
    _nombreEpisodesController.dispose();
    _studioController.dispose();
    _anneeSortieController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imagePath = pickedImage.path;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateVisionnage,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _dateVisionnage = picked;
      });
    }
  }

  String get _formattedDate {
    return '${_dateVisionnage.year}-${_dateVisionnage.month.toString().padLeft(2, '0')}-${_dateVisionnage.day.toString().padLeft(2, '0')}';
  }

  Future<void> _saveOeuvre() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final titre = _titreController.text.trim();
    final genre = _genreController.text.trim();
    final studio = _studioController.text.trim().isEmpty
        ? null
        : _studioController.text.trim();
    final commentaire = _commentaireController.text.trim();
    final anneeSortie =
        int.tryParse(_anneeSortieController.text.trim()) ?? DateTime.now().year;
    final nombreEpisodes = _isAnime
        ? int.tryParse(_nombreEpisodesController.text.trim())
        : null;

    if (_isEditing) {
      final oeuvre = widget.oeuvre!;
      oeuvre.titre = titre;
      oeuvre.type = _type;
      oeuvre.genre = genre;
      oeuvre.nombreEpisodes = _isAnime ? nombreEpisodes : null;
      oeuvre.studio = studio;
      oeuvre.anneeSortie = anneeSortie;
      oeuvre.dateVisionnage = _dateVisionnage;
      oeuvre.statut = _statut;
      oeuvre.note = _note;
      oeuvre.commentaire = commentaire;
      oeuvre.imagePath = _imagePath;
      await _service.modifierOeuvre(oeuvre);
    } else {
      final oeuvre = Oeuvre(
        titre: titre,
        type: _type,
        genre: genre,
        nombreEpisodes: nombreEpisodes,
        studio: studio,
        anneeSortie: anneeSortie,
        dateVisionnage: _dateVisionnage,
        statut: _statut,
        note: _note,
        commentaire: commentaire,
        imagePath: _imagePath,
      );
      await _service.ajouterOeuvre(oeuvre);
    }

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est requis.';
    }
    return null;
  }

  String? _validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entrez une année.';
    }
    final year = int.tryParse(value.trim());
    if (year == null || year < 1900 || year > DateTime.now().year + 1) {
      return 'Entrez une année valide.';
    }
    return null;
  }

  String? _validateEpisodes(String? value) {
    if (!_isAnime) {
      return null;
    }
    if (value == null || value.trim().isEmpty) {
      return 'Entrez le nombre d’épisodes.';
    }
    final number = int.tryParse(value.trim());
    if (number == null || number <= 0) {
      return 'Entrez un entier positif.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier une œuvre' : 'Ajouter une œuvre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(labelText: 'Titre *'),
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type *'),
                items: const [
                  DropdownMenuItem(value: 'Anime', child: Text('Animé')),
                  DropdownMenuItem(value: 'Film', child: Text('Film')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _type = value;
                    if (!_isAnime) {
                      _nombreEpisodesController.clear();
                    }
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Choisissez un type.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _genreController,
                decoration: const InputDecoration(labelText: 'Genre *'),
                validator: _validateRequired,
              ),
              const SizedBox(height: 16),
              if (_isAnime) ...[
                TextFormField(
                  controller: _nombreEpisodesController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre d’épisodes *',
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateEpisodes,
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _studioController,
                decoration: const InputDecoration(
                  labelText: 'Studio (optionnel)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _anneeSortieController,
                decoration: const InputDecoration(
                  labelText: 'Année de sortie *',
                ),
                keyboardType: TextInputType.number,
                validator: _validateYear,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date de visionnage *',
                      ),
                      child: Text(_formattedDate),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Choisir'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _statut,
                decoration: const InputDecoration(labelText: 'Statut *'),
                items: const [
                  DropdownMenuItem(
                    value: 'À regarder',
                    child: Text('À regarder'),
                  ),
                  DropdownMenuItem(value: 'En cours', child: Text('En cours')),
                  DropdownMenuItem(value: 'Terminé', child: Text('Terminé')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _statut = value;
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Choisissez un statut.'
                    : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Note: ${_note.toStringAsFixed(1)}/10',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Slider(
                value: _note,
                min: 0,
                max: 10,
                divisions: 20,
                label: _note.toStringAsFixed(1),
                onChanged: (value) => setState(() {
                  _note = value;
                }),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentaireController,
                decoration: const InputDecoration(labelText: 'Commentaire'),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              Text(
                'Image de l’œuvre',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: Center(
                  child: _imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_imagePath!),
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade400),
                            color: Colors.grey.shade100,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.photo_library,
                              size: 56,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Choisir une image'),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveOeuvre,
                child: Text(
                  _isEditing
                      ? 'Enregistrer les modifications'
                      : 'Ajouter l’œuvre',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
