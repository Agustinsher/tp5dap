import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/player_provider.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugadores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await logoutUser(ref);
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: players.isEmpty
          ? const Center(child: Text('No hay jugadores'))
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  leading: player.imageUrl.isNotEmpty
                      ? Image.network(
                          player.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, size: 40),
                        )
                      : const Icon(Icons.person, size: 40),
                  title: Text(player.name),
                  subtitle: Text('${player.team} - ${player.position}'),
                  onTap: () => context.push('/player-detail', extra: player),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      ref.read(playersProvider.notifier).deletePlayer(player.id);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-player'),
        child: const Icon(Icons.add),
      ),
    );
  }
}