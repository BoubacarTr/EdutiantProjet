import 'package:flutter/material.dart';
import 'package:tpetudiant/modele/etudiant.dart';
import 'package:tpetudiant/services/api_service.dart';

class ADD extends StatefulWidget {
  const ADD({super.key});

  @override
  _ADDState createState() => _ADDState();
}

class _ADDState extends State<ADD> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false; // pour afficher un loader

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBDBDBD),
      appBar: AppBar(
        title: const Text('Ajouter un étudiant'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildInput(_nomController, 'Nom'),
                const SizedBox(height: 12),
                _buildInput(_prenomController, 'Prénom'),
                const SizedBox(height: 12),
                _buildInput(_emailController, 'Email'),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _submitForm,
                        child: const Text(
                          'Valider Ajout',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      validator: (value) => value == null || value.isEmpty ? 'Veuillez remplir ce champ' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        Etudiant etudiant = Etudiant(
          id: 0, // l'ID sera généré par le backend
          nom: _nomController.text,
          prenom: _prenomController.text,
          email: _emailController.text,
        );

        await ApiService.addEtudiant(etudiant);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Étudiant ajouté avec succès !')),
        );

        _nomController.clear();
        _prenomController.clear();
        _emailController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}