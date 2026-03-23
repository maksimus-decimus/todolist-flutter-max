# 🔐 Configuración de Variables de Entorno

Este proyecto utiliza variables de entorno para proteger las claves sensibles de Firebase.

## 📋 Configuración Inicial

### 1. Instalar dependencias

```bash
flutter pub get
```

### 2. Crear tu archivo .env

El archivo `.env` contiene las claves de configuración de Firebase y **NO está incluido en el repositorio** por seguridad.

**Opción A: Copiar desde la plantilla**
```bash
cp .env.example .env
```

**Opción B: Crear manualmente**
```bash
# En Windows PowerShell
Copy-Item .env.example .env

# O crear un nuevo archivo .env en la raíz del proyecto
```

### 3. Completar el archivo .env

Abre el archivo `.env` y reemplaza los valores de ejemplo con tus propias credenciales de Firebase.

Puedes obtener estas credenciales de:
1. [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Configuración del proyecto (⚙️) → General
4. Desplázate hasta "Tus apps" → Selecciona tu plataforma (Web, Android, iOS, etc.)
5. Copia las credenciales correspondientes

**Ejemplo de .env completado:**
```env
FIREBASE_WEB_API_KEY=AIzaSyC95hgCk5TMR9xdeLzfysQ2sVMzaflENTg
FIREBASE_WEB_APP_ID=1:572195930055:web:62fb63827c142555f523e2
FIREBASE_WEB_MESSAGING_SENDER_ID=572195930055
FIREBASE_WEB_PROJECT_ID=todolist-flutter-fb035
...
```

## 🚀 Ejecutar la aplicación

Una vez configurado el `.env`:

```bash
flutter run
```

## ⚠️ Importante: Seguridad

- ✅ **SÍ** subir: `.env.example` (plantilla sin valores reales)
- ❌ **NO** subir: `.env` (contiene tus claves reales)
- ✅ El archivo `.env` está incluido en `.gitignore` automáticamente

## 🔍 Verificar que .env está protegido

Verifica que `.env` aparece en `.gitignore`:

```bash
# Verifica que .env NO aparezca en git status
git status

# Si aparece, algo está mal. NO hagas commit de ese archivo.
```

## 📁 Estructura de Archivos

```
proyecto/
├── .env              # ❌ TUS CLAVES (NO subir a Git)
├── .env.example      # ✅ PLANTILLA (sí subir a Git)
├── .gitignore        # Incluye .env
└── lib/
    ├── main.dart
    └── firebase_options.dart
```

## 🆘 Solución de Problemas

### Error: "No se encuentra el archivo .env"
- Asegúrate de que `.env` existe en la raíz del proyecto
- Verifica que el nombre sea exactamente `.env` (sin extensión)

### Error: "null check operator used on a null value"
- Revisa que todas las variables en `.env` estén correctamente definidas
- No debe haber espacios alrededor del signo `=`
- Ejemplo correcto: `FIREBASE_WEB_API_KEY=tu_clave_aqui`
- Ejemplo incorrecto: `FIREBASE_WEB_API_KEY = tu_clave_aqui`

### Las claves no se cargan
- Ejecuta `flutter clean` y luego `flutter pub get`
- Reinicia VS Code o tu IDE
- Verifica que `pubspec.yaml` incluya `.env` en assets

## 📚 Más Información

- [flutter_dotenv en pub.dev](https://pub.dev/packages/flutter_dotenv)
- [Firebase Setup](https://firebase.google.com/docs/flutter/setup)
- [Seguridad de API Keys](../SEGURIDAD_API_KEYS.md)
