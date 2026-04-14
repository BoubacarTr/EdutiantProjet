import 'package:flutter/material.dart';
import 'package:tpetudiant/modele/etudiant.dart';
import 'package:tpetudiant/services/api_service.dart';

class EditEtudiantPage extends StatefulWidget {
  final Etudiant etudiant;

  const EditEtudiantPage({super.key, required this.etudiant});

  @override
  State<EditEtudiantPage> createState() => _EditEtudiantPageState();
}

class _EditEtudiantPageState extends State<EditEtudiantPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.etudiant.nom);
    prenomController = TextEditingController(text: widget.etudiant.prenom);
    emailController = TextEditingController(text: widget.etudiant.email);
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> updateEtudiant() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Créer un nouvel objet Etudiant avec les valeurs modifiées
        Etudiant updatedEtudiant = Etudiant(
          id: widget.etudiant.id,
          nom: nomController.text,
          prenom: prenomController.text,
          email: emailController.text,
        );

        // Appeler la méthode du service
        await ApiService.updateEtudiant(updatedEtudiant);

        // Revenir à la page précédente
        Navigator.pop(context);
      } catch (e) {
        // Afficher une erreur si la mise à jour échoue
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la mise à jour : $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier étudiant")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nom
              TextFormField(
                controller: nomController,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le nom";
                  }
                  return null;
                },
              ),

              // Prénom
              TextFormField(
                controller: prenomController,
                decoration: const InputDecoration(labelText: "Prénom"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le prénom";
                  }
                  return null;
                },
              ),

              // Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer l'email";
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Veuillez entrer un email valide";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Bouton de modification
              ElevatedButton(
                onPressed: updateEtudiant,
                child: const Text("Modifier"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}