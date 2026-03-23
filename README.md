# 📱 TodoList Flutter con Firebase

Aplicación de gestión de tareas (TodoList) con autenticación de usuarios, perfiles personalizables y sincronización en tiempo real usando Firebase.

## ✨ Características

- 🔐 **Autenticación con Firebase Auth**
  - Registro e inicio de sesión con email/contraseña
  - Gestión de sesiones automática
  
- 👤 **Perfiles de Usuario**
  - Foto de perfil con subida a Firebase Storage
  - Nombre personalizable
  - Edición en tiempo real
  
- ✅ **Gestión de Tareas**
  - Crear, editar y eliminar tareas
  - Marcar como completadas
  - Sincronización en tiempo real con Firestore
  - Datos privados por usuario
  
- 🎨 **Diseño Moderno**
  - UI con gradientes y Material Design 3
  - Animaciones suaves
  - Diseño responsive
  - Interfaz intuitiva

## 🛠️ Tecnologías

- **Flutter** - Framework de desarrollo
- **Firebase Authentication** - Gestión de usuarios
- **Cloud Firestore** - Base de datos en tiempo real
- **Firebase Storage** - Almacenamiento de imágenes
- **flutter_dotenv** - Gestión segura de variables de entorno

## 📋 Requisitos Previos

- Flutter SDK (>= 3.10.7)
- Dart SDK
- Una cuenta de Firebase
- Editor de código (VS Code, Android Studio, etc.)

## 🚀 Configuración del Proyecto

### 1. Clonar el repositorio

```bash
git clone https://github.com/maksimus-decimus/todolist-flutter-max.git
cd todolist-flutter-max
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar Firebase

#### A. Crear proyecto en Firebase Console
1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o usa uno existente
3. Habilita los siguientes servicios:
   - **Authentication** → Email/Password
   - **Firestore Database**
   - **Storage**

#### B. Configurar variables de entorno
1. Copia el archivo de ejemplo:
   ```bash
   cp .env.example .env
   ```

2. Edita `.env` con tus credenciales de Firebase:
   ```env
   FIREBASE_WEB_API_KEY=tu_api_key_aqui
   FIREBASE_WEB_APP_ID=tu_app_id_aqui
   # ... más configuraciones
   ```

3. **📚 Instrucciones detalladas:** Ver [ENV_SETUP.md](ENV_SETUP.md)

#### C. Configurar reglas de seguridad

**Firestore Rules:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /usuarios/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Storage Rules:**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /perfiles/{userId}/{allPaths=**} {
      allow read: if true;
      allow write, delete: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**📚 Más información:** Ver [CONFIGURAR_STORAGE.md](CONFIGURAR_STORAGE.md)

### 4. Ejecutar la aplicación

```bash
flutter run
```

O para web:
```bash
flutter run -d chrome
```

## 📱 Plataformas Soportadas

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── firebase_options.dart        # Configuración de Firebase
├── screens/                     # Pantallas de la app
│   ├── login_screen.dart       # Pantalla de login/registro
│   ├── home_screen.dart        # Pantalla principal con tareas
│   └── profile_screen.dart     # Pantalla de perfil
└── services/                    # Servicios
    ├── auth_service.dart       # Servicio de autenticación
    ├── firestore_service.dart  # Servicio de Firestore
    └── user_service.dart       # Servicio de usuario/perfil
```

## 🔐 Seguridad

Las claves de API de Firebase están protegidas mediante variables de entorno:

- ✅ El archivo `.env` está excluido del control de versiones
- ✅ Solo se sube `.env.example` como plantilla
- ✅ Las reglas de Firebase protegen los datos de usuario

**Documentación completa:** [SEGURIDAD_API_KEYS.md](SEGURIDAD_API_KEYS.md)

## 🎯 Funcionalidades Principales

### Autenticación
- Registro con email y contraseña
- Inicio de sesión
- Cierre de sesión
- Validación de formularios

### Gestión de Tareas
- Crear nuevas tareas
- Marcar como completadas/incompletas
- Eliminar tareas con confirmación
- Vista en tiempo real de cambios

### Perfil de Usuario
- Subir foto desde galería
- Tomar foto con cámara
- Editar nombre
- Actualización en tiempo real

## 🐛 Solución de Problemas

### Error: "No se encuentra .env"
Ver [ENV_SETUP.md](ENV_SETUP.md) para instrucciones de configuración.

### Error al subir fotos
Ver [CONFIGURAR_STORAGE.md](CONFIGURAR_STORAGE.md) para configurar Firebase Storage correctamente.

### Errores de permisos en Android
Asegúrate de que los permisos estén declarados en `AndroidManifest.xml`.

## 📚 Documentación Adicional

- [ENV_SETUP.md](ENV_SETUP.md) - Configuración de variables de entorno
- [CONFIGURAR_STORAGE.md](CONFIGURAR_STORAGE.md) - Configuración de Firebase Storage
- [SEGURIDAD_API_KEYS.md](SEGURIDAD_API_KEYS.md) - Guía de seguridad

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Haz fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es de código abierto para fines educativos.

## 👨‍💻 Autor

- GitHub: [@maksimus-decimus](https://github.com/maksimus-decimus)

## 🙏 Agradecimientos

- Flutter Team por el excelente framework
- Firebase por los servicios de backend
- Comunidad de Flutter por los recursos y paquetes

---

**⭐ Si te gustó este proyecto, dale una estrella!**
