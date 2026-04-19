# Sentinel Mobile - Developer Setup Guide

## Quick Start

### Prerequisites

1. **Flutter SDK** (3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add to PATH: `C:\flutter\bin`

2. **Android Studio** (or Android SDK only)
   - Download from: https://developer.android.com/studio
   - Install Android SDK, Platform-Tools, and Build-Tools

3. **Java JDK 17**
   - Required for Android builds
   - Set JAVA_HOME environment variable

### Installation Steps

1. **Navigate to project directory**:
```bash
cd sentinel_mobile
```

2. **Get Flutter dependencies**:
```bash
flutter pub get
```

3. **Verify Flutter setup**:
```bash
flutter doctor
```

Fix any issues reported by `flutter doctor` before proceeding.

### Running the App

**Debug mode** (for development):
```bash
flutter run
```

**Release mode** (performance testing):
```bash
flutter run --release
```

### Building APK

**Debug APK** (for testing):
```bash
flutter build apk --debug
```

**Release APK** (for distribution):
```bash
flutter build apk --release
```

Output location: `build/app/outputs/flutter-apk/app-release.apk`

**App Bundle** (for Google Play):
```bash
flutter build appbundle --release
```

### Project Structure Explained

```
lib/
├── main.dart              # App entry point
├── models/                # Data classes (JSON serializable)
├── screens/               # Full page UIs
├── services/              # Business logic & data handling
├── utils/                 # Theme, constants, helpers
└── widgets/               # Reusable UI components

assets/lang/               # Translation files
android/                   # Android-specific config
```

### Key Features Implementation

1. **Localization**: JSON-based translations with RTL support for Arabic
2. **Storage**: SharedPreferences for local data persistence
3. **Password Analysis**: Regex-based strength calculation
4. **Threat Simulation**: Randomized security checks
5. **Habit Tracking**: Date-based completion tracking with streaks

### Troubleshooting

**Build fails with "Could not resolve dependencies"**:
```bash
flutter clean
flutter pub get
```

**Android SDK not found**:
- Update `android/local.properties` with your SDK path
- Or set ANDROID_HOME environment variable

**Gradle errors**:
```bash
cd android
./gradlew clean
cd ..
flutter build apk
```

**Emulator not detected**:
- Start Android Studio
- Open AVD Manager
- Create or start an emulator

### Testing

**Unit tests** (if any):
```bash
flutter test
```

**Integration tests**:
```bash
flutter drive --target=test_driver/app.dart
```

### Code Style

- Follow Flutter/Dart style guidelines
- Use `const` constructors where possible
- Prefer single quotes for strings
- Keep functions under 50 lines when possible

---

For detailed build instructions, see README.md
