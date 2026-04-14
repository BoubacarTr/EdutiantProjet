class Etudiant {
  final int? id; // L'ID est optionnel pour l'ajout
  final String nom;
  final String prenom;
  final String email;

  Etudiant({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Cette méthode est INDISPENSABLE pour ton ApiService
  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // Optionnel mais utile pour l'envoi de données
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }
}