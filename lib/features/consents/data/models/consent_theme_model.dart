import 'dart:convert';

import 'package:pdpa/core/utils/typedef.dart';
import 'package:pdpa/features/consents/domain/entities/consent_theme.dart';

class ConsentThemeModel extends ConsentTheme {
  const ConsentThemeModel({
    required super.themeId,
    required super.themeTitle,
    required super.headerTextColor,
    required super.headerBackgroundColor,
    required super.bodyBackgroundColor,
    required super.formTextColor,
    required super.categoryTitleTextColor,
    required super.acceptConsentTextColor,
    required super.linkToPolicyTextColor,
    required super.acceptButtonColor,
    required super.acceptTextColor,
    required super.cancelButtonColor,
    required super.cancelTextColor,
    required super.actionButtonColor,
    required super.createdBy,
    required super.createdDate,
    required super.updatedBy,
    required super.updatedDate,
    required super.companyId,
  });

  ConsentThemeModel.empty()
      : this(
          themeId: '',
          themeTitle: '',
          headerTextColor: '',
          headerBackgroundColor: '',
          bodyBackgroundColor: '',
          formTextColor: '',
          categoryTitleTextColor: '',
          acceptConsentTextColor: '',
          linkToPolicyTextColor: '',
          acceptButtonColor: '',
          acceptTextColor: '',
          cancelButtonColor: '',
          cancelTextColor: '',
          actionButtonColor: '',
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  ConsentThemeModel.fromMap(DataMap map)
      : this(
          themeId: map['themeId'] as String,
          themeTitle: map['themeTitle'] as String,
          headerTextColor: map['headerTextColor'] as String,
          headerBackgroundColor: map['headerBackgroundColor'] as String,
          bodyBackgroundColor: map['bodyBackgroundColor'] as String,
          formTextColor: map['formTextColor'] as String,
          categoryTitleTextColor: map['categoryTitleTextColor'] as String,
          acceptConsentTextColor: map['acceptConsentTextColor'] as String,
          linkToPolicyTextColor: map['linkToPolicyTextColor'] as String,
          acceptButtonColor: map['acceptButtonColor'] as String,
          acceptTextColor: map['acceptTextColor'] as String,
          cancelButtonColor: map['cancelButtonColor'] as String,
          cancelTextColor: map['cancelTextColor'] as String,
          actionButtonColor: map['actionButtonColor'] as String,
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
          companyId: map['companyId'] as String,
        );

  DataMap toMap() => {
        'themeId': themeId,
        'themeTitle': themeTitle,
        'headerTextColor': headerTextColor,
        'headerBackgroundColor': headerBackgroundColor,
        'bodyBackgroundColor': bodyBackgroundColor,
        'formTextColor': formTextColor,
        'categoryTitleTextColor': categoryTitleTextColor,
        'acceptConsentTextColor': acceptConsentTextColor,
        'linkToPolicyTextColor': linkToPolicyTextColor,
        'acceptButtonColor': acceptButtonColor,
        'acceptTextColor': acceptTextColor,
        'cancelButtonColor': cancelButtonColor,
        'cancelTextColor': cancelTextColor,
        'actionButtonColor': actionButtonColor,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
        'companyId': companyId,
      };

  factory ConsentThemeModel.fromJson(String source) =>
      ConsentThemeModel.fromMap(json.decode(source) as DataMap);

  String toJson() => json.encode(toMap());

  ConsentThemeModel copyWith({
    String? themeId,
    String? themeTitle,
    String? headerTextColor,
    String? headerBackgroundColor,
    String? bodyBackgroundColor,
    String? formTextColor,
    String? categoryTitleTextColor,
    String? acceptConsentTextColor,
    String? linkToPolicyTextColor,
    String? acceptButtonColor,
    String? acceptTextColor,
    String? cancelButtonColor,
    String? cancelTextColor,
    String? actionButtonColor,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
    String? companyId,
  }) {
    return ConsentThemeModel(
      themeId: themeId ?? this.themeId,
      themeTitle: themeTitle ?? this.themeTitle,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      bodyBackgroundColor: bodyBackgroundColor ?? this.bodyBackgroundColor,
      formTextColor: formTextColor ?? this.formTextColor,
      categoryTitleTextColor:
          categoryTitleTextColor ?? this.categoryTitleTextColor,
      acceptConsentTextColor:
          acceptConsentTextColor ?? this.acceptConsentTextColor,
      linkToPolicyTextColor:
          linkToPolicyTextColor ?? this.linkToPolicyTextColor,
      acceptButtonColor: acceptButtonColor ?? this.acceptButtonColor,
      acceptTextColor: acceptTextColor ?? this.acceptTextColor,
      cancelButtonColor: cancelButtonColor ?? this.cancelButtonColor,
      cancelTextColor: cancelTextColor ?? this.cancelTextColor,
      actionButtonColor: actionButtonColor ?? this.actionButtonColor,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
      companyId: companyId ?? this.companyId,
    );
  }
}
