import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/oeuvre_model.dart';
import 'models/utilisateur_model.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(OeuvreAdapter());
  Hive.registerAdapter(UtilisateurAdapter());
  await Hive.openBox<Oeuvre>('oeuvres');
  await Hive.openBox<Utilisateur>('users');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimeBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
