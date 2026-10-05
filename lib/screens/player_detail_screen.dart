import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../entities/player.dart';
import '../providers/player_provider.dart';

class PlayerDetailScreen extends ConsumerWidget {
  final Player player;

  const PlayerDetailScreen({
    super.key,
    required this.player,
  });

  void _deletePlayer(BuildContext context, WidgetRef ref) {
    ref.read(playerProvider.notifier).removePlayer(player.id);

    context.go('/players');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deletePlayer(context, ref);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                player.image,
                height: 250,
                width: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 200,
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Text(
              player.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Equipo: ${player.team}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 8),

            Text(
              'Posición: ${player.position}',
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 20),

            Text(
              player.description,
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go(
                    '/add-player',
                    extra: player,
                  );
                },
                child: const Text('Editar jugador'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}