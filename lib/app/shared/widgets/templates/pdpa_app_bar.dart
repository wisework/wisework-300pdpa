import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';

class PdpaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PdpaAppBar({
    super.key,
    this.leadingIcon,
    required this.title,
    this.titleSpacing = UiConfig.appBarTitleSpacing,
    this.actions,
  });

  final Widget? leadingIcon;
  final Widget title;
  final double titleSpacing;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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
      elevation: 1.0,
      shadowColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}
