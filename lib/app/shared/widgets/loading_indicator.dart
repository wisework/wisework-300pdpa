import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

enum LoadingType { inkDrop, horizontalRotatingDots }

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color,
    this.size = 45.0,
    this.loadingType = LoadingType.inkDrop,
  });

  final Color? color;
  final double size;
  final LoadingType loadingType;

  @override
  Widget build(BuildContext context) {
    return _buildLoadingAnimation(context);
  }

  Widget _buildLoadingAnimation(BuildContext context) {
    switch (loadingType) {
      case LoadingType.horizontalRotatingDots:
        return LoadingAnimationWidget.horizontalRotatingDots(
          color: color ?? Theme.of(context).colorScheme.primary,
          size: size,
        );
      default:
        return LoadingAnimationWidget.inkDrop(
          color: color ?? Theme.of(context).colorScheme.primary,
          size: size,
        );
    }
  }
}
