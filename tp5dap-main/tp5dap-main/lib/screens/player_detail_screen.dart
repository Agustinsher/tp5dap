import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../entities/player.dart';
import '../providers/player_provider.dart';

class PlayerDetailScreen extends ConsumerWidget {
  final Player player;

  const PlayerDetailScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController(text: player.name);
    final teamController = TextEditingController(text: player.team);
    final positionController = TextEditingController(text: player.position);
    final descriptionController =
        TextEditingController(text: player.description);
    final imageUrlController = TextEditingController(text: player.imageUrl);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Jugador')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (player.imageUrl.isNotEmpty)
              Image.network(
                player.imageUrl,
                height: 150,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 80),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: teamController,
              decoration: const InputDecoration(labelText: 'Equipo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: positionController,
              decoration: const InputDecoration(labelText: 'Posición'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'URL de la imagen'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final updatedPlayer = Player(
                  id: player.id,
                  name: nameController.text,
                  team: teamController.text,
                  position: positionController.text,
                  description: descriptionController.text,
                  imageUrl: imageUrlController.text,
                );
                await ref
                    .read(playersProvider.notifier)
                    .updatePlayer(updatedPlayer);
                if (context.mounted) {
                  context.pop();
                }
              },
              child: const Text('Guardar cambios'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await ref.read(playersProvider.notifier).deletePlayer(player.id);
                if (context.mounted) {
                  context.pop();
                }
              },
              child: const Text('Eliminar jugador'),
            ),
          ],
        ),
      ),
    );
  }
}