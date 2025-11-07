import 'package:flutter/material.dart';
import 'package:hotspots_hostes/utils/app_colors.dart';
import 'package:hotspots_hostes/widgets/shimmer_loading.dart';

class ShimmerExperienceCard extends StatelessWidget {
  final double width;
  final double height;
  final double verticalOffset;
  final double tiltAngle;

  const ShimmerExperienceCard({
    super.key,
    this.width = 140,
    this.height = 180,
    this.verticalOffset = 0,
    this.tiltAngle = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, verticalOffset),
      child: Transform.rotate(
        angle: tiltAngle,
        child: Container(
          margin: const EdgeInsets.only(right: 18),
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ShimmerLoading(
            isLoading: true,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.white14,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white29,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.white29.withOpacity(0.3),
                          AppColors.black10.withOpacity(0.7),
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
  }
}
