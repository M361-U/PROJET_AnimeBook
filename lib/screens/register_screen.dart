import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _confirmationController = TextEditingController();

  bool _chargement = false;
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  // Palette de couleurs identique au LoginScreen
  static const Color backgroundColor = Color(0xFF0F111A);
  static const Color inputBackgroundColor = Color(0xFF1B1D2A);
  static const Color primaryOrange = Color(0xFFD6432C);
  static const Color lightText = Colors.white;
  static const Color mutedText = Color(0xFFA0A5BD);
  static const Color borderColor = Color(0xFF2C2F45);

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _motDePasseController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  Future<void> _sInscrire() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _chargement = true);

    final erreur = await _authService.inscrire(
      nomUtilisateur: _nomController.text,
      email: _emailController.text,
      motDePasse: _motDePasseController.text,
      confirmationMotDePasse: _confirmationController.text,
    );

    if (!mounted) return;
    setState(() => _chargement = false);

    if (erreur != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erreur), backgroundColor: primaryOrange),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Compte créé avec succès ! Connectez-vous."),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  // Helper pour styliser les champs de texte et éviter le code répété
  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: mutedText.withOpacity(0.6)),
      filled: true,
      fillColor: inputBackgroundColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryOrange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: lightText),
        title: const Text(
          "Créer un compte",
          style: TextStyle(color: lightText, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Titre / Sous-titre ---
                const Text(
                  "Rejoignez AnimeBook",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: lightText,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Remplissez les informations pour commencer",
                  style: TextStyle(color: mutedText, fontSize: 14),
                ),
                const SizedBox(height: 28),

                // --- Champ Nom d'utilisateur ---
                const Text(
                  "Nom d'utilisateur",
                  style: TextStyle(
                    color: lightText,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nomController,
                  style: const TextStyle(color: lightText),
                  decoration: _buildInputDecoration(hintText: "ex: Otaku99"),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? "Champ requis" : null,
                ),
                const SizedBox(height: 18),

                // --- Champ E-mail ---
                const Text(
                  "Adresse e-mail",
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
                  decoration: _buildInputDecoration(
                    hintText: "vous@exemple.com",
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Champ requis";
                    if (!v.contains('@')) return "E-mail invalide";
                    return null;
                  },
                ),
                const SizedBox(height: 18),

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
                  decoration: _buildInputDecoration(
                    hintText: "••••••••",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: mutedText,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) => (v == null || v.length < 6)
                      ? "6 caractères minimum"
                      : null,
                ),
                const SizedBox(height: 18),

                // --- Champ Confirmation mot de passe ---
                const Text(
                  "Confirmation du mot de passe",
                  style: TextStyle(
                    color: lightText,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmationController,
                  obscureText: _obscureConfirmation,
                  style: const TextStyle(color: lightText),
                  decoration: _buildInputDecoration(
                    hintText: "••••••••",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmation
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: mutedText,
                      ),
                      onPressed: () => setState(
                        () => _obscureConfirmation = !_obscureConfirmation,
                      ),
                    ),
                  ),
                  validator: (v) => v != _motDePasseController.text
                      ? "Les mots de passe ne correspondent pas"
                      : null,
                ),
                const SizedBox(height: 28),

                // --- Bouton S'inscrire ---
                ElevatedButton(
                  onPressed: _chargement ? null : _sInscrire,
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
                          "S'inscrire",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 20),

                // --- Lien Se connecter ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Vous avez déjà un compte ? ",
                      style: TextStyle(color: mutedText, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: const Text(
                        "Se connecter",
                        style: TextStyle(
                          color: primaryOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
