import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GradientNextButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;

  const GradientNextButton({
    super.key,
    required this.isEnabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        opacity: isEnabled ? 1.0 : 0.7,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            // Outer gradient border container
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x66FFFFFF), // bright edge top-left
                Color(0x33FFFFFF), // subtle mid transition
                Color(0x0DFFFFFF), // soft bottom-right fade
              ],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(1.5), // border thickness
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 19, 19, 19), // dark top-left
                  Color.fromARGB(153, 157, 155, 155),
                  Color.fromARGB(153, 157, 155, 155),

                  Color.fromARGB(255, 19, 19, 19),
                ],
                stops: [0.0, 0.6, 0.5, 1.0],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                  spreadRadius: 0.4,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: isEnabled ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled
                    ? Colors.transparent
                    : Colors.black38,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Next",
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 16,
                      color: !isEnabled
                          ? const Color(0xFFFFFFFF)
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/icons/arrow_forward.svg',
                    width: 18,
                    color: Colors.white,
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
