import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hotspots_hostes/utils/app_colors.dart';

class CustomTextStyles {
  // Experience Selection Screen Styles
  static final TextStyle experienceSelectionTitleLarge =
      GoogleFonts.spaceGrotesk(
        fontWeight: FontWeight.w700, // 700
        fontSize: 24,
        height: 32 / 24,
        letterSpacing: -0.02 * 24, 
      );

  static final TextStyle experienceSelectionTitleSmall =
      GoogleFonts.spaceGrotesk(
        fontWeight: FontWeight.w400, // 400
        fontSize: 18,
        height: 21 / 14,
        letterSpacing: 0, 
      );

  static final TextStyle experienceDescriptionHint = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.normal, // 400
    fontSize: 20,
    color: AppColors.whiteBorder2,
    height: 28 / 20,
    letterSpacing: -0.01 * 20, 
  );

  // Onboarding Question Screen Styles
  static final TextStyle onboardingQuestionHint = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.normal, // 400
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0, 
  );

  // Video Card Styles
  static final TextStyle videoCardTitle = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    color: AppColors.textColorPrimary,
  );

  static final TextStyle videoCardSubtitle = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: AppColors.white,
  );

  static final TextStyle videoCardDuration = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.normal,
    fontSize: 13,
    color: AppColors.white54,
  );

  // Button Text Styles
  static final TextStyle buttonText = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.white,
    height: 24 / 16,
    letterSpacing: 0,
  );

  static final TextStyle buttonCaption = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: AppColors.white,
    height: 16 / 12, 
    letterSpacing: 0,
  );

  // App Bar Title Style
  static final TextStyle appBarTitle = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.white,
  );

  // Recording Status Styles
  static final TextStyle recordingStatus = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.white,
    height: 26 / 20, 
    letterSpacing: -0.01 * 20, 
  );

  // Media Info Styles
  static final TextStyle mediaInfoTitle = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColors.white,
    height: 24 / 16, 
    letterSpacing: 0,
  );

  static final TextStyle mediaInfoSubtitle = GoogleFonts.spaceGrotesk(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: AppColors.white,
    height: 20 / 14, 
    letterSpacing: 0,
  );
}
