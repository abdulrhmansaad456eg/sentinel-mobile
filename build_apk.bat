@echo off
echo ==========================================
echo Sentinel Mobile - APK Build Script
echo ==========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Flutter not found in PATH.
    echo Please ensure Flutter is installed and added to PATH.
    echo.
    echo Common Flutter locations:
    echo - C:\flutter\bin
    echo - C:\src\flutter\bin
    echo.
    pause
    exit /b 1
)

echo Flutter found.
flutter --version
echo.

echo Step 1: Getting dependencies...
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to get dependencies.
    pause
    exit /b 1
)
echo Done.
echo.

echo Step 2: Building release APK...
call flutter build apk --release
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Build failed.
    echo.
    echo Troubleshooting:
    echo 1. Run 'flutter doctor' to check setup
    echo 2. Ensure Android SDK is configured
    echo 3. Run 'flutter clean' and try again
    echo.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo BUILD SUCCESSFUL
echo ==========================================
echo.
echo APK location:
echo build\app\outputs\flutter-apk\app-release.apk
echo.
pause
