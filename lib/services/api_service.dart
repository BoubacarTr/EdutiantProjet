import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tpetudiant/modele/etudiant.dart';

class ApiService {
  // URL de ton backend Spring Boot
  static const String baseUrl = 'http://10.0.2.2:8080/api/etudiants';

  // Récupérer tous les étudiants
  static Future<List<Etudiant>> getEtudiants() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Etudiant.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des étudiants');
    }
  }

  // Ajouter un étudiant
  static Future<Etudiant> addEtudiant(Etudiant etudiant) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': etudiant.nom,
        'prenom': etudiant.prenom,
        'email': etudiant.email,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Etudiant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de l’ajout de l’étudiant');
    }
  }

  // Modifier un étudiant
  static Future<Etudiant> updateEtudiant(Etudiant etudiant) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${etudiant.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': etudiant.nom,
        'prenom': etudiant.prenom,
        'email': etudiant.email,
      }),
    );
    if (response.statusCode == 200) {
      return Etudiant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la mise à jour de l’étudiant');
    }
  }

  // Supprimer un étudiant
  static Future<void> deleteEtudiant(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la suppression de l’étudiant');
    }
  }
}