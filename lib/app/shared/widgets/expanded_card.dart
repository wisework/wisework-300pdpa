import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';

import 'material_ink_well.dart';

class ExpandedCard extends StatefulWidget {
  const ExpandedCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final Widget title;
  final Widget subtitle;

  @override
  State<ExpandedCard> createState() => _ExpandedCardState();
}

class _ExpandedCardState extends State<ExpandedCard> {
  bool isExpanded = false;

  void _setCardExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialInkWell(
      borderRadius: BorderRadius.circular(4.0),
      onTap: _setCardExpand,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: widget.title,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: UiConfig.actionSpacing,
                  right: UiConfig.actionSpacing,
                  bottom: 2.0,
                ),
                child: Icon(
                  isExpanded
                      ? Ionicons.caret_up_outline
                      : Ionicons.caret_down_outline,
                  size: 14.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          ExpandedContainer(
            expand: isExpanded,
            duration: const Duration(milliseconds: 400),
            child: widget.subtitle,
          ),
        ],
      ),
    );
  }
}
