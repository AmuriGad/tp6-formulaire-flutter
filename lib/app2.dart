import 'package:flutter/material.dart';

class App2 extends StatefulWidget {
  const App2({super.key});

  @override
  State<App2> createState() => _App2State();
}

class _App2State extends State<App2> {
  final TextEditingController _nombre1Controller = TextEditingController();
  final TextEditingController _nombre2Controller = TextEditingController();
  int somme = 0;

  void calculerSomme() {
    int nombre1 = int.tryParse(_nombre1Controller.text) ?? 0;
    int nombre2 = int.tryParse(_nombre2Controller.text) ?? 0;
    setState(() {
      somme = nombre1 + nombre2;
    });
  }

  @override
  void dispose() {
    _nombre1Controller.dispose();
    _nombre2Controller.dispose();
    super.dispose();
  }

  Widget _champ(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.add_box_rounded),
        title: const Text("Somme de deux nombres"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _champ("Nombre 1", _nombre1Controller),
            const SizedBox(height: 20),
            _champ("Nombre 2", _nombre2Controller),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculerSomme,
              child: const Text("Calculer la somme"),
            ),
            const SizedBox(height: 20),
            Text(
              "Résultat : $somme",
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
