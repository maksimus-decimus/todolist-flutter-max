import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // Obtiene el UID del usuario actual
  String? get _uid => _auth.currentUser?.uid;

  // Obtiene la referencia al documento del usuario actual
  DocumentReference? get _userDoc {
    if (_uid == null) return null;
    return _firestore.collection('usuarios').doc(_uid);
  }

  // Stream para obtener los datos del usuario en tiempo real
  Stream<DocumentSnapshot>? getUserProfile() {
    if (_userDoc == null) return null;
    return _userDoc!.snapshots();
  }

  // Obtener datos del usuario una sola vez
  Future<Map<String, dynamic>?> getUserData() async {
    if (_userDoc == null) return null;
    
    final doc = await _userDoc!.get();
    if (!doc.exists) {
      // Crear perfil por defecto si no existe
      await _userDoc!.set({
        'nombre': '',
        'photoUrl': '',
        'email': _auth.currentUser?.email,
        'creadoEn': FieldValue.serverTimestamp(),
      });
      return {
        'nombre': '',
        'photoUrl': '',
        'email': _auth.currentUser?.email,
      };
    }
    
    return doc.data() as Map<String, dynamic>?;
  }

  // Actualizar el nombre del usuario
  Future<void> updateUserName(String name) async {
    if (_userDoc == null) return;
    
    await _userDoc!.set({
      'nombre': name,
      'email': _auth.currentUser?.email,
    }, SetOptions(merge: true));
  }

  // Seleccionar imagen de la galería
  Future<Map<String, dynamic>?> pickImageFromGallery() async {
    try {
      print('Abriendo selector de galería...');
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        print('Imagen seleccionada: ${pickedFile.path}');
        final bytes = await pickedFile.readAsBytes();
        print('Tamaño del archivo: ${bytes.length} bytes');
        return {
          'bytes': bytes,
          'name': pickedFile.name,
          'path': pickedFile.path,
        };
      }
      print('No se seleccionó ninguna imagen');
      return null;
    } catch (e, stackTrace) {
      print('❌ Error al seleccionar imagen: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Seleccionar imagen de la cámara
  Future<Map<String, dynamic>?> pickImageFromCamera() async {
    try {
      print('Abriendo cámara...');
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        print('Foto capturada: ${pickedFile.path}');
        final bytes = await pickedFile.readAsBytes();
        print('Tamaño del archivo: ${bytes.length} bytes');
        return {
          'bytes': bytes,
          'name': pickedFile.name,
          'path': pickedFile.path,
        };
      }
      print('No se capturó ninguna foto');
      return null;
    } catch (e, stackTrace) {
      print('❌ Error al capturar imagen: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Subir imagen de perfil a Firebase Storage
  Future<String?> uploadProfileImage(Uint8List imageBytes, String fileName) async {
    if (_uid == null) {
      print('Error: UID es null');
      return null;
    }
    
    try {
      print('Iniciando subida de imagen...');
      print('Tamaño del archivo: ${imageBytes.length} bytes');
      print('UID del usuario: $_uid');
      
      // Crear referencia a la imagen en Storage
      final storageRef = _storage.ref().child('perfiles/$_uid/profile.jpg');
      print('Referencia de Storage creada: perfiles/$_uid/profile.jpg');
      
      // Subir la imagen usando bytes (funciona en web y móvil)
      print('Subiendo archivo...');
      final uploadTask = await storageRef.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      print('Archivo subido exitosamente. Estado: ${uploadTask.state}');
      
      // Obtener la URL de descarga
      print('Obteniendo URL de descarga...');
      final downloadUrl = await storageRef.getDownloadURL();
      print('URL obtenida: $downloadUrl');
      
      // Actualizar la URL en Firestore
      print('Actualizando Firestore...');
      await _userDoc!.set({
        'photoUrl': downloadUrl,
      }, SetOptions(merge: true));
      print('Firestore actualizado correctamente');
      
      return downloadUrl;
    } catch (e, stackTrace) {
      print('❌ Error al subir imagen: $e');
      print('Stack trace: $stackTrace');
      rethrow; // Re-lanzar el error para que sea capturado en la UI
    }
  }

  // Eliminar foto de perfil
  Future<void> deleteProfileImage() async {
    if (_uid == null) return;
    
    try {
      // Eliminar la imagen de Storage
      final storageRef = _storage.ref().child('perfiles/$_uid/profile.jpg');
      await storageRef.delete();
      
      // Actualizar Firestore
      await _userDoc!.set({
        'photoUrl': '',
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error al eliminar imagen: $e');
    }
  }
}
