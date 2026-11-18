import 'package:flutter/material.dart';

class CaloriesPage extends StatefulWidget {
  const CaloriesPage({super.key});

  @override
  State<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  // ---------- Formulaire ----------
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();

  String _sexe = "Homme";
  double _coefficient = 1.2;

  // libellé -> coefficient d'activité
  static const Map<String, double> _niveaux = {
    "Sédentaire (peu ou pas d'exercice)": 1.2,
    "Légère (1 à 3 fois par semaine)": 1.375,
    "Modérée (3 à 5 fois par semaine)": 1.55,
    "Intense (6 à 7 fois par semaine)": 1.725,
    "Très intense (travail physique)": 1.9,
  };

  // ---------- Résultats ----------
  double? _bmr;
  double? _calories;
  String _message = "";
  Color _couleur = Colors.blue;

  @override
  void dispose() {
    _ageController.dispose();
    _poidsController.dispose();
    _tailleController.dispose();
    super.dispose();
  }

  // ---------- Logique ----------
  void _calculer() {
    final age = double.tryParse(_ageController.text);
    final poids = double.tryParse(_poidsController.text);
    final taille = double.tryParse(_tailleController.text);
    if (age == null || poids == null || taille == null) return;

    // Formule de Mifflin-St Jeor
    final base = (10 * poids) + (6.25 * taille) - (5 * age);
    final bmr = _sexe == "Homme" ? base + 5 : base - 161;
    final calories = bmr * _coefficient;

    String msg;
    Color couleur;
    if (calories < 1800) {
      msg = "Besoin calorique faible";
      couleur = Colors.blue;
    } else if (calories < 2500) {
      msg = "Besoin calorique moyen";
      couleur = Colors.green;
    } else if (calories < 3200) {
      msg = "Besoin calorique élevé";
      couleur = Colors.orange;
    } else {
      msg = "Besoin calorique très élevé";
      couleur = Colors.red;
    }

    setState(() {
      _bmr = bmr;
      _calories = calories;
      _message = msg;
      _couleur = couleur;
    });
  }

  void _reinitialiser() {
    _formKey.currentState?.reset();
    _ageController.clear();
    _poidsController.clear();
    _tailleController.clear();
    setState(() {
      _sexe = "Homme";
      _coefficient = 1.2;
      _bmr = null;
      _calories = null;
      _message = "";
      _couleur = Colors.blue;
    });
  }

  // ---------- Widgets ----------
  Widget _champ({
    required String label,
    required String unite,
    required TextEditingController controller,
    required double min,
    required double max,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixText: unite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Veuillez saisir : $label";
          }
          final nombre = double.tryParse(value);
          if (nombre == null) return "Nombre invalide";
          if (nombre < min || nombre > max) {
            return "$label doit être entre $min et $max $unite";
          }
          return null;
        },
      ),
    );
  }

  Widget _resultats() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Métabolisme de base",
                style: TextStyle(color: Colors.black54)),
            Text("${_bmr!.round()} kcal",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text("Calories recommandées",
                style: TextStyle(color: Colors.black54)),
            Text("${_calories!.round()} kcal",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _couleur)),
            const SizedBox(height: 8),
            Text(_message,
                style: TextStyle(fontSize: 20, color: _couleur)),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: (_calories! / 4000).clamp(0.0, 1.0).toDouble(),
              minHeight: 16,
              color: _couleur,
              backgroundColor: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 4),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("0"), Text("4000 kcal")],
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Interface ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculateur de Calories"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sexe",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  RadioGroup<String>(
                    groupValue: _sexe,
                    onChanged: (valeur) {
                      setState(() => _sexe = valeur!);
                    },
                    child: const Column(
                      children: [
                        RadioListTile<String>(
                            title: Text("Homme"), value: "Homme"),
                        RadioListTile<String>(
                            title: Text("Femme"), value: "Femme"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _champ(
                      label: "Âge",
                      unite: "ans",
                      controller: _ageController,
                      min: 10,
                      max: 100),
                  _champ(
                      label: "Poids",
                      unite: "kg",
                      controller: _poidsController,
                      min: 20,
                      max: 300),
                  _champ(
                      label: "Taille",
                      unite: "cm",
                      controller: _tailleController,
                      min: 100,
                      max: 250),
                  const Text("Niveau d'activité",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  DropdownButton<double>(
                    isExpanded: true,
                    value: _coefficient,
                    items: _niveaux.entries
                        .map((e) => DropdownMenuItem<double>(
                              value: e.value,
                              child: Text(e.key),
                            ))
                        .toList(),
                    onChanged: (valeur) {
                      setState(() => _coefficient = valeur!);
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _calculer();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Calculer"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _reinitialiser,
                        child: const Text("Réinitialiser"),
                      ),
                    ],
                  ),
                  if (_calories != null) _resultats(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
