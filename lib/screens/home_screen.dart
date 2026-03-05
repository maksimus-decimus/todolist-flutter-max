import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green.shade600,
              ),
              const SizedBox(height: 24),
              Text(
                '¡Autenticación exitosa!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Bienvenido/a',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? 'Usuario',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: () => authService.signOut(),
                icon: const Icon(Icons.logout),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Cerrar sesión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
