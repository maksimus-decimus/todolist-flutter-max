import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtiene el UID del usuario actual
  String? get _uid => _auth.currentUser?.uid;

  // Obtiene la referencia a la colección de tareas del usuario actual
  CollectionReference? get _tasksCollection {
    if (_uid == null) return null;
    return _firestore.collection('usuarios').doc(_uid).collection('tasques');
  }

  // Stream para obtener las tareas en tiempo real, ordenadas por fecha (más recientes primero)
  Stream<QuerySnapshot>? getTasks() {
    if (_tasksCollection == null) return null;
    return _tasksCollection!
        .orderBy('fecha', descending: true)
        .snapshots();
  }

  // Agregar una nueva tarea
  Future<void> addTask(String title) async {
    if (_tasksCollection == null) return;
    
    await _tasksCollection!.add({
      'titulo': title,
      'completada': false,
      'fecha': FieldValue.serverTimestamp(),
    });
  }

  // Marcar una tarea como completada o no completada
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    if (_tasksCollection == null) return;
    
    await _tasksCollection!.doc(taskId).update({
      'completada': !isCompleted,
    });
  }

  // Eliminar una tarea
  Future<void> deleteTask(String taskId) async {
    if (_tasksCollection == null) return;
    
    await _tasksCollection!.doc(taskId).delete();
  }
}
