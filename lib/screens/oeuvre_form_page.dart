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
  final _service = OeuvreService();

  late TextEditingController _titreController;
  late TextEditingController _genreController;
  late TextEditingController _episodesController;
  late TextEditingController _studioController;
  late TextEditingController _anneeController;
  late TextEditingController _commentaireController;

  String _type = "Anime";
  String _statut = "A regarder";
  double _note = 5;
  DateTime _dateVisionnage = DateTime.now();
  String? _imagePath;

  bool get _estModification => widget.oeuvre != null;

  @override
  void initState() {
    super.initState();
    final o = widget.oeuvre;
    _titreController = TextEditingController(text: o?.titre ?? "");
    _genreController = TextEditingController(text: o?.genre ?? "");
    _episodesController = TextEditingController(text: o?.nombreEpisodes?.toString() ?? "");
    _studioController = TextEditingController(text: o?.studio ?? "");
    _anneeController = TextEditingController(text: o?.anneeSortie.toString() ?? "");
    _commentaireController = TextEditingController(text: o?.commentaire ?? "");

    if (o != null) {
      _type = o.type;
      _statut = o.statut;
      _note = o.note;
      _dateVisionnage = o.dateVisionnage;
      _imagePath = o.imagePath;
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _genreController.dispose();
    _episodesController.dispose();
    _studioController.dispose();
    _anneeController.dispose();
    _commentaireController.dispose();
    super.dispose();
  }

  Future<void> _choisirImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imagePath = image.path);
    }
  }

  Future<void> _choisirDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateVisionnage,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _dateVisionnage = date);
    }
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;

    if (_estModification) {
      final o = widget.oeuvre!;
      o.titre = _titreController.text;
      o.type = _type;
      o.genre = _genreController.text;
      o.nombreEpisodes = _episodesController.text.isNotEmpty
          ? int.tryParse(_episodesController.text)
          : null;
      o.studio = _studioController.text.isNotEmpty ? _studioController.text : null;
      o.anneeSortie = int.parse(_anneeController.text);
      o.dateVisionnage = _dateVisionnage;
      o.statut = _statut;
      o.note = _note;
      o.commentaire = _commentaireController.text;
      o.imagePath = _imagePath;
      await _service.modifierOeuvre(o);
    } else {
      final nouvelleOeuvre = Oeuvre(
        titre: _titreController.text,
        type: _type,
        genre: _genreController.text,
        nombreEpisodes: _episodesController.text.isNotEmpty
            ? int.tryParse(_episodesController.text)
            : null,
        studio: _studioController.text.isNotEmpty ? _studioController.text : null,
        anneeSortie: int.parse(_anneeController.text),
        dateVisionnage: _dateVisionnage,
        statut: _statut,
        note: _note,
        commentaire: _commentaireController.text,
        imagePath: _imagePath,
      );
      await _service.ajouterOeuvre(nouvelleOeuvre);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_estModification ? "Modifier l'oeuvre" : "Ajouter une oeuvre"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: GestureDetector(
                onTap: _choisirImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF1E2230),
                  backgroundImage: _imagePath != null ? NetworkImage(_imagePath!, webHtmlElementStrategy: WebHtmlElementStrategy.fallback) : null,
                  child: _imagePath == null
                      ? const Icon(Icons.add_a_photo, size: 30, color: Colors.white54)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _titreController,
              decoration: const InputDecoration(labelText: "Titre"),
              validator: (v) => (v == null || v.isEmpty) ? "Titre requis" : null,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: "Type"),
              items: const [
                DropdownMenuItem(value: "Anime", child: Text("Anime")),
                DropdownMenuItem(value: "Film", child: Text("Film")),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _genreController,
              decoration: const InputDecoration(labelText: "Genre"),
              validator: (v) => (v == null || v.isEmpty) ? "Genre requis" : null,
            ),
            const SizedBox(height: 12),

            if (_type == "Anime") ...[
              TextFormField(
                controller: _episodesController,
                decoration: const InputDecoration(labelText: "Nombre d'episodes"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
            ],

            TextFormField(
              controller: _studioController,
              decoration: const InputDecoration(labelText: "Studio (optionnel)"),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _anneeController,
              decoration: const InputDecoration(labelText: "Annee de sortie"),
              keyboardType: TextInputType.number,
              validator: (v) => (v == null || v.isEmpty) ? "Annee requise" : null,
            ),
            const SizedBox(height: 12),

            Card(
              child: ListTile(
                title: const Text("Date de visionnage"),
                subtitle: Text(
                    "${_dateVisionnage.day}/${_dateVisionnage.month}/${_dateVisionnage.year}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: _choisirDate,
              ),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              initialValue: _statut,
              decoration: const InputDecoration(labelText: "Statut"),
              items: const [
                DropdownMenuItem(value: "A regarder", child: Text("A regarder")),
                DropdownMenuItem(value: "En cours", child: Text("En cours")),
                DropdownMenuItem(value: "Termine", child: Text("Termine")),
              ],
              onChanged: (v) => setState(() => _statut = v!),
            ),
            const SizedBox(height: 12),

            Text("Note : ${_note.toStringAsFixed(1)} / 10"),
            Slider(
              value: _note,
              min: 0,
              max: 10,
              divisions: 20,
              label: _note.toStringAsFixed(1),
              onChanged: (v) => setState(() => _note = v),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _commentaireController,
              decoration: const InputDecoration(labelText: "Commentaire"),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: _enregistrer,
              child: Text(_estModification ? "Enregistrer les modifications" : "Ajouter"),
            ),
          ],
        ),
      ),
    );
  }
}