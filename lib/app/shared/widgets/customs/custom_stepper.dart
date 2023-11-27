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
    this.previousButtonText,
    this.onPreviousStep,
    this.nextButtonText,
    this.onNextStep,
    this.activeColor,
    this.checkIcon = false,
    this.showContentInSummary = false,
    this.hideStepperControls = false,
  });

  final EdgeInsets? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final List<CustomStep> steps;
  final int currentStep;
  final String? previousButtonText;
  final VoidCallback? onPreviousStep;
  final String? nextButtonText;
  final VoidCallback? onNextStep;
  final Color? activeColor;
  final bool checkIcon;
  final bool showContentInSummary;
  final bool hideStepperControls;

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  final double _kStepSize = 24.0;
  final double _kCircleSpacing = 12.0;

  bool _isCurrent(int index) {
    return widget.currentStep == index;
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
      child: widget.checkIcon
          ? AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: kThemeAnimationDuration,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                border: Border.all(
                  color: widget.currentStep >= index
                      ? widget.activeColor ??
                          Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                  width: 1.0,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Opacity(
                  opacity: widget.currentStep >= index ? 1.0 : 0,
                  child: Icon(
                    Icons.check,
                    size: 12.0,
                    color: widget.activeColor ??
                        Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            )
          : AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: kThemeAnimationDuration,
              decoration: BoxDecoration(
                color: widget.currentStep >= index
                    ? widget.activeColor ??
                        Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
    );
  }

  Stack _buildVerticalBody(BuildContext context, int index) {
    const verticalLineWidth = 8.0;
    const horizontalPadding = 24.0;

    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: verticalLineWidth,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: verticalLineWidth,
            child: Center(
              child: SizedBox(
                width: 1.0,
                child: Container(
                  color: widget.currentStep > index
                      ? widget.activeColor ??
                          Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
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
              start: verticalLineWidth + horizontalPadding + 6.0,
              end: horizontalPadding,
            ),
            child: Column(
              children: <Widget>[
                widget.steps[index].content,
                if (_isCurrent(index) && !widget.hideStepperControls)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: _buildControlsBuilder(
                      context,
                      details: ControlsDetails(
                        currentStep: widget.currentStep,
                        onStepCancel: widget.onPreviousStep,
                        onStepContinue: widget.onNextStep,
                        stepIndex: index,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        widget.showContentInSummary
            ? Visibility(
                visible: widget.currentStep > index,
                child: ExpandedContainer(
                  expand: widget.currentStep >= index,
                  duration: const Duration(milliseconds: 400),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: verticalLineWidth + horizontalPadding + 6.0,
                      end: horizontalPadding,
                    ),
                    child: widget.steps[index].content,
                  ),
                ),
              )
            : Visibility(
                visible: widget.steps[index].summaryContent != null &&
                    widget.currentStep > index,
                child: ExpandedContainer(
                  expand: widget.currentStep >= index,
                  duration: const Duration(milliseconds: 400),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: verticalLineWidth + horizontalPadding + 6.0,
                      end: horizontalPadding,
                    ),
                    child: widget.steps[index].summaryContent,
                  ),
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
                      vertical: 6.0,
                      horizontal: 10.0,
                    ),
                    child: Text(
                      widget.previousButtonText ?? 'ย้อนกลับ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                      vertical: 6.0,
                      horizontal: 10.0,
                    ),
                    child: Text(
                      widget.nextButtonText ?? ('app.next'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
