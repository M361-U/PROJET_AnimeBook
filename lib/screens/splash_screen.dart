import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Constantes de la palette de couleurs du projet
  static const Color backgroundColor = Color(0xFF0F111A);
  static const Color primaryOrange = Color(0xFFD6432C);
  static const Color lightText = Colors.white;
  static const Color mutedText = Color(0xFFA0A5BD);

  @override
  void initState() {
    super.initState();
    _redirigerVersConnexion();
  }

  Future<void> _redirigerVersConnexion() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Icône avec conteneur stylisé et lueur ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1D2A),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: primaryOrange.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrange.withOpacity(0.3),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.movie_filter_rounded,
                  size: 64,
                  color: primaryOrange,
                ),
              ),
              const SizedBox(height: 28),

              // --- Titre AnimeBook ---
              const Text(
                "AnimeBook",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: lightText,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),

              // --- Tagline / Sous-titre ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Votre carnet personnel d'animés et de films",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: mutedText, height: 1.4),
                ),
              ),
              const SizedBox(height: 48),

              // --- Indicateur de chargement discret ---
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    primaryOrange.withOpacity(0.8),
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
