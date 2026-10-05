import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../entities/player.dart';

class PlayerNotifier extends StateNotifier<List<Player>> {
  PlayerNotifier() : super([]);

  // Trae todos los jugadores desde Firebase
  Future<void> getAllPlayers() async {
    final db = FirebaseFirestore.instance;

    final docs = db.collection('players').withConverter<Player>(
      fromFirestore: Player.fromFirestore,
      toFirestore: (Player player, options) {
        return player.toFirestore();
      },
    );

    // Traemos todos los documentos de la colección players
    final playersSnapshot = await docs.get();

    // Convertimos los documentos de Firebase en objetos Player
    final players = playersSnapshot.docs
        .map((doc) => doc.data())
        .where((player) => player.status == 'enabled')
        .toList();

    // Actualizamos el estado de Riverpod
    state = players;
  }

  // Agrega un jugador a la lista
  void addPlayer(Player player) {
    state = [...state, player];
  }

  // Actualiza un jugador
  void updatePlayer(Player updatedPlayer) {
    state = [
      for (final p in state)
        if (p.id == updatedPlayer.id) updatedPlayer else p
    ];
  }

  // Elimina un jugador de la lista
  void removePlayer(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

// Provider global que contiene la lista de jugadores
final playerProvider =
    StateNotifierProvider<PlayerNotifier, List<Player>>((ref) {
  return PlayerNotifier();
});