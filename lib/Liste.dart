import 'package:flutter/material.dart';
import 'package:tpetudiant/modele/etudiant.dart';
import 'package:tpetudiant/services/api_service.dart';
import 'package:tpetudiant/services/EditEtudiantPage.dart';

class Liste extends StatefulWidget {
  const Liste({super.key});

  @override
  _ListeState createState() => _ListeState();
}

class _ListeState extends State<Liste> {
  late Future<List<Etudiant>> _etudiantsFuture;

  @override
  void initState() {
    super.initState();
    _loadEtudiants();
  }

  void _loadEtudiants() {
    _etudiantsFuture = ApiService.getEtudiants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liste des étudiants")),
      body: FutureBuilder<List<Etudiant>>(
        future: _etudiantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun étudiant"));
          }

          final etudiants = snapshot.data!;
          return ListView.builder(
            itemCount: etudiants.length,
            itemBuilder: (context, index) {
              final etudiant = etudiants[index];
              return Card(
                child: ListTile(
                  title: Text('${etudiant.nom} ${etudiant.prenom}'),
                  subtitle: Text(etudiant.email),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✏️ Modifier
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditEtudiantPage(etudiant: etudiant),
                            ),
                          ).then((_) => setState(_loadEtudiants));
                        },
                      ),

                      // 🗑️ Supprimer
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          if (etudiant.id != null) {
                            await ApiService.deleteEtudiant(etudiant.id!);
                            setState(_loadEtudiants);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}