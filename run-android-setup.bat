@echo off
setlocal
title Flutter Android Setup
where flutter >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Flutter no esta en el PATH. Instala Flutter y abre una nueva ventana CMD.
  pause
  exit /b 1
)
echo [INFO] Generando plataforma Android si no existe...
flutter create --platforms=android . || (
  echo [ERROR] No se pudo crear la plataforma Android.
  pause
  exit /b 1
)
echo [INFO] Obteniendo dependencias...
flutter pub get || (
  echo [ERROR] flutter pub get fallo.
  pause
  exit /b 1
)
echo [INFO] Verificando toolchain...
flutter doctor -v
echo.
echo ===============================================
echo   Si no tienes un emulador estable, crea uno
echo   (API 33/34 recomendado) en Android Studio.
echo   Luego ejecuta:
echo     flutter devices
echo     flutter run -d ^<ID_EMULADOR^>
echo ===============================================
echo.
pause
endlocal
