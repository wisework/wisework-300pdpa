import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerMenuModel {
  final String value;
  final String title;
  final IconData icon;
  final GoRoute route;
  final List<DrawerMenuModel>? children;
  final String? parent;

  DrawerMenuModel({
    required this.value,
    required this.title,
    required this.icon,
    required this.route,
    this.children,
    this.parent,
  });

  bool get isParent => children != null && children!.isNotEmpty;

  bool get isChild => parent != null && parent!.isNotEmpty;
}
