# Multijugador local por turnos (hasta 8 jugadores)

## Cambios de esta versión
- Selección de 1 a 8 jugadores antes de empezar.
- Héroes adicionales, turnos por ronda, accesos rápidos individuales y experiencia compartida.
- Las rutas automáticas a puntos lejanos sin enemigos visibles consumen un turno en total; si aparece un enemigo visible durante el recorrido, el movimiento se detiene. Con enemigos visibles desde el inicio, se conserva el coste normal por paso.
- Dificultad de enemigos ajustada según la cantidad de héroes.
- Monedas de resurrección compartidas: comienzan con `3 + cantidad de jugadores`; el sistema queda desactivado en partidas de un solo jugador.
- Al morir un héroe con compañeros vivos aparece una decisión inmediata para revivirlo por 1 moneda. Si se elige continuar, cada objeto del inventario/equipo tiene una tirada independiente: 50% de caer al suelo y 50% de desaparecer.
- Las monedas de resurrección se guardan/cargan junto a la partida.

## Arreglo v5: bug al revivir
- El héroe revivido conservaba un reloj interno viejo más `now` (muy en el futuro), por eso los turnos pasaban solos. Ahora se reinicia a 0 antes de volver a añadirlo.
- El sprite se creaba con `new HeroSprite()` (usa `Dungeon.hero`, el compañero vivo) y le robaba el sprite al compañero, lo que trababa el hilo de actores. Ahora usa `new HeroSprite(this)`.
- Ya no se fuerza `setActiveHero` al revivir: el juego seguía esperando el turno de otro jugador, pero la interfaz quedaba bloqueada con el revivido (`ready=false`). Ahora entra en la rotación normal.
- Reaparece en una casilla libre junto a un compañero (antes en la misma casilla).
- El diálogo de revivir se crea en el hilo de render.

## Estado de pruebas
Esta entrega **no se debe considerar compilada ni probada**. La resurrección recrea el actor y el sprite del héroe; debe probarse en Android antes de confiarle una partida larga. La decisión de revivir aparece inmediatamente al morir; elegir continuar descarta esa oportunidad, por lo que todavía no hay una pantalla para revivir más tarde mientras el grupo permanece en el mismo piso. La limpieza explícita del cadáver al cambiar de piso queda pendiente.

## Compilar desde Termux (Android)
1. Instalar Java si hace falta: `pkg install openjdk-21`
2. Dar permiso al almacenamiento si todavía no está habilitado: `termux-setup-storage`
3. Confirmar que el SDK está en `~/lib/android-sdk-9123335`, o exportar `ANDROID_HOME` a la ruta real.
4. Desde la carpeta del proyecto ejecutar: `bash build-termux.sh`
5. Si compila correctamente, el script copia el APK a `~/storage/downloads/shattered-pixel-dungeon-multijugador-v5.apk`.

El script usa el Gradle Wrapper del proyecto y necesita internet la primera vez para descargar Gradle/dependencias. Si falla, guardar el error completo: no significa necesariamente que el código sea el problema; también puede faltar una plataforma Android o una licencia del SDK.
