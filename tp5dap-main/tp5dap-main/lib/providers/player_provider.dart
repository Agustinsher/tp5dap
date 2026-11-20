import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/player.dart';

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier() : super([]) {
    loadPlayers();
  }

  // Conexión a la colección "players" de Firestore
  final _docs =
      FirebaseFirestore.instance.collection('players').withConverter<Player>(
            fromFirestore: Player.fromFirestore,
            toFirestore: (player, _) => player.toFirestore(),
          );

  // Trae los jugadores de Firebase (si está vacío, crea 2 iniciales)
  Future<void> loadPlayers() async {
    final snapshot = await _docs.get();

    if (snapshot.docs.isEmpty) {
      await _docs.add(
        Player(
          name: 'Lionel Messi',
          team: 'Inter Miami',
          position: 'Delantero',
          description:
              'El mejor jugador del mundo. Ganó 8 Balones de Oro, 1 Mundial, 4 Champions League y 2 Copas América.',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/b/b4/Lionel-Messi-Argentina-2022-FIFA-World-Cup_%28cropped%29.jpg',
        ),
      );
      await _docs.add(
        Player(
          name: 'Emiliano Martínez',
          team: 'Aston Villa',
          position: 'Arquero',
          description:
              'Arquero campeón del mundo con Argentina. Ganó 2 Copas América, 1 Finalissima y 2 premios The Best.',
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/6/6d/Emiliano_Mart%C3%ADnez_2021.jpg',
        ),
      );
      final newSnapshot = await _docs.get();
      state = newSnapshot.docs.map((doc) => doc.data()).toList();
      return;
    }

    state = snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Agrega un jugador nuevo
  Future<void> addPlayer(Player player) async {
    await _docs.add(player);
    await loadPlayers();
  }

  // Edita un jugador existente
  Future<void> updatePlayer(Player player) async {
    await _docs.doc(player.id).set(player);
    await loadPlayers();
  }

  // Borra un jugador por su id
  Future<void> deletePlayer(String id) async {
    await _docs.doc(id).delete();
    await loadPlayers();
  }
}

final playersProvider =
    StateNotifierProvider<PlayersNotifier, List<Player>>((ref) {
  return PlayersNotifier();
});