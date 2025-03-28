# Last Light Randomizer

A Flutter application that randomizes game setups for the Last Light board game, supporting both Windows desktop and Android devices.

## Project Description

Last Light Randomizer assists players of the Last Light board game by:

- Supporting 1-8 player games
- Randomly placing planets on three concentric rings
- Displaying the game board with color-coded rings and planets
- Allowing regeneration of random setups

## Prerequisites & Installation

Before you can run the Last Light Randomizer, you'll need to set up your development environment:

### 1. Install Flutter SDK

```bash
# 1. Create a directory for Flutter
mkdir C:\src
cd C:\src

# 2. Clone the Flutter repository
git clone https://github.com/flutter/flutter.git -b stable

# 3. Add Flutter to your PATH (add this to your environment variables)
# For temporary use in current terminal:
set PATH=%PATH%;C:\src\flutter\bin

# 4. Verify installation
flutter doctor
```

### 2. Install IDE and Required Tools

#### For Windows Development:
- Download and install [Visual Studio 2022](https://visualstudio.microsoft.com/downloads/)
  - During installation, select "Desktop development with C++"
  - This is required for Windows desktop app development

#### For Android Development:
- Download and install [Android Studio](https://developer.android.com/studio)
- During setup, ensure you install:
  - Android SDK
  - Android SDK Command-line Tools
  - Android SDK Build-Tools

### 3. Clone This Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/lastlightrandomizer.git
cd lastlightrandomizer

# Install dependencies
flutter pub get
```

### 4. Verify Everything Works

```bash
flutter doctor --android-licenses  # Accept Android licenses if developing for Android
flutter doctor -v                  # Should show all checkmarks for your target platforms
```

## Platform Support

- **Windows Desktop**: Full native Windows application
- **Android**: Mobile application for Android devices

## Running the App

### Using VS Code Tasks

This project includes pre-configured VS Code tasks that make it easy to run the app on different platforms and run tests.

To run a task:

1. Open the Command Palette (`Ctrl+Shift+P`)
2. Type "Tasks: Run Task"
3. Select one of the available tasks:

#### Platform Tasks

- **Run on Windows**: Launches the app as a native Windows application
- **Run on Android**: Deploys and runs the app on a connected Android device or emulator
- **Clean Project**: Cleans build files (useful when switching between platforms)

#### Test Tasks

- **Run All Tests**: Runs all unit and widget tests
- **Run Widget Tests**: Tests the UI components
- **Run Ring Tests**: Tests the ring model functionality
- **Run Game Setup Tests**: Tests game setup generation
- **Run Game Provider Tests**: Tests the game state provider

### Command Line

You can also run the app directly from the command line:

```bash
# Run on Windows
flutter run -d windows

# Run on Android
flutter run -d android

# Run all tests
flutter test
```

## Development Requirements

- Flutter SDK 3.13.0 or higher
- Visual Studio 2022 with "Desktop development with C++" (for Windows builds)
- Android Studio with Android SDK (for Android builds)

## Project Structure

- `lib/models/`: Data models for planets, rings and game setup
- `lib/screens/`: UI screens for player selection and game board
- `lib/state/`: State management with Provider pattern
- `lib/utils/`: Utility functions like position calculations
- `test/`: Unit and widget tests

## Troubleshooting

- **Platform Switching Issues**: If you encounter issues when switching between platforms, try running the "Clean Project" task first, then try running the app again on your desired platform.

- **Windows Build Errors**: Ensure Visual Studio 2022 is properly installed with "Desktop development with C++" workload.

- **Android Build Errors**: Make sure you've accepted all Android SDK licenses using `flutter doctor --android-licenses`.

- **Flutter Version Issues**: This project was last tested with Flutter 3.13.0. If you're using a different version, consider using [FVM (Flutter Version Management)](https://github.com/fluttertools/fvm) to switch to the compatible version.
