import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:pdpa/app/shared/utils/typedef.dart';

class ConsentThemeModel extends Equatable {
  const ConsentThemeModel({
    required this.id,
    required this.title,
    required this.headerBackgroundColor,
    required this.bodyBackgroundColor,
    required this.backgroundColor,
    required this.headerTextColor,
    required this.formTextColor,
    required this.categoryIconColor,
    required this.categoryTitleTextColor,
    required this.actionButtonColor,
    required this.linkToPolicyTextColor,
    required this.submitButtonColor,
    required this.submitTextColor,
    required this.cancelButtonColor,
    required this.cancelTextColor,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final String title;
  final Color headerBackgroundColor;
  final Color bodyBackgroundColor;
  final Color backgroundColor;
  final Color headerTextColor;
  final Color formTextColor;
  final Color categoryIconColor;
  final Color categoryTitleTextColor;
  final Color actionButtonColor;
  final Color linkToPolicyTextColor;
  final Color submitButtonColor;
  final Color submitTextColor;
  final Color cancelButtonColor;
  final Color cancelTextColor;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  ConsentThemeModel.empty()
      : this(
          id: '',
          title: '',
          headerBackgroundColor: Colors.transparent,
          bodyBackgroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          headerTextColor: Colors.transparent,
          formTextColor: Colors.transparent,
          categoryIconColor: Colors.transparent,
          categoryTitleTextColor: Colors.transparent,
          actionButtonColor: Colors.transparent,
          linkToPolicyTextColor: Colors.transparent,
          submitButtonColor: Colors.transparent,
          submitTextColor: Colors.transparent,
          cancelButtonColor: Colors.transparent,
          cancelTextColor: Colors.transparent,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  ConsentThemeModel.initial()
      : this(
          id: '',
          title: 'Default theme',
          headerBackgroundColor: const Color(0xFFFFFFFF),
          bodyBackgroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFFF3F2F2),
          headerTextColor: const Color(0xFF0172E6),
          formTextColor: const Color(0xFF000000),
          categoryIconColor: const Color(0xFF0172E6),
          categoryTitleTextColor: const Color(0xFF3A9FFD),
          actionButtonColor: const Color(0xFF0172E6),
          linkToPolicyTextColor: const Color(0xFF3A9FFD),
          submitButtonColor: const Color(0xFF0172E6),
          submitTextColor: const Color(0xFFFFFFFF),
          cancelButtonColor: const Color(0xFFFFFFFF),
          cancelTextColor: const Color(0xFF0172E6),
          createdBy: '',
          createdDate: DateTime.now(),
          updatedBy: '',
          updatedDate: DateTime.now(),
        );

  ConsentThemeModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: map['title'] as String,
          headerBackgroundColor: Color(
            int.parse('0x${map['headerBackgroundColor'] as String}'),
          ),
          bodyBackgroundColor: Color(
            int.parse('0x${map['bodyBackgroundColor'] as String}'),
          ),
          backgroundColor: Color(
            int.parse('0x${map['backgroundColor'] as String}'),
          ),
          headerTextColor: Color(
            int.parse('0x${map['headerTextColor'] as String}'),
          ),
          formTextColor: Color(
            int.parse('0x${map['formTextColor'] as String}'),
          ),
          categoryIconColor: Color(
            int.parse('0x${map['categoryIconColor'] as String}'),
          ),
          categoryTitleTextColor: Color(
            int.parse('0x${map['categoryTitleTextColor'] as String}'),
          ),
          actionButtonColor: Color(
            int.parse('0x${map['actionButtonColor'] as String}'),
          ),
          linkToPolicyTextColor: Color(
            int.parse('0x${map['linkToPolicyTextColor'] as String}'),
          ),
          submitButtonColor: Color(
            int.parse('0x${map['submitButtonColor'] as String}'),
          ),
          submitTextColor: Color(
            int.parse('0x${map['submitTextColor'] as String}'),
          ),
          cancelButtonColor: Color(
            int.parse('0x${map['cancelButtonColor'] as String}'),
          ),
          cancelTextColor: Color(
            int.parse('0x${map['cancelTextColor'] as String}'),
          ),
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'id': id,
        'title': title,
        'headerBackgroundColor': headerBackgroundColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'bodyBackgroundColor': bodyBackgroundColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'backgroundColor': backgroundColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'headerTextColor': headerTextColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'formTextColor':
            formTextColor.value.toRadixString(16).toUpperCase().padLeft(8, '0'),
        'categoryIconColor': categoryIconColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'categoryTitleTextColor': categoryTitleTextColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'actionButtonColor': actionButtonColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'linkToPolicyTextColor': linkToPolicyTextColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'submitButtonColor': submitButtonColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'submitTextColor': submitTextColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'cancelButtonColor': cancelButtonColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'cancelTextColor': cancelTextColor.value
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0'),
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory ConsentThemeModel.fromDocument(FirebaseDocument document) {
    Map<String, dynamic> response = document.data()!;
    response['id'] = document.id;
    return ConsentThemeModel.fromMap(response);
  }

  ConsentThemeModel copyWith({
    String? id,
    String? title,
    Color? headerBackgroundColor,
    Color? bodyBackgroundColor,
    Color? backgroundColor,
    Color? headerTextColor,
    Color? formTextColor,
    Color? categoryIconColor,
    Color? categoryTitleTextColor,
    Color? actionButtonColor,
    Color? linkToPolicyTextColor,
    Color? submitButtonColor,
    Color? submitTextColor,
    Color? cancelButtonColor,
    Color? cancelTextColor,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return ConsentThemeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      bodyBackgroundColor: bodyBackgroundColor ?? this.bodyBackgroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      formTextColor: formTextColor ?? this.formTextColor,
      categoryIconColor: categoryIconColor ?? this.categoryIconColor,
      categoryTitleTextColor:
          categoryTitleTextColor ?? this.categoryTitleTextColor,
      actionButtonColor: actionButtonColor ?? this.actionButtonColor,
      linkToPolicyTextColor:
          linkToPolicyTextColor ?? this.linkToPolicyTextColor,
      submitButtonColor: submitButtonColor ?? this.submitButtonColor,
      submitTextColor: submitTextColor ?? this.submitTextColor,
      cancelButtonColor: cancelButtonColor ?? this.cancelButtonColor,
      cancelTextColor: cancelTextColor ?? this.cancelTextColor,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      title,
      headerBackgroundColor,
      bodyBackgroundColor,
      backgroundColor,
      headerTextColor,
      formTextColor,
      categoryIconColor,
      categoryTitleTextColor,
      actionButtonColor,
      linkToPolicyTextColor,
      submitButtonColor,
      submitTextColor,
      cancelButtonColor,
      cancelTextColor,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
