import 'package:flutter/material.dart';

class ExpandedContainer extends StatefulWidget {
  const ExpandedContainer({
    super.key,
    this.expand = false,
    this.duration = const Duration(milliseconds: 800),
    required this.child,
  });

  final bool expand;
  final Duration duration;
  final Widget child;

  @override
  State<ExpandedContainer> createState() => _ExpandedContainerState();
}

class _ExpandedContainerState extends State<ExpandedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _prepareAnimations();
    _expandToggle();
  }

  @override
  void dispose() {
    expandController.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExpandedContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    _expandToggle();
  }

  void _prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _expandToggle() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1.0,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
