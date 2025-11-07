import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspots_hostes/constants/text_constants.dart';
import 'package:hotspots_hostes/constants/text_styles.dart';
import 'package:hotspots_hostes/models/experience.dart';
import 'package:hotspots_hostes/models/wave_line.dart';
import 'package:hotspots_hostes/providers/experience_provider.dart';
import 'package:hotspots_hostes/screens/onboarding_question_screen.dart';
import 'package:hotspots_hostes/utils/app_colors.dart';
import 'package:hotspots_hostes/utils/next_button.dart';
import 'package:hotspots_hostes/utils/zig_zag_background.dart';

class ExperienceSelectionScreen extends ConsumerWidget {
  const ExperienceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiencesAsync = ref.watch(experiencesProvider);

    return ExperienceSelectionContent(experiencesAsync: experiencesAsync);
  }
}

class ExperienceSelectionContent extends ConsumerStatefulWidget {
  final AsyncValue<List<Experience>> experiencesAsync;

  const ExperienceSelectionContent({super.key, required this.experiencesAsync});

  @override
  ConsumerState<ExperienceSelectionContent> createState() =>
      _ExperienceSelectionContentState();
}

class _ExperienceSelectionContentState
    extends ConsumerState<ExperienceSelectionContent>
    with TickerProviderStateMixin {
  final TextEditingController _descController = TextEditingController();

  final Set<int> _selectedIds = <int>{};
  late AnimationController _waveController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fadeController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _toggleSelection(int id, List<Experience> experiences) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
        // Move selected card to first position
        _moveCardToFirst(id, experiences);
      }
    });
  }

  void _moveCardToFirst(int id, List<Experience> experiences) {
    // This is handled in the UI by reordering the list
  }

  void _navigateToNextScreen() {
    // Log the state
    debugPrint("Selected Experience IDs: $_selectedIds");
    debugPrint("Description: ${_descController.text}");

    // Store the selected experience ids and text in the state
    ref.read(selectedExperiencesProvider.notifier).state = _selectedIds;
    ref.read(experienceDescriptionProvider.notifier).state =
        _descController.text;

    // Navigate to the onboarding screen with a smooth transition
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 360),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            OnboardingQuestionScreen(
              selectedExperienceIds: _selectedIds.toList(),
              experienceDescription: _descController.text,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Combine a subtle slide with a fade for a smooth entrance
          final tween = Tween<Offset>(
            begin: const Offset(0.0, 0.06),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOut));
          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: fade, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if keyboard is open
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // Check if next button should be enabled
    final bool isNextEnabled =
        _selectedIds.isNotEmpty || _descController.text.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ZigzagBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Top bar at the top
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {},
                    ),
                    StaticWaveformLine(fillFraction: 0.3),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Container(
                color: AppColors.black10,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          TextConstants.experienceSelectionTitle,
                          style: isKeyboardOpen
                              ? CustomTextStyles.experienceSelectionTitleSmall
                              : CustomTextStyles.experienceSelectionTitleLarge,
                        ),
                      ),

                      SizedBox(height: isKeyboardOpen ? 10 : 28),

                      // Experience cards
                      Container(
                        padding: EdgeInsets.only(left: 3),
                        margin: EdgeInsets.only(left:  12),
                        color: Colors.black,
                        height: isKeyboardOpen ? 150 : 180,
                        child: widget.experiencesAsync.when(
                          data: (experiences) {
                            final List<Experience> reorderedExperiences = [];
                            final List<Experience> selectedExperiences = [];
                            final List<Experience> unselectedExperiences = [];
                            for (final exp in experiences) {
                              if (_selectedIds.contains(exp.id)) {
                                selectedExperiences.add(exp);
                              } else {
                                unselectedExperiences.add(exp);
                              }
                            }

                            reorderedExperiences.addAll(selectedExperiences);
                            reorderedExperiences.addAll(unselectedExperiences);

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: reorderedExperiences.length,
                              itemBuilder: (context, index) {
                                final exp = reorderedExperiences[index];
                                final bool isSelected = _selectedIds.contains(
                                  exp.id,
                                );

                                final double verticalOffset = index.isEven
                                    ? -10.0
                                    : 10.0;

                                final double tiltAngle = 0.06 - (index * 0.07);

                                return Transform.translate(
                                  offset: Offset(0, verticalOffset),
                                  child: Transform.rotate(
                                    angle: tiltAngle,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _toggleSelection(exp.id, experiences),
                                      child: AnimatedScale(
                                        scale: isSelected ? 1.1 : 1.0,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeInOut,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 18,
                                          ),
                                          width: 140,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      exp.imageUrl,
                                                    ),
                                                    fit: BoxFit.contain,
                                                    colorFilter: isSelected
                                                        ? null
                                                        : const ColorFilter.mode(
                                                            Colors.grey,
                                                            BlendMode
                                                                .saturation,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              // Overlay gradient
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black.withOpacity(
                                                        0.5,
                                                      ),
                                                      Colors.black.withOpacity(
                                                        0.8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF9196FF),
                              ),
                            ),
                          ),
                          error: (error, stack) {
                            // Fallback to mock data if API fails
                            final mockExperiences = _getMockExperiences();
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: mockExperiences.length,
                              itemBuilder: (context, index) {
                                final exp = mockExperiences[index];
                                final bool isSelected = _selectedIds.contains(
                                  index,
                                );

                                final double verticalOffset = index.isEven
                                    ? -10.0
                                    : 10.0;

                                final double tiltAngle = 0.06 - (index * 0.07);

                                return Transform.translate(
                                  offset: Offset(0, verticalOffset),
                                  child: Transform.rotate(
                                    angle: tiltAngle,
                                    child: GestureDetector(
                                      onTap: () => _toggleSelection(index, []),
                                      child: AnimatedScale(
                                        scale: isSelected ? 1.1 : 1.0,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeInOut,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 18,
                                          ),
                                          width: 140,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: [
                                              // Background color
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: exp["color"],
                                                ),
                                              ),
                                              // Overlay
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black.withOpacity(
                                                        0.5,
                                                      ),
                                                      Colors.black.withOpacity(
                                                        0.8,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Text field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.textFieldBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: isKeyboardOpen ?  Border.all(color: AppColors.blue5961FF) : null,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _descController,
                            maxLines: 4,
                            maxLength: 250,

                            style: TextStyle(
                              color: AppColors.white,
                              fontFamily: 'Space Grotesk',
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,

                              hintText: TextConstants.experienceDescriptionHint,
                              hintStyle:
                                  CustomTextStyles.experienceDescriptionHint,
                              counterStyle: TextStyle(
                                color: AppColors.whiteB8,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isKeyboardOpen ? 10 : 24),

                      GradientNextButton(
                        isEnabled: isNextEnabled,
                        onPressed: isNextEnabled ? _navigateToNextScreen : null,
                      ),
                      SizedBox(height: isKeyboardOpen ? 0 : 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mock data for fallback
  List<Map<String, dynamic>> _getMockExperiences() {
    return [
      {"name": "PARTY", "color": Colors.brown, "tagline": "Fun gatherings"},
      {
        "name": "DINNER",
        "color": Colors.grey.shade700,
        "tagline": "Fine dining",
      },
      {
        "name": "BRUNCH",
        "color": Colors.blueAccent,
        "tagline": "Morning meals",
      },
      {
        "name": "MOVIE",
        "color": Colors.greenAccent.shade400,
        "tagline": "Film nights",
      },
      {
        "name": "PICNIC",
        "color": Colors.purpleAccent,
        "tagline": "Outdoor fun",
      },
    ];
  }
}
