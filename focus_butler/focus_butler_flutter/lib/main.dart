import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_butler_client/focus_butler_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'core/router.dart';
import 'core/theme.dart';

/// Serverpod Client provider for dependency injection
final clientProvider = Provider<Client>((ref) {
  // Server URL - change this to your server's IP when running on physical device
  const serverUrl = 'http://localhost:8080/';

  final client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  return client;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: FocusButlerApp(),
    ),
  );
}

/// The Focus Butler - A neuro-inclusive reading companion
class FocusButlerApp extends ConsumerWidget {
  const FocusButlerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the client (this ensures it's created)
    ref.watch(clientProvider);

    return MaterialApp.router(
      title: 'The Focus Butler',
      debugShowCheckedModeBanner: false,
      theme: FocusButlerTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
