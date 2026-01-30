import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/lobby_screen.dart';

/// Route names for type-safe navigation
class AppRoutes {
  static const String lobby = 'lobby';
  static const String reader = 'reader';
  static const String galaxy = 'galaxy';
}

/// GoRouter configuration for The Focus Butler
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: AppRoutes.lobby,
      path: '/',
      builder: (context, state) => const LobbyScreen(),
    ),
    GoRoute(
      name: AppRoutes.reader,
      path: '/reader/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? 'unknown';
        return ReaderPlaceholder(id: id);
      },
    ),
    GoRoute(
      name: AppRoutes.galaxy,
      path: '/galaxy',
      builder: (context, state) => const GalaxyPlaceholder(),
    ),
  ],
);

/// Placeholder screen for Lobby route
class LobbyPlaceholder extends StatelessWidget {
  const LobbyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Lobby',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome to The Focus Butler',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder screen for Reader route
class ReaderPlaceholder extends StatelessWidget {
  const ReaderPlaceholder({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reader')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Reader',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Reading document: $id',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder screen for Galaxy route
class GalaxyPlaceholder extends StatelessWidget {
  const GalaxyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galaxy')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.stars_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Galaxy',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Explore your knowledge universe',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
