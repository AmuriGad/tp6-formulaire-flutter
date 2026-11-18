import 'package:flutter/material.dart';

class App1 extends StatefulWidget {
  const App1({super.key});

  @override
  State<App1> createState() => _App1State();
}

class _App1State extends State<App1> {
  int _longueur = 0;
  final int _longueurMax = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.input_outlined),
        title: const Text("Formulaire sous Flutter"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: TextField(
            maxLength: _longueurMax,
            decoration: InputDecoration(
              hintText: "Donner un texte",
              counterText:
                  'Reste : ${_longueurMax - _longueur}/$_longueurMax caractères.',
            ),
            onChanged: (value) {
              setState(() {
                _longueur = value.length;
              });
            },
          ),
        ),
      ),
    );
  }
}
