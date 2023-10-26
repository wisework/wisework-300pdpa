import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/drawers/bloc/drawer_bloc.dart';
import 'package:pdpa/app/shared/drawers/models/drawer_menu_models.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class DrawerMenuTile extends StatefulWidget {
  const DrawerMenuTile({
    super.key,
    required this.menu,
  });

  final DrawerMenuModel menu;

  @override
  State<DrawerMenuTile> createState() => _DrawerMenuTileState();
}

class _DrawerMenuTileState extends State<DrawerMenuTile> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();

    _initialExpandMenu();
  }

  void _initialExpandMenu() {
    final bloc = context.read<DrawerBloc>();
    if (bloc.state is SelectedMenuDrawer) {
      // final parentMenu = widget.menu;
      final selectedMenu = (bloc.state as SelectedMenuDrawer).menu;

      // if (parentMenu.isParent && parentMenu.children!.contains(selectedMenu)) {
      //   _toggleExpandTile();
      // }
      if (selectedMenu.parent == "consent_management") {
        _toggleExpandTile();
      }
    }
  }

  void _toggleExpandTile() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _selectMenuDrawer(DrawerMenuModel menu) {
    context.read<DrawerBloc>().add(SelectMenuDrawerEvent(menu: menu));
    context.pushReplacement(menu.route.path);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: BlocBuilder<DrawerBloc, DrawerState>(
        builder: (context, state) {
          final selectedMenu =
              state is SelectedMenuDrawer ? state.menu.value : '';

          if (widget.menu.isParent) {
            final parentMenu =
                state is SelectedMenuDrawer ? state.menu.parent ?? '' : '';

            return Column(
              children: <Widget>[
                _buildMenuContainer(
                  context,
                  active: false,
                  onPressed: _toggleExpandTile,
                  child: _buildParentMenuTile(
                    context,
                    menu: widget.menu,
                    active: widget.menu.value == parentMenu,
                  ),
                ),
                _buildChildrenMenu(
                  context,
                  selectedMenu: selectedMenu,
                ),
              ],
            );
          }
          return _buildMenuContainer(
            context,
            active: widget.menu.value == selectedMenu,
            onPressed: () {
              _selectMenuDrawer(widget.menu);
            },
            child: _buildMenuTile(
              context,
              menu: widget.menu,
              active: widget.menu.value == selectedMenu,
            ),
          );
        },
      ),
    );
  }

  MaterialInkWell _buildMenuContainer(
    BuildContext context, {
    required bool active,
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return MaterialInkWell(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      ),
      backgroundColor: active
          ? Theme.of(context).colorScheme.surfaceTint.withOpacity(0.3)
          : null,
      splashColor: active
          ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
          : null,
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: child,
      ),
    );
  }

  Row _buildMenuTile(
    BuildContext context, {
    required DrawerMenuModel menu,
    required bool active,
  }) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: UiConfig.defaultPaddingSpacing,
            right: UiConfig.defaultPaddingSpacing,
            bottom: 2.0,
          ),
          child: Icon(
            menu.icon,
            color: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Expanded(
          child: Text(
            menu.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: active ? Theme.of(context).colorScheme.primary : null),
          ),
        ),
      ],
    );
  }

  Row _buildParentMenuTile(
    BuildContext context, {
    required DrawerMenuModel menu,
    required bool active,
  }) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: UiConfig.defaultPaddingSpacing,
            right: UiConfig.defaultPaddingSpacing,
            bottom: 2.0,
          ),
          child: Icon(
            widget.menu.icon,
            color: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Expanded(
          child: Text(
            widget.menu.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: active ? Theme.of(context).colorScheme.primary : null),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: UiConfig.defaultPaddingSpacing,
            right: UiConfig.defaultPaddingSpacing,
            bottom: 2.0,
          ),
          child: Icon(
            isExpanded
                ? Ionicons.caret_up_outline
                : Ionicons.caret_down_outline,
            size: 14.0,
            color: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  ExpandedContainer _buildChildrenMenu(
    BuildContext context, {
    required String selectedMenu,
  }) {
    return ExpandedContainer(
      expand: isExpanded,
      duration: const Duration(milliseconds: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: UiConfig.lineGap),
          ...widget.menu.children!.map((menu) {
            return Padding(
              padding: EdgeInsets.only(
                bottom:
                    menu != widget.menu.children!.last ? UiConfig.lineGap : 0,
              ),
              child: _buildMenuContainer(
                context,
                active: menu.value == selectedMenu,
                onPressed: () {
                  _selectMenuDrawer(menu);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: UiConfig.paragraphSpacing,
                  ),
                  child: _buildMenuTile(
                    context,
                    menu: menu,
                    active: menu.value == selectedMenu,
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
