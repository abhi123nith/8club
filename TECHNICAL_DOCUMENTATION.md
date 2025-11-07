# Technical Documentation - Hotspot Hosts Onboarding App

## Project Overview
This document provides detailed technical documentation for the Flutter application implementing the Hotspot Hosts Onboarding Questionnaire. The application consists of two primary screens that facilitate the host application process.

## Architecture

### State Management
The application uses **Riverpod** for state management, providing a robust and scalable approach to managing application state.

#### Providers:
- `experiencesProvider`: Fetches and caches experience data from API
- `selectedExperiencesProvider`: Manages selected experience IDs
- `experienceDescriptionProvider`: Stores experience description text
- `apiServiceProvider`: Provides API service instance

### Data Flow
1. Experience data is fetched from the API using `ApiService`
2. Data is cached and managed by Riverpod providers
3. User selections are stored in state providers
4. State is passed between screens via constructor parameters

## Screen Implementations

### 1. Experience Selection Screen (`experience_selection_screen.dart`)

#### Key Components:
- `ExperienceSelectionScreen`: Main widget that consumes Riverpod providers
- `ExperienceSelectionContent`: Stateful widget handling UI logic
- `WavePainter`: Custom painter for header wave animation
- `CustomCheckmark`: Custom widget for selection indicators

#### Features Implemented:
- **API Integration**: 
  - Fetches experiences from `https://staging.chamberofsecrets.8club.co/v1/experiences?active=true`
  - Falls back to mock data on API failure
- **Card Selection**:
  - Multi-select capability with visual feedback
  - Grayscale effect for unselected cards
  - Animated card repositioning on selection
- **UI/UX**:
  - Bottom-up layout with `Spacer` and `SizedBox` constraints
  - Responsive design handling keyboard appearance
  - Dynamic text sizing based on keyboard state
- **Animations**:
  - Wave animation in header using `CustomPainter`
  - Fade animation for next button
  - Scale animation for selected cards

#### State Management:
```dart
// Selected experiences stored as Set<int>
Set<int> _selectedIds = <int>{};

// Riverpod providers for global state
final selectedExperiencesProvider = StateProvider<Set<int>>((ref) => {});
final experienceDescriptionProvider = StateProvider<String>((ref) => '');
```

### 2. Onboarding Question Screen (`onboarding_question_screen.dart`)

#### Key Components:
- `OnboardingQuestionScreen`: Main stateful widget
- Audio recording with `flutter_sound` package
- Video recording with `camera` package
- Video playback with `video_player` package

#### Features Implemented:
- **Text Input**:
  - Multi-line text field with 600-character limit
  - Character counter with styling
- **Audio Recording**:
  - Live waveform visualization during recording
  - Playback controls for recorded audio
  - Delete functionality
- **Video Recording**:
  - Live camera preview during recording
  - Playback controls for recorded video
  - Camera switching (front/rear)
  - Pause/resume functionality
  - Delete functionality
- **Dynamic UI**:
  - Controls automatically hide after recording
  - Responsive layout for different screen sizes
  - Proper resource management

#### Media Handling:
```dart
// Audio recording
FlutterSoundRecorder _audioRecorder;
FlutterSoundPlayer _audioPlayer;

// Video recording
CameraController _cameraController;
VideoPlayerController _videoPlayerController;
```

## Services

### API Service (`api_service.dart`)
Handles all HTTP communications using the Dio package.

#### Methods:
- `getExperiences()`: Fetches active experiences from API
- Error handling with fallback to mock data

#### Implementation:
```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://staging.chamberofsecrets.8club.co/v1/',
));

Future<List<Experience>> getExperiences() async {
  try {
    final response = await dio.get('experiences?active=true');
    // Parse and return experience data
  } catch (e) {
    // Return mock data on failure
  }
}
```

## Models

### Experience Model (`experience.dart`)
Data class representing an experience with the following properties:
- `id`: Unique identifier
- `name`: Experience name
- `tagline`: Short description
- `description`: Detailed description
- `imageUrl`: Background image URL
- `iconUrl`: Icon image URL

## Constants

### Text Constants (`text_constants.dart`)
Centralized text strings for consistent reuse:
- Screen titles
- Input hints
- Button labels

### Text Styles (`text_styles.dart`)
Consistent text styling throughout the application:
- Title styles (large/small based on keyboard state)
- Description styles
- Hint styles

## UI Components

### Custom Widgets
- `WavePainter`: Animated wave effect in header
- `CustomCheckmark`: Styled checkmark for selections
- `NextButton`: Animated next button with fade effect

### Utility Components
- `ZigZagBackground`: Decorative background pattern
- `AppColors`: Centralized color palette

## Animations

### Implemented Animations:
1. **Wave Animation**: Continuous wave effect in screen header
2. **Card Selection**: Scale and position animation on card selection
3. **Button Fade**: Fade in/out effect for next button
4. **Button Width**: Width animation for recording controls

### Animation Controllers:
```dart
late AnimationController _waveController;     // Infinite wave animation
late AnimationController _fadeController;     // Button fade animation
late AnimationController _buttonAnimationController; // Recording button animation
```

## Responsive Design

### Keyboard Handling:
- Dynamic layout adjustment when keyboard appears
- Text size adjustment for better readability
- Scrollable content area to prevent overflow

### Implementation:
```dart
// Check if keyboard is open
final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

// Adjust text size based on keyboard state
style: isKeyboardOpen 
    ? CustomTextStyles.experienceSelectionTitleSmall
    : CustomTextStyles.experienceSelectionTitleLarge,
```

## Error Handling

### Permission Management:
- Microphone permission for audio recording
- Camera permission for video recording
- Graceful degradation when permissions denied

### API Error Handling:
- Fallback to mock data on API failure
- User feedback for network errors
- Retry mechanisms

### Media Error Handling:
- Proper resource disposal
- Error callbacks for recording/playback
- User notifications for media errors

## Performance Optimizations

### Resource Management:
- Proper disposal of controllers and resources
- Efficient widget rebuilding with `setState`
- Memory management for media files

### UI Optimizations:
- Lazy loading for experience cards
- Efficient list building with `ListView.builder`
- Proper use of `const` constructors

## Dependencies

### Core Dependencies:
- `flutter_riverpod: ^2.0.0` - State management
- `dio: ^5.0.0` - HTTP client
- `flutter_sound: ^9.2.13` - Audio recording/playback
- `camera: ^0.10.0` - Video recording
- `video_player: ^2.4.7` - Video playback
- `permission_handler: ^11.0.0` - Permission management
- `path_provider: ^2.0.11` - File system access

### Development Dependencies:
- `flutter_lints: ^5.0.0` - Code linting

## Testing Considerations

### Edge Cases Handled:
- API unavailability
- Permission denials
- Media recording errors
- Keyboard appearance/disappearance
- Orientation changes
- Network connectivity issues

### State Persistence:
- Selected experiences maintained during navigation
- Media files properly managed and cleaned up
- User input preserved during app lifecycle

## Future Enhancements

### Potential Improvements:
1. Unit and widget tests
2. Integration with backend for submission
3. Enhanced accessibility features
4. Dark/light theme support
5. Localization support
6. Advanced media editing features
7. Analytics integration

## Build and Deployment

### Supported Platforms:
- Android
- iOS
- Web
- Desktop (Windows, macOS, Linux)

### Build Commands:
```bash
# Development
flutter run

# Web deployment
flutter build web

# Android deployment
flutter build apk

# iOS deployment
flutter build ios
```

## Code Quality Standards

### Coding Practices:
- Consistent naming conventions
- Proper commenting and documentation
- Separation of concerns
- Reusable components
- Error handling at every level

### Performance Guidelines:
- Minimal rebuilds
- Efficient resource usage
- Proper async/await usage
- Memory leak prevention