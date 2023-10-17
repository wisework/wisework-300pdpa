import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WiseWorkShimmer extends StatelessWidget {
  const WiseWorkShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final logo = SizedBox(
      width: 180.0,
      child: Image.asset(
        'assets/images/wisework-logo.png',
        fit: BoxFit.contain,
      ),
    );

    return logo
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: Colors.white.withOpacity(0.5))
        .animate()
        .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad);
  }
}
