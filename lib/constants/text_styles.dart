import 'package:flutter/material.dart';
import 'package:hotspots_hostes/utils/app_colors.dart';

class CustomTextStyles {
  // Experience Selection Screen Styles
  static const TextStyle experienceSelectionTitleLarge = TextStyle(
    fontFamily: 'Space Grotesk',
    fontWeight: FontWeight.w700, // 700
    fontSize: 24,
    height: 32 / 24, // line-height: 32px / font-size: 24px
    letterSpacing: -0.02 * 24, // letter-spacing: -2% of 24px
  );

  static const TextStyle experienceSelectionTitleSmall = TextStyle(
    fontFamily: 'Space Grotesk',
    fontWeight: FontWeight.normal, // 400
    fontSize: 14,
    height: 20 / 14, // line-height: 20px / font-size: 14px
    letterSpacing: 0, // letter-spacing: 0%
  );

  static TextStyle experienceDescriptionHint = TextStyle(
    fontFamily: 'Space Grotesk',
    fontWeight: FontWeight.normal, // 400
    fontSize: 20,
    color: AppColors.whiteBorder2,
    height: 28 / 20, // line-height: 28px / font-size: 20px
    letterSpacing: -0.01 * 20, // letter-spacing: -1% of 20px
  );

  // Onboarding Question Screen Styles
  static const TextStyle onboardingQuestionHint = TextStyle(
    fontFamily: 'Space Grotesk',
    fontWeight: FontWeight.normal, // 400
    fontSize: 14,
    height: 20 / 14, // line-height: 20px / font-size: 14px
    letterSpacing: 0, // letter-spacing: 0%
  );
}
