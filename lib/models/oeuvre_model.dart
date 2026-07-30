import 'package:hive/hive.dart';

part 'oeuvre_model.g.dart';

@HiveType(typeId: 0)
class Oeuvre extends HiveObject {
  @HiveField(0)
  String titre;

  @HiveField(1)
  String type; 

  @HiveField(2)
  String genre;

  @HiveField(3)
  int? nombreEpisodes;
  @HiveField(4)
  String? studio;

  @HiveField(5)
  int anneeSortie;

  @HiveField(6)
  DateTime dateVisionnage;

  @HiveField(7)
  String statut; 

  @HiveField(8)
  double note; 

  @HiveField(9)
  String commentaire;

  @HiveField(10)
  String? imagePath; 
  Oeuvre({
    required this.titre,
    required this.type,
    required this.genre,
    this.nombreEpisodes,
    this.studio,
    required this.anneeSortie,
    required this.dateVisionnage,
    required this.statut,
    required this.note,
    required this.commentaire,
    this.imagePath,
  });

  @HiveField(11)
  String? idUtilisateur;
}