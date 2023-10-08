import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';

class PdpaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PdpaAppBar({
    super.key,
    this.appBarHeight = kToolbarHeight,
    this.leadingIcon,
    required this.title,
    this.titleSpacing = UiConfig.appBarTitleSpacing,
    this.actions,
    this.bottom,
  });

  final double appBarHeight;
  final Widget? leadingIcon;
  final Widget title;
  final double titleSpacing;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Visibility(
            visible: leadingIcon != null,
            child: leadingIcon!,
          ),
          SizedBox(width: titleSpacing),
          title,
        ],
      ),
      actions: actions != null
          ? actions!.map((action) {
              if (action == actions!.last) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: action,
                );
              }
              return action;
            }).toList()
          : null,
      bottom: bottom,
      elevation: 1.0,
      shadowColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
