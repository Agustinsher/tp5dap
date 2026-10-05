import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/player_provider.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key});

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(playerProvider.notifier).getAllPlayers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugadores'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add-player');
        },
        child: const Icon(Icons.add),
      ),
      body: players.isEmpty
          ? const Center(
              child: Text(
                'No hay jugadores',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(player.image),
                      onBackgroundImageError: (_, __) {},
                      child: player.image.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(player.name),
                    subtitle: Text(
                      '${player.team} - ${player.position}',
                    ),
                    onTap: () {
                      context.go(
                        '/player-detail',
                        extra: player,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}