import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ExploreActivity extends Equatable {
  const ExploreActivity({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.path,
  });

  final String title;
  final String subTitle;
  final IconData icon;
  final String path;

  ExploreActivity copyWith({
    String? title,
    String? subTitle,
    IconData? icon,
    String? path,
  }) {
    return ExploreActivity(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      icon: icon ?? this.icon,
      path: path ?? this.path,
    );
  }

  @override
  List<Object> get props => [title, subTitle, icon, path];
}
