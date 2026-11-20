import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String name;
  final String team;
  final String position;
  final String description;
  final String imageUrl;

  Player({
    this.id = '',
    required this.name,
    required this.team,
    required this.position,
    this.description = '',
    this.imageUrl = '',
  });

  // Convierte un documento de Firestore en un objeto Player
  factory Player.fromFirestore(
    DocumentSnapshot snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data() as Map<String, dynamic>?;
    return Player(
      id: snapshot.id,
      name: data?['name'] ?? '',
      team: data?['team'] ?? '',
      position: data?['position'] ?? '',
      description: data?['description'] ?? '',
      imageUrl: data?['imageUrl'] ?? '',
    );
  }

  // Convierte un objeto Player en un Map para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'team': team,
      'position': position,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}