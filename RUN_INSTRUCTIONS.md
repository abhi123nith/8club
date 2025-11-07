# How to Run the Hotspot Hosts Onboarding Questionnaire Application

## Prerequisites

Make sure you have Flutter installed on your system. If not, follow the official Flutter installation guide:
https://docs.flutter.dev/get-started/install

## Running the Application

### Option 1: Run on Chrome (Recommended - Faster)

1. Open a terminal/command prompt
2. Navigate to the project directory:
   ```
   cd d:\8Club\hotspots_hostes
   ```
3. Run the application on Chrome:
   ```
   flutter run -d chrome
   ```

### Option 2: Run on Android Device

1. Connect an Android device or start an Android emulator
2. Open a terminal/command prompt
3. Navigate to the project directory:
   ```
   cd d:\8Club\hotspots_hostes
   ```
4. Run the application:
   ```
   flutter run
   ```

Note: The Android build may take several minutes on the first run due to dependency compilation.

## Troubleshooting

### If you encounter build errors:

1. Try upgrading Flutter packages:
   ```
   flutter pub upgrade
   ```

2. Clean the build:
   ```
   flutter clean
   flutter pub get
   ```

3. Try running again:
   ```
   flutter run -d chrome
   ```

### If the API is not accessible:

The application will automatically fall back to mock data if the API is unavailable, so you can still test all functionality.

## Application Features

Once the application is running, you can:

1. Select multiple experiences from the grid
2. Add an optional description of your experience
3. Navigate to the questionnaire screen
4. Write a response to the questionnaire
5. Record audio responses
6. Record video responses (simplified implementation)
7. Delete recorded media
8. Submit your questionnaire

## Development Notes

- The application uses Riverpod for state management
- API calls are handled with Dio
- Audio recording is implemented with flutter_sound
- The UI is designed to be responsive and user-friendly