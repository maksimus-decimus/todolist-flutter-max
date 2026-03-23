# 🔧 Configuración de Firebase Storage

## ⚠️ IMPORTANTE: Debes configurar Firebase Storage para que las fotos de perfil funcionen

### Paso 1: Habilitar Firebase Storage

1. Ve a la [Consola de Firebase](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. En el menú lateral, ve a **Build** → **Storage**
4. Si nunca lo has usado, haz clic en **"Get Started"** o **"Comenzar"**
5. Acepta las condiciones y selecciona una ubicación (preferiblemente cerca de tus usuarios)

### Paso 2: Configurar las Reglas de Seguridad

Las reglas de seguridad controlan quién puede subir, leer o eliminar archivos.

1. En la consola de Firebase Storage, ve a la pestaña **"Rules"** o **"Reglas"**

2. Reemplaza las reglas existentes con las siguientes:

```
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {
    // Permitir que usuarios autenticados suban/lean/borren sus propias fotos de perfil
    match /perfiles/{userId}/{allPaths=**} {
      allow read: if true; // Cualquiera puede ver las fotos de perfil
      allow write, delete: if request.auth != null && request.auth.uid == userId;
    }
    
    // Regla adicional: limitar tamaño de archivo a 5MB
    match /perfiles/{userId}/profile.jpg {
      allow write: if request.auth != null 
                   && request.auth.uid == userId
                   && request.resource.size < 5 * 1024 * 1024;
    }
  }
}
```

3. Haz clic en **"Publish"** o **"Publicar"**

### Paso 3: Verificar la Configuración

Después de configurar las reglas:

1. Reinicia tu aplicación Flutter
2. Intenta cambiar la foto de perfil
3. Revisa los logs en la consola de Debug para ver si hay errores

### 🐛 Solución de Problemas

#### Error: "User does not have permission to access..."
- **Solución**: Asegúrate de que las reglas de Storage estén configuradas correctamente (ver Paso 2)

#### Error: "Object 'perfiles/xxx/profile.jpg' not found"
- **Solución**: Este error es normal la primera vez. Intenta subir una nueva foto.

#### La imagen no se sube
1. Verifica que estés autenticado en Firebase Auth
2. Revisa los logs en la consola de Debug (busca mensajes que empiecen con "🔴 Error al subir imagen")
3. Asegúrate de que tienes conexión a Internet
4. Verifica que las reglas de Storage estén publicadas

#### Para ver los logs de depuración:
1. En VS Code, abre la terminal de Debug Console
2. O ejecuta: `flutter run` y observa la salida en la terminal
3. Busca mensajes como:
   - "Iniciando subida de imagen..."
   - "Archivo subido exitosamente"
   - "🔴 Error al subir imagen: ..."

### 📱 Permisos de la Aplicación

Los permisos ya están configurados en el código:

- **Android**: `AndroidManifest.xml` - Permisos de cámara y almacenamiento
- **iOS**: `Info.plist` - Descripciones de uso de cámara y galería

### 🔐 Seguridad de las Reglas Explicadas

- **`allow read: if true;`**: Cualquiera puede ver las fotos de perfil (necesario para que otros usuarios vean tu foto)
- **`allow write, delete: if request.auth.uid == userId;`**: Solo tú puedes modificar/eliminar tu propia foto
- **`request.resource.size < 5 * 1024 * 1024`**: Limita el tamaño máximo a 5MB

### ✅ Verificación Final

Una vez configurado todo, deberías poder:
1. ✅ Seleccionar una imagen de la galería
2. ✅ Tomar una foto con la cámara
3. ✅ Ver el indicador de carga mientras se sube
4. ✅ Ver la foto actualizada en tu perfil
5. ✅ Ver la foto en la pantalla de inicio
6. ✅ Eliminar tu foto de perfil

---

## 🆘 ¿Aún tienes problemas?

Si después de seguir estos pasos la foto no se sube:

1. **Verifica en Firebase Console**:
   - Ve a Storage → Files
   - Deberías ver una carpeta `perfiles/`
   - Si hay errores, aparecerán en la pestaña "Usage" o "Uso"

2. **Revisa el código de error exacto**:
   - Ejecuta la app en modo debug
   - Mira la consola cuando intentes subir una foto
   - El error completo te dirá exactamente qué está fallando

3. **Errores comunes**:
   - `permission-denied`: Las reglas de Storage no están bien configuradas
   - `unauthenticated`: No estás logueado correctamente
   - `quota-exceeded`: Has excedido el límite gratuito de Firebase
