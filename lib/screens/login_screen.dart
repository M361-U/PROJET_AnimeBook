import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();

  bool _chargement = false;
  bool _obscurePassword = true;

  // Définition de la palette de couleurs
  static const Color backgroundColor = Color(0xFF0F111A); // Fond très sombre
  static const Color inputBackgroundColor = Color(
    0xFF1B1D2A,
  ); // Fond des champs
  static const Color primaryOrange = Color(0xFFD6432C); // Rouge/Orange Youmi
  static const Color lightText = Colors.white;
  static const Color mutedText = Color(0xFFA0A5BD); // Texte secondaire
  static const Color borderColor = Color(0xFF2C2F45); // Bordures légères

  @override
  void dispose() {
    _emailController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  Future<void> _seConnecter() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _chargement = true);

    final utilisateur = _authService.connecter(
      email: _emailController.text,
      motDePasse: _motDePasseController.text,
    );

    if (!mounted) return;
    setState(() => _chargement = false);

    if (utilisateur == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("E-mail ou mot de passe incorrect."),
          backgroundColor: primaryOrange,
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(utilisateur: utilisateur)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- En-tête : Logo + Titre ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF231B22),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: primaryOrange.withOpacity(0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryOrange.withOpacity(0.2),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.movie_filter_rounded,
                          size: 28,
                          color: primaryOrange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "AnimeBook",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryOrange,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- Titre de bienvenue ---
                  const Text(
                    "Bon retour !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: lightText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Connectez-vous à votre compte",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: mutedText),
                  ),
                  const SizedBox(height: 36),

                  // --- Champ E-mail ---
                  const Text(
                    "E-mail",
                    style: TextStyle(
                      color: lightText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: lightText),
                    decoration: InputDecoration(
                      hintText: "vous@exemple.com",
                      hintStyle: TextStyle(color: mutedText.withOpacity(0.6)),
                      filled: true,
                      fillColor: inputBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: primaryOrange,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.redAccent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.redAccent,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 20),

                  // --- Champ Mot de passe ---
                  const Text(
                    "Mot de passe",
                    style: TextStyle(
                      color: lightText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _motDePasseController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: lightText),
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      hintStyle: TextStyle(color: mutedText.withOpacity(0.6)),
                      filled: true,
                      fillColor: inputBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: mutedText,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: primaryOrange,
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.redAccent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.redAccent,
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? "Champ requis" : null,
                  ),
                  const SizedBox(height: 28),

                  // --- Bouton Se connecter ---
                  ElevatedButton(
                    onPressed: _chargement ? null : _seConnecter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryOrange,
                      foregroundColor: lightText,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: _chargement
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: lightText,
                            ),
                          )
                        : const Text(
                            "Se connecter",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // --- Séparateur "ou" ---
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(color: borderColor, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "ou",
                          style: TextStyle(color: mutedText, fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: borderColor, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Bouton Créer un compte ---
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: borderColor),
                      backgroundColor: inputBackgroundColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Créer un compte",
                      style: TextStyle(
                        color: lightText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
