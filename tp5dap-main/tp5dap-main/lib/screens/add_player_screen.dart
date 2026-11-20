import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../entities/player.dart';
import '../providers/player_provider.dart';

class AddPlayerScreen extends ConsumerWidget {
  const AddPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final teamController = TextEditingController();
    final positionController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageUrlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Jugador')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
                final newPlayer = Player(
                  name: nameController.text,
                  team: teamController.text,
                  position: positionController.text,
                  description: descriptionController.text,
                  imageUrl: imageUrlController.text,
                );
                await ref.read(playersProvider.notifier).addPlayer(newPlayer);
                if (context.mounted) {
                  context.pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}