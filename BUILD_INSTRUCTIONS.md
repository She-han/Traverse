# Traverse App - Build Instructions

## Prerequisites

Before building the APK, ensure you have the following installed:

1. **Flutter SDK** (3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH

2. **Android Studio** or **Android SDK**
   - Download from: https://developer.android.com/studio
   - Install Android SDK and build tools

3. **Java Development Kit (JDK)** 8 or higher

## Setup Instructions

### 1. Install Flutter Dependencies
```bash
cd traverse_app
flutter pub get
```

### 2. Generate Hive Adapters (if needed)
```bash
flutter packages pub run build_runner build
```

### 3. Configure Android SDK
Create a `local.properties` file in the `android/` directory:
```
sdk.dir=/path/to/your/android/sdk
flutter.sdk=/path/to/your/flutter/sdk
```

### 4. Configure Google Maps API (Optional)
1. Get a Google Maps API key from Google Cloud Console
2. Replace `YOUR_API_KEY_HERE` in `android/app/src/main/AndroidManifest.xml`

## Building the APK

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

### Split APKs by ABI (smaller file sizes)
```bash
flutter build apk --split-per-abi
```

## Output Location

The generated APK files will be located in:
```
build/app/outputs/flutter-apk/
```

Files:
- `app-debug.apk` (for debug builds)
- `app-release.apk` (for release builds)
- `app-armeabi-v7a-release.apk` (ARM 32-bit)
- `app-arm64-v8a-release.apk` (ARM 64-bit)
- `app-x86_64-release.apk` (x86 64-bit)

## Installation

### Install on Device/Emulator
```bash
flutter install
```

### Manual Installation
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Troubleshooting

### Common Issues

1. **Flutter not found**
   - Ensure Flutter is installed and added to PATH
   - Run `flutter doctor` to check setup

2. **Android SDK not found**
   - Verify `local.properties` file exists with correct paths
   - Run `flutter doctor` to verify Android setup

3. **Build errors**
   - Run `flutter clean` then `flutter pub get`
   - Check that all dependencies are compatible

4. **Permission errors**
   - Ensure location permissions are granted on device
   - Check AndroidManifest.xml for required permissions

### Verification Commands
```bash
# Check Flutter installation
flutter doctor

# Check connected devices
flutter devices

# Run app in debug mode
flutter run

# Analyze code for issues
flutter analyze
```

## App Features

The Traverse app includes:

- **Live Map Screen**: Real-time location tracking with bus stop markers
- **Bus Timetable**: Upcoming arrivals at selected stops
- **Route Planner**: Journey planning with bus route suggestions
- **Favorites**: Save frequently used stops and routes
- **Dark/Light Theme**: Automatic theme switching
- **Offline Storage**: Local data persistence with Hive

## Development Notes

- The app uses sample data for demonstration
- Google Maps integration requires API key configuration
- Real-time data would require backend API integration
- Location permissions are required for full functionality

## Next Steps

1. Configure Google Maps API key for map functionality
2. Integrate with real transit data APIs
3. Add push notifications for bus arrivals
4. Implement user authentication
5. Add more advanced route planning features

For support or questions, refer to the Flutter documentation or the project's README.md file.

