# Sentinel Mobile

A smart security companion app built with Flutter. Track your security habits, analyze password strength, check for threats, and learn about cybersecurity - all offline.

## Features

- **Security Dashboard**: Visual security score with category breakdown
- **Password Analyzer**: Real-time strength analysis with improvement suggestions
- **Threat Checker**: Simulated security scan with recommendations
- **Security Habits Tracker**: Build and track daily security habits
- **Learning Center**: Educational content on cybersecurity topics
- **Multi-language Support**: English, Arabic (RTL), and Korean
- **Dark Theme**: Professional cybersecurity aesthetic

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: StatefulWidget (built-in)
- **Local Storage**: SharedPreferences
- **Localization**: Flutter intl + JSON
- **Architecture**: Clean, modular structure

## Project Structure

```
lib/
├── models/          # Data models
├── screens/         # UI screens
├── services/        # Business logic
├── utils/           # Theme, helpers, constants
└── widgets/         # Reusable components

assets/
└── lang/            # Translation files (en, ar, ko)

android/             # Android configuration
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android SDK
- JDK 17

### Installation

1. Clone the repository:
```bash
git clone <repo-url>
cd sentinel_mobile
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Building APK

### Debug Build (for testing)

```bash
flutter build apk --debug
```

### Release Build (for distribution)

```bash
flutter build apk --release
```

The APK will be located at:
```
build/app/outputs/flutter-apk/app-release.apk
```

### Build Troubleshooting

If the build fails:

1. **Clean the project**:
```bash
flutter clean
flutter pub get
```

2. **Update dependencies**:
```bash
flutter pub upgrade
```

3. **Verify Flutter setup**:
```bash
flutter doctor
```

4. **Check Android SDK path** in `android/local.properties`:
```
sdk.dir=C:\\Users\\YOUR_USERNAME\\AppData\\Local\\Android\\Sdk
flutter.sdk=C:\\flutter
```

5. **Accept Android licenses** (if needed):
```bash
flutter doctor --android-licenses
```

## Android Configuration

The app is configured with:

- **Application ID**: `com.sentinel.sentinel_mobile`
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: 34 (Android 14)
- **Compile SDK**: 34

No signing configuration is required for debug builds. For release builds, configure signing in `android/app/build.gradle` or use:

```bash
flutter build apk --release --no-sound-null-safety
```

## Data Privacy

This app operates entirely offline. All data is stored locally on the device using SharedPreferences. No data is transmitted to external servers.

## Localization

The app supports three languages:
- English (en)
- Arabic (ar) - RTL layout
- Korean (ko)

Language can be changed in Settings. The app uses JSON files for translations located in `assets/lang/`.

## License

MIT License - Built for educational and portfolio purposes.

---

Built with security in mind.
