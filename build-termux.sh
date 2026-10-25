#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

# Build Android APK from Termux. Defaults to the SDK location used on the user's setup.
export JAVA_HOME="${JAVA_HOME:-$PREFIX/lib/jvm/java-21-openjdk}"
if [ -d "$JAVA_HOME" ]; then export PATH="$JAVA_HOME/bin:$PATH"; fi
export ANDROID_HOME="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/lib/android-sdk-9123335}}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

if ! command -v java >/dev/null 2>&1; then
  echo "ERROR: Java no está instalado. Ejecutá: pkg install openjdk-21"
  exit 1
fi
if [ ! -d "$ANDROID_HOME/platform-tools" ] || [ ! -d "$ANDROID_HOME/platforms" ]; then
  echo "ERROR: No encuentro un Android SDK completo en: $ANDROID_HOME"
  echo "Definí ANDROID_HOME con la ruta real de tu SDK. No se instala un SDK automáticamente."
  exit 1
fi
chmod +x ./gradlew
printf '\nJava: '; java -version 2>&1 | head -n 1
printf 'Android SDK: %s\n' "$ANDROID_HOME"
echo "Compilando APK debug..."
./gradlew --no-daemon --stacktrace android:assembleDebug
APK="android/build/outputs/apk/debug/android-debug.apk"
if [ -f "$APK" ]; then
  DEST="${HOME}/storage/downloads/shattered-pixel-dungeon-multijugador-v5.apk"
  mkdir -p "$(dirname "$DEST")"
  cp "$APK" "$DEST"
  echo "APK creado: $DEST"
else
  echo "Gradle terminó, pero no encontré el APK en la ruta esperada: $APK"
  echo "Buscando APKs generados:"
  find . -path '*/build/outputs/apk/*/*.apk' -type f -print
fi
