import 'package:go_router/go_router.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/player_screen.dart';
import 'screens/player_detail_screen.dart';
import 'screens/add_player_screen.dart';

import 'entities/player.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),

    GoRoute(
      path: '/players',
      builder: (context, state) {
        return const PlayerScreen();
      },
    ),

    GoRoute(
      path: '/player-detail',
      builder: (context, state) {
        final player = state.extra as Player;

        return PlayerDetailScreen(
          player: player,
        );
      },
    ),

    GoRoute(
      path: '/add-player',
      builder: (context, state) {
        final player = state.extra as Player?;

        return AddPlayerScreen(
          player: player,
        );
      },
    ),
  ],
);