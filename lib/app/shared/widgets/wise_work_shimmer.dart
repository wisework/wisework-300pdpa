import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WiseWorkShimmer extends StatelessWidget {
  const WiseWorkShimmer({
    super.key,
    this.width = 140.0,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    final logo = SizedBox(
      width: width,
      child: Image.asset(
        Theme.of(context).brightness == Brightness.light
            ? 'assets/images/general/dpo_online.png'
            : 'assets/images/general/dpo_online.png',
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
