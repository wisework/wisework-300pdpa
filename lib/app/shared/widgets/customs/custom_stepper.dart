import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';

class CustomStep {
  const CustomStep({
    required this.title,
    this.subtitle,
    required this.content,
    this.summaryContent,
    this.state = StepState.indexed,
    this.isActive = false,
    this.label,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget content;
  final Widget? summaryContent;
  final StepState state;
  final bool isActive;
  final Widget? label;
}

class CustomStepper extends StatefulWidget {
  const CustomStepper({
    super.key,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    required this.steps,
    this.currentStep = 0,
    this.progressStep = 0,
    this.onStepCancel,
    this.onStepContinue,
  });

  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final List<CustomStep> steps;
  final int currentStep;
  final int progressStep;
  final VoidCallback? onStepCancel;
  final VoidCallback? onStepContinue;

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  final double _kStepSize = 24.0;
  final double _kCircleSpacing = 12.0;

  bool _isCurrent(int index) {
    return widget.currentStep == index;
  }

  bool _isLast(int index) {
    return (widget.steps.length - 1) == index;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing,
          ),
      child: ListView.builder(
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        itemBuilder: (context, index) {
          return _buildStepItem(context, index);
        },
        itemCount: widget.steps.length,
      ),
    );
  }

  Column _buildStepItem(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: _kCircleSpacing),
              child: _buildCircle(index),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.steps[index].title,
                  if (widget.steps[index].subtitle != null)
                    widget.steps[index].subtitle!,
                ],
              ),
            ),
          ],
        ),
        _buildVerticalBody(context, index),
      ],
    );
  }

  Container _buildCircle(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: widget.progressStep >= index
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }

  Stack _buildVerticalBody(BuildContext context, int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 24.0,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: 24.0,
            child: Center(
              child: SizedBox(
                width: 1.0,
                child: Container(
                  color: _isCurrent(index)
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        ExpandedContainer(
          expand: _isCurrent(index),
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 60.0,
              end: 24.0,
            ),
            child: Column(
              children: <Widget>[
                widget.steps[index].content,
                _isCurrent(index)
                    ? _buildControlsBuilder(
                        context,
                        details: ControlsDetails(
                          currentStep: widget.currentStep,
                          onStepCancel: widget.onStepCancel,
                          onStepContinue: widget.onStepContinue,
                          stepIndex: index,
                        ),
                      )
                    : const SizedBox(height: 60.0),
              ],
            ),
          ),
        ),
        if (widget.steps[index].summaryContent != null)
          ExpandedContainer(
            expand: !_isCurrent(index),
            duration: const Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 60.0,
                end: 24.0,
              ),
              child: widget.steps[index].summaryContent,
            ),
          ),
      ],
    );
  }

  Padding _buildControlsBuilder(
    BuildContext context, {
    required ControlsDetails details,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: UiConfig.lineSpacing,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          details.onStepCancel != null
              ? CustomButton(
                  onPressed: details.onStepCancel!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 12.0,
                    ),
                    child: Text(
                      'ย้อนกลับ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                )
              : Container(),
          details.onStepContinue != null
              ? CustomButton(
                  onPressed: details.onStepContinue!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 12.0,
                    ),
                    child: Text(
                      'ถัดไป',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
