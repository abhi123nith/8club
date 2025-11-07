# Flutter Internship Assignment - Hotspot Hosts Onboarding

## Overview
This Flutter application implements a complete onboarding questionnaire for Hotspot Hosts. Hotspot hosts are individuals who facilitate and manage events or gatherings at designated locations. The application consists of two main screens that assess the suitability and readiness of applicants for the host role.

## Assignment Breakdown

### 1. Experience Type Selection Screen

#### Implemented Features:
- **API Integration**: Fetches experience list from `https://staging.chamberofsecrets.8club.co/v1/experiences?active=true`
- **Graceful Fallback**: Uses mock data when API is unreachable
- **Card Selection**: 
  - Displays experience cards with `image_url` as background
  - Implements selection/deselection functionality
  - Shows grayscale effect for unselected cards
  - Supports multiple card selections
- **UI/UX Features**:
  - Clean UI with proper spacing and styling
  - Animated card movements on selection
  - Wave animation in the header
  - Responsive design that handles keyboard appearance
- **State Management**:
  - Stores selected experience IDs and description text
  - Uses Riverpod for state management
  - Logs state and navigates to next screen on "Next" button click

### 2. Onboarding Question Screen

#### Implemented Features:
- **Text Input**: Multi-line text field with 600-character limit
- **Audio Recording**:
  - Records audio responses with visual waveform
  - Play/pause/stop functionality
  - Delete recorded audio
  - Visual feedback during recording
- **Video Recording**:
  - Records video responses with live camera preview
  - Play/pause functionality for recorded videos
  - Delete recorded videos
  - Camera switching (front/rear)
  - Pause/resume during recording
- **Dynamic UI**:
  - Removes recording buttons after asset is recorded
  - Responsive layout that adapts to keyboard appearance
  - Clean, intuitive interface

## Brownie Points (Optional Enhancements Implemented)

### UI/UX Enhancements:
- **Pixel Perfect Design**: Follows design specifications with proper spacings, fonts, and colors
- **Responsive UI**: Handles keyboard appearance and viewport height changes gracefully
- **Visual Feedback**: Animated transitions and state indicators throughout the app

### State Management:
- **Riverpod Implementation**: Comprehensive state management using flutter_riverpod
- **Dio Integration**: API calls managed with Dio package
- **Persistent State**: Properly maintains and passes state between screens

### Animations:
- **Experience Screen**: 
  - Card sliding animation to first position on selection
  - Wave animation in the header
  - Fade animation for the next button
- **Question Screen**:
  - Button width animation when recording controls appear/disappear
  - Smooth transitions between recording states

### Additional Features:
- **Media Handling**: Complete audio and video recording, playback, and management
- **Error Handling**: Graceful handling of permissions and recording errors
- **Resource Management**: Proper disposal of media resources
- **Cross-Platform**: Works on both mobile and web platforms

## Technical Implementation Details

### Project Structure:
```
lib/
├── main.dart              # App entry point
├── models/
│   └── experience.dart    # Data model for Experience
├── screens/
│   ├── experience_selection_screen.dart
│   └── onboarding_question_screen.dart
├── services/
│   └── api_service.dart   # Handles API calls
├── providers/
│   └── experience_provider.dart # Riverpod state management
├── constants/
│   ├── text_constants.dart
│   └── text_styles.dart
└── utils/
    ├── app_colors.dart
    ├── next_button.dart
    └── zig_zag_background.dart
```

### Dependencies Used:
- `flutter_riverpod` - State management
- `dio` - HTTP client for API calls
- `flutter_sound` - Audio recording and playback
- `camera` - Video recording
- `video_player` - Video playback
- `permission_handler` - Permission management
- `path_provider` - File system access

### Key Features Implementation:

#### Experience Selection Screen:
- Fetches live experiences from API with mock fallback
- Implements card-based UI with image backgrounds
- Grayscale effect for unselected items
- Multi-select support with visual feedback
- Animated card repositioning on selection
- Responsive design with keyboard handling

#### Onboarding Question Screen:
- Text input with character limit
- Audio recording with waveform visualization
- Video recording with live preview
- Media playback capabilities
- Dynamic UI that hides controls after recording
- Camera direction switching (front/rear)
- Pause/resume functionality for video recording

## Code Quality
- Clean, readable code with proper comments
- Scalable project structure with separated concerns
- Consistent naming conventions
- Proper error handling and edge case management
- Efficient resource management and disposal

## Running Instructions

### On Chrome (Recommended):
```bash
flutter run -d chrome
```

### On Android Device/Emulator:
```bash
flutter run
```

## Submission Compliance
This implementation fully complies with all requirements and exceeds expectations by implementing all brownie point features:
1. ✓ Pixel perfect design with proper spacing, fonts, and colors
2. ✓ Responsive UI handling keyboard appearance
3. ✓ Riverpod state management solution
4. ✓ Dio for API calls
5. ✓ Card sliding animation on selection
6. ✓ Button width animation for recording controls
7. ✓ Audio waveform visualization
8. ✓ Video recording with live preview
9. ✓ Media playback capabilities
10. ✓ Clean, scalable project structure