# Hotspot Hosts Onboarding Questionnaire

A Flutter application for the onboarding process of Hotspot Hosts, featuring experience selection and questionnaire screens with complete audio/video recording capabilities.

## Features Implemented

### Experience Type Selection Screen
- Displays a list of experiences fetched from API (with mock data fallback)
- Card-based UI with image backgrounds
- Grayscale effect for unselected cards
- Multi-select capability with visual feedback
- Multi-line text field with 250 character limit
- Clean UI with proper spacing and styling
- Animated card movements on selection
- Wave animation in header
- Responsive design handling keyboard appearance

### Onboarding Question Screen
- Multi-line text field with 600 character limit
- Complete audio recording functionality with waveform visualization
- Complete video recording functionality with live camera preview
- Media playback capabilities for both audio and video
- Dynamic layout that removes recording buttons after recording
- Option to delete recorded audio/video
- Camera switching (front/rear)
- Pause/resume functionality for video recording
- WhatsApp-like interface for media recording and preview

### Brownie Points (All Optional Enhancements Implemented)
- State management using Riverpod
- API integration using Dio
- Animations for card selection and button transitions
- Responsive UI that handles keyboard appearance
- Error handling with graceful fallbacks
- Pixel perfect design following Figma specifications
- Animated card sliding to first position on selection
- Button width animations when recording controls appear/disappear
- Audio waveform visualization during recording
- Video recording with live preview
- Media playback capabilities

  ### Additional features or enhancements I've implemented.
  - Shimmer Skelton
  - Mock data incase api is not responding
  - Video Preview
  - Camera Switch
    
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
├── providers/
│   └── experience_provider.dart
├── constants/
│   ├── text_constants.dart
│   └── text_styles.dart
└── utils/
    ├── app_colors.dart
    ├── next_button.dart
    └── zig_zag_background.dart
```

## Dependencies Used

- `flutter_riverpod`: State management
- `dio`: HTTP client for API calls
- `flutter_sound`: Audio recording and playback
- `camera`: Video recording
- `video_player`: Video playback
- `permission_handler`: Handle permissions for camera/microphone
- `path_provider`: Access file system paths

## Getting Started
Demo Videos : https://drive.google.com/drive/folders/1NBNAXqiWiZkr0Re3zGI9kT7eb0JlId5z?usp=sharing
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
- Properly manages state between screens

### UI/UX Considerations
- Pixel-perfect design following Figma specifications
- Responsive layout that adapts to keyboard appearance
- Visual feedback for user interactions
- Intuitive recording interface with WhatsApp-like experience
- Animated transitions and state indicators

### Error Handling
- Graceful fallback to mock data when API is unavailable
- Proper error handling for recording permissions
- User-friendly error messages
- Resource cleanup and proper disposal

### Media Handling
- Complete audio recording with real-time waveform visualization
- Video recording with live camera preview
- Media playback for both audio and video
- Camera direction switching (front/rear)
- Pause/resume functionality for video recording
- Delete functionality for recorded media

## Enhanced Features Implemented
All brownie point features have been successfully implemented:
1. ✅ Pixel perfect design with proper spacing, fonts, and colors
2. ✅ Responsive UI handling keyboard appearance and viewport changes
3. ✅ Riverpod state management solution
4. ✅ Dio for API calls
5. ✅ Card sliding animation on selection
6. ✅ Button width animation for recording controls
7. ✅ Audio waveform visualization
8. ✅ Video recording with live preview
9. ✅ Media playback capabilities
10. ✅ Clean, scalable project structure

## Documentation
For more detailed information, please refer to:
- [Assignment Summary](ASSIGNMENT_SUMMARY.md) - Complete assignment breakdown and feature implementation
- [Technical Documentation](TECHNICAL_DOCUMENTATION.md) - Detailed technical implementation details

## Submission Information
- Developer: Abhishek Godara
- Email: abhishekgodara202226@gmail.com
- LinkedIn: https://www.linkedin.com/in/abhishek-godara-ab28a725a/
