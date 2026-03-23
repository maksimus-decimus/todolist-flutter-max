# 🔐 Seguridad de API Keys - IMPORTANTE

## ⚠️ Tus API Keys están expuestas en GitHub

Los siguientes archivos contienen claves de API:
- `android/app/google-services.json`
- `lib/firebase_options.dart`

## ✅ Pasos para Proteger tu Proyecto

### 1. Restringir las API Keys en Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto: **todolist-flutter-fb035**
3. En el menú lateral: **APIs & Services** → **Credentials**
4. Para cada API key:
   - **Android Key**: Restringir a tu package name: `com.example.autenticacio_exemple`
   - **Web Key**: Restringir a tu dominio (si usas web)
   - **iOS Key**: Restringir a tu Bundle ID

**Restricciones recomendadas:**
```
Application restrictions:
  - Android apps: com.example.autenticacio_exemple
  - iOS apps: [Tu Bundle ID]
  - HTTP referrers (websites): [Tu dominio si tienes web]

API restrictions:
  - Firebase Authentication API
  - Cloud Firestore API
  - Cloud Storage for Firebase API
```

### 2. Configurar Reglas de Seguridad de Firebase

#### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Solo usuarios autenticados pueden acceder a sus propios datos
    match /usuarios/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

#### Storage Rules
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

#### Authentication
- Habilita solo los métodos que necesites (Email/Password)
- Configura límites de tasa (rate limiting)

### 3. Monitorear el Uso

1. En Firebase Console → **Usage and billing**
2. Configura alertas de uso
3. Revisa el tab **Authentication** → **Usage** regularmente

### 4. Rotar las API Keys (Si es necesario)

Si crees que las keys han sido comprometidas:

1. En Google Cloud Console → **Credentials**
2. Crea nuevas API keys
3. Actualiza los archivos de configuración
4. Elimina las keys antiguas

### 5. Agregar archivos sensibles a .gitignore (OPCIONAL)

Si quieres evitar que se suban en el futuro:

```gitignore
# Archivos de configuración de Firebase (opcional)
# Nota: Para apps móviles, estos archivos suelen incluirse
# android/app/google-services.json
# ios/Runner/GoogleService-Info.plist
# lib/firebase_options.dart
```

**⚠️ IMPORTANTE**: Si usas esto, necesitarás documentar cómo otros desarrolladores pueden obtener estos archivos.

## 🎯 ¿Qué hacer AHORA?

### Mínimo Indispensable (Hazlo YA):
1. ✅ Ve a Firebase Console → **Firestore Database** → **Rules**
2. ✅ Asegúrate de que las reglas NO sean `allow read, write: if true;`
3. ✅ Ve a **Storage** → **Rules** y configura las reglas de seguridad
4. ✅ En **Authentication** → **Settings** → habilita solo los proveedores que uses

### Recomendado (Si el repo es público):
1. ✅ Restringir las API keys en Google Cloud Console
2. ✅ Monitorear el uso en Firebase Console
3. ✅ Habilitar límites de tasa en Authentication

### Si sospechas que alguien usó tus keys maliciosamente:
1. ❌ Rotar las API keys inmediatamente
2. ❌ Revisar logs de uso en Firebase Console
3. ❌ Considerar hacer el repositorio privado

## 📚 Lecturas Recomendadas

- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [API Key Best Practices](https://cloud.google.com/docs/authentication/api-keys)
- [Securing Your Firebase Project](https://firebase.google.com/support/guides/security-checklist)

## 🔍 Verificar Seguridad

Puedes verificar que tus reglas están bien configuradas:
1. Firebase Console → Firestore → Rules → **Rules Playground**
2. Prueba operaciones como usuario autenticado y no autenticado
3. Asegúrate de que solo usuarios autenticados puedan acceder a sus datos

---

**Nota**: Para aplicaciones Flutter/móviles, es normal que las API keys estén en el código fuente. La verdadera seguridad viene de las **reglas de Firebase** y las **restricciones de API**, NO de mantener las keys secretas.
