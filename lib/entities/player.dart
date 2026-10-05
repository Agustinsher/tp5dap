import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String id;
  final String name;
  final String description;
  final String image;
  final String team;
  final String position;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final String status;

  Player({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.team,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  // Convierte un Player en datos para guardar en Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'team': team,
      'position': position,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }

  // Convierte los datos de Firebase en un Player
  static Player fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Player(
      id: data?['id'] ?? '',
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      image: data?['image'] ?? '',
      team: data?['team'] ?? '',
      position: data?['position'] ?? '',
      createdAt: data?['createdAt'] ?? Timestamp.now(),
      updatedAt: data?['updatedAt'] ?? Timestamp.now(),
      status: data?['status'] ?? 'enabled',
    );
  }
}