import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/create_room_screen.dart';
import 'screens/join_room_screen.dart';
import 'screens/game_screen.dart';
import 'screens/result_screen.dart';
import 'screens/solo_game_screen.dart';

void main() {
  runApp(const ImpostorApp());
}

class ImpostorApp extends StatelessWidget {
  const ImpostorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'El Impostor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/create', builder: (context, state) => const CreateRoomScreen()),
          GoRoute(path: '/join', builder: (context, state) => const JoinRoomScreen()),
          GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
          GoRoute(path: '/result', builder: (context, state) => const ResultScreen()),
          GoRoute(path: '/solo', builder: (context, state) => const SoloGameScreen()),
        ],
      ),
    );
  }
}