#  Sentinel Mobile

Your personal cybersecurity companion. Built with Flutter, Sentinel helps you build better security habits, analyze password strength, identify potential threats, and learn essential cybersecurity practices — all completely offline.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/Android-5.0+-3DDC84?logo=android" alt="Android">
</p>

##  Features

###  Security Dashboard
Get a comprehensive view of your digital security posture with a visual security score and detailed category breakdown.

###  Password Analyzer
Real-time password strength analysis with actionable suggestions to improve your credentials across all accounts.

###  Threat Checker
Simulated security scans that identify potential vulnerabilities and provide personalized recommendations to stay protected.

###  Security Habits Tracker
Build and maintain 23+ essential security habits with daily tracking, progress visualization, and streak counters.

###  Learning Center
Comprehensive educational content covering:
- **Fundamentals**: Password security, 2FA, device security
- **Awareness**: Phishing, social engineering, malware
- **Technical**: Network security, VPN usage, browser security

###  Multi-language Support
- English (EN)
- Arabic (AR) with full RTL support
- Korean (KO)

###  Dynamic Themes
- **Light Theme**: Fresh Ocean Breeze — calming blues and clean whites
- **Dark Theme**: Deep Space Midnight — amber accents on deep navy
- Seamless toggle with completely distinct color palettes

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
