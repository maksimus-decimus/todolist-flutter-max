import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Widget de diagnóstico para verificar Firebase Storage
/// Úsalo temporalmente para verificar que Firebase Storage está configurado correctamente
class StorageDiagnostic extends StatelessWidget {
  const StorageDiagnostic({super.key});

  Future<Map<String, dynamic>> _checkStorageStatus() async {
    final results = <String, dynamic>{};
    
    try {
      // Verificar autenticación
      final user = FirebaseAuth.instance.currentUser;
      results['authenticated'] = user != null;
      results['userId'] = user?.uid ?? 'No user';
      
      // Verificar acceso a Storage
      final storage = FirebaseStorage.instance;
      results['storageInitialized'] = true;
      
      // Intentar listar archivos (esto fallará si Storage no está habilitado)
      try {
        final ref = storage.ref('test_connection');
        await ref.putString('test');
        await ref.delete();
        results['storageWritable'] = true;
      } catch (e) {
        results['storageWritable'] = false;
        results['storageError'] = e.toString();
      }
      
    } catch (e) {
      results['error'] = e.toString();
    }
    
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnóstico de Storage'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _checkStorageStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final results = snapshot.data ?? {};
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildResultCard('Usuario autenticado', results['authenticated'] == true),
              _buildResultCard('Storage inicializado', results['storageInitialized'] == true),
              _buildResultCard('Storage escribible', results['storageWritable'] == true),
              if (results['userId'] != null)
                ListTile(
                  title: const Text('User ID'),
                  subtitle: Text(results['userId'].toString()),
                ),
              if (results['storageError'] != null)
                Card(
                  color: Colors.red.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.error, color: Colors.red),
                    title: const Text('Error de Storage'),
                    subtitle: Text(results['storageError'].toString()),
                  ),
                ),
              if (results['error'] != null)
                Card(
                  color: Colors.red.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.error, color: Colors.red),
                    title: const Text('Error general'),
                    subtitle: Text(results['error'].toString()),
                  ),
                ),
              const SizedBox(height: 24),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instrucciones:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text('1. Asegúrate de que Firebase Storage esté habilitado en la consola'),
                      Text('2. Configura las reglas de Storage (ver CONFIGURAR_STORAGE.md)'),
                      Text('3. Si Storage no es escribible, revisa las reglas de seguridad'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultCard(String title, bool success) {
    return Card(
      color: success ? Colors.green.shade50 : Colors.red.shade50,
      child: ListTile(
        leading: Icon(
          success ? Icons.check_circle : Icons.cancel,
          color: success ? Colors.green : Colors.red,
        ),
        title: Text(title),
        subtitle: Text(success ? 'OK' : 'Fallo'),
      ),
    );
  }
}
