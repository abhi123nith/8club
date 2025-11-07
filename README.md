# Hotspot Hosts Onboarding Questionnaire

A Flutter application for the onboarding process of Hotspot Hosts, featuring experience selection and questionnaire screens with audio/video recording capabilities.

## Features Implemented

### Experience Type Selection Screen
- Displays a list of experiences fetched from API (with mock data fallback)
- Card-based UI with image backgrounds
- Grayscale effect for unselected cards
- Multi-select capability
- Multi-line text field with 250 character limit
- Clean UI with proper spacing and styling

### Onboarding Question Screen
- Multi-line text field with 600 character limit
- Audio recording functionality
- Video recording functionality (simplified implementation)
- Dynamic layout that removes recording buttons after recording
- Option to delete recorded audio/video

### Brownie Points (Optional Enhancements)
- State management using Riverpod
- API integration using Dio
- Animations for button transitions
- Responsive UI that handles keyboard appearance
- Error handling with graceful fallbacks

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── experience.dart
├── screens/
│   ├── experience_selection_screen.dart
│   └── onboarding_question_screen.dart
├── services/
│   └── api_service.dart
└── providers/
    └── experience_provider.dart
```

## Dependencies Used

- `flutter_riverpod`: State management
- `dio`: HTTP client for API calls
- `flutter_sound`: Audio recording (replaces incompatible record package)
- `camera`: Video recording
- `video_player`: Video playback
- `permission_handler`: Handle permissions for camera/microphone
- `path_provider`: Access file system paths

## Getting Started

### Prerequisites

Make sure you have Flutter installed on your system. If not, follow the official Flutter installation guide:
https://docs.flutter.dev/get-started/install

### Running the Application

#### Option 1: Run on Chrome (Recommended - Faster)

1. Open a terminal/command prompt
2. Navigate to the project directory:
   ```
   cd d:\8Club\hotspots_hostes
   ```
3. Run the application on Chrome:
   ```
   flutter run -d chrome
   ```

#### Option 2: Run on Android Device

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

## API Integration

The app fetches experiences from:
```
GET https://staging.chamberofsecrets.8club.co/v1/experiences?active=true
```

The app gracefully falls back to mock data if the API is unavailable.

## Implementation Details

### State Management
- Uses Riverpod for state management
- Separates business logic from UI components
- Provides a scalable architecture

### UI/UX Considerations
- Pixel-perfect design following Figma specifications
- Responsive layout that adapts to keyboard appearance
- Visual feedback for user interactions
- Intuitive recording interface

### Error Handling
- Graceful fallback to mock data when API is unavailable
- Proper error handling for recording permissions
- User-friendly error messages

## Known Limitations

1. Video recording is simplified and would need enhancement for production use
2. Audio waveform visualization is not implemented
3. Video playback functionality is not implemented

## Future Enhancements
- Full audio waveform visualization
- Video playback functionality
- Enhanced error handling
- Unit and widget tests

## Submission Information
- Developer: Abhishek Godara
- Email: abhishekgodara202226@gmail.com
- LinkedIn: https://www.linkedin.com/in/abhishek-godara-ab28a725a/