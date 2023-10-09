

import 'package:equatable/equatable.dart';

import 'package:pdpa/app/shared/utils/typedef.dart';

class ConsentThemeModel extends Equatable {
  const ConsentThemeModel({
    required this.consentThemeId,
    required this.themeTitle,
    required this.headerTextColor,
    required this.headerBackgroundColor,
    required this.bodyBackgroundColor,
    required this.formTextColor,
    required this.categoryTitleTextColor,
    required this.acceptConsentTextColor,
    required this.linkToPolicyTextColor,
    required this.acceptButtonColor,
    required this.acceptTextColor,
    required this.cancelButtonColor,
    required this.cancelTextColor,
    required this.actionButtonColor,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
  });

  final String consentThemeId;
  final String themeTitle;
  final String headerTextColor;
  final String headerBackgroundColor;
  final String bodyBackgroundColor;
  final String formTextColor;
  final String categoryTitleTextColor;
  final String acceptConsentTextColor;
  final String linkToPolicyTextColor;
  final String acceptButtonColor;
  final String acceptTextColor;
  final String cancelButtonColor;
  final String cancelTextColor;
  final String actionButtonColor;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  final String companyId;

  ConsentThemeModel.empty()
      : this(
          consentThemeId: '',
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
          consentThemeId: map['consentThemeId'] as String,
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
        'consentThemeId': consentThemeId,
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

  factory ConsentThemeModel.fromDocument(FirebaseDocument document) {
    Map<String, dynamic> response = document.data()!;
    response['consentThemeId'] = document.id;
    return ConsentThemeModel.fromMap(response);
  }

  ConsentThemeModel copyWith({
    String? consentThemeId,
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
      consentThemeId: consentThemeId ?? this.consentThemeId,
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

  @override
  List<Object> get props {
    return [
      consentThemeId,
      themeTitle,
      headerTextColor,
      headerBackgroundColor,
      bodyBackgroundColor,
      formTextColor,
      categoryTitleTextColor,
      acceptConsentTextColor,
      linkToPolicyTextColor,
      acceptButtonColor,
      acceptTextColor,
      cancelButtonColor,
      cancelTextColor,
      actionButtonColor,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
      companyId,
    ];
  }
}
