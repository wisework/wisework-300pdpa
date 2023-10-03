// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class ConsentFormModel extends Equatable {
  const ConsentFormModel({
    required this.consentFormId,
    required this.consentThemeId,
    required this.title,
    required this.description,
    required this.purposeCategories,
    required this.customFields,
    required this.consentformUrl,
    required this.headerText,
    required this.headerDescription,
    required this.footerDescription,
    required this.acceptConsentText,
    required this.acceptText,
    required this.cancelText,
    required this.linkToPolicyText,
    required this.linkToPolicyUrl,
    required this.logoImage,
    required this.headerBackgroundImage,
    required this.bodyBackgroundImage,
    required this.uid,
    required this.status,
    required this.version,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String consentFormId;
  final String consentThemeId;
  final List<LocalizedModel> title;
  final List<LocalizedModel> description;
  final List<String> purposeCategories;
  final List<String> customFields;
  final String consentformUrl;
  final List<LocalizedModel> headerText;
  final List<LocalizedModel> headerDescription;
  final List<LocalizedModel> footerDescription;
  final List<LocalizedModel> acceptConsentText;
  final List<LocalizedModel> acceptText;
  final List<LocalizedModel> cancelText;
  final List<LocalizedModel> linkToPolicyText;
  final String linkToPolicyUrl;
  final String logoImage;
  final String headerBackgroundImage;
  final String bodyBackgroundImage;
  final String uid;
  final ActiveStatus status;
  final int version;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  ConsentFormModel.empty()
      : this(
          consentFormId: '',
          consentThemeId: '',
          title: [],
          description: [],
          purposeCategories: [],
          customFields: [],
          consentformUrl: '',
          headerText: [],
          headerDescription: [],
          footerDescription: [],
          acceptConsentText: [],
          acceptText: [],
          cancelText: [],
          linkToPolicyText: [],
          linkToPolicyUrl: '',
          logoImage: '',
          headerBackgroundImage: '',
          bodyBackgroundImage: '',
          uid: '',
          status: ActiveStatus.active,
          version: 1,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  ConsentFormModel.fromMap(DataMap map)
      : this(
          consentFormId: map['consentFormId'] as String,
          consentThemeId: map['consentThemeId'] as String,
          title: List<LocalizedModel>.from((map['title'] as List<dynamic>)
              .map<LocalizedModel>((item) => LocalizedModel.fromMap(item))),
          description: List<LocalizedModel>.from(
              (map['description'] as List<dynamic>)
                  .map<LocalizedModel>((item) => LocalizedModel.fromMap(item))),
          purposeCategories:
              List<String>.from(map['purposeCategories'] as List<dynamic>),
          customFields: List<String>.from(map['customFields'] as List<dynamic>),
          consentformUrl: map['consentformUrl'] as String,
          headerText: List<LocalizedModel>.from(
              (map['headerText'] as List<dynamic>)
                  .map<LocalizedModel>((item) => LocalizedModel.fromMap(item))),
          headerDescription: List<LocalizedModel>.from(
              (map['headerDescription'] as List<dynamic>)
                  .map<LocalizedModel>((item) => LocalizedModel.fromMap(item))),
          footerDescription: List<LocalizedModel>.from(
              (map['footerDescription'] as List<dynamic>)
                  .map<LocalizedModel>((item) => LocalizedModel.fromMap(item))),
          acceptConsentText: List<LocalizedModel>.from(
              (map['acceptConsentText'] as List<dynamic>)
                  .map<LocalizedModel>((item) => LocalizedModel.fromMap(item))),
          acceptText: List<LocalizedModel>.from(
              (map['acceptText'] as List<dynamic>)
                  .map<LocalizedModel>((item) => LocalizedModel.fromMap(item))),
          cancelText: List<LocalizedModel>.from(
              (map['cancelText'] as List<dynamic>)
                  .map<LocalizedModel>((item) => LocalizedModel.fromMap(item))),
          linkToPolicyText: List<LocalizedModel>.from(
              (map['linkToPolicyText'] as List<dynamic>)
                  .map<LocalizedModel>((item) => LocalizedModel.fromMap(item))),
          linkToPolicyUrl: map['linkToPolicyUrl'] as String,
          logoImage: map['logoImage'] as String,
          headerBackgroundImage: map['headerBackgroundImage'] as String,
          bodyBackgroundImage: map['bodyBackgroundImage'] as String,
          uid: map['uid'] as String,
          status: ActiveStatus.values[map['status'] as int],
          version: map['version'] as int,
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'consentFormId': consentFormId,
        'themeId': consentThemeId,
        'title': title,
        'description': description,
        'purposeCategories': purposeCategories,
        'customFields': customFields,
        'consentformUrl': consentformUrl,
        'headerText': headerText,
        'headerDescription': headerDescription,
        'footerDescription': footerDescription,
        'acceptConsentText': acceptConsentText,
        'acceptText': acceptText,
        'cancelText': cancelText,
        'linkToPolicyText': linkToPolicyText,
        'linkToPolicyUrl': linkToPolicyUrl,
        'logoImage': logoImage,
        'headerBackgroundImage': headerBackgroundImage,
        'bodyBackgroundImage': bodyBackgroundImage,
        'uid': uid,
        'status': status.index,
        'version': version,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory ConsentFormModel.fromDocument(FirebaseDocument document) {
    Map<String, dynamic> response = document.data()!;
    response['consentFormId'] = document.id;
    return ConsentFormModel.fromMap(response);
  }

  ConsentFormModel copyWith({
    String? consentFormId,
    String? consentThemeId,
    List<LocalizedModel>? title,
    List<LocalizedModel>? description,
    List<String>? purposeCategories,
    List<String>? customFields,
    String? consentformUrl,
    List<LocalizedModel>? headerText,
    List<LocalizedModel>? headerDescription,
    List<LocalizedModel>? footerDescription,
    List<LocalizedModel>? acceptConsentText,
    List<LocalizedModel>? acceptText,
    List<LocalizedModel>? cancelText,
    List<LocalizedModel>? linkToPolicyText,
    String? linkToPolicyUrl,
    String? logoImage,
    String? headerBackgroundImage,
    String? bodyBackgroundImage,
    String? uid,
    ActiveStatus? status,
    int? version,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return ConsentFormModel(
      consentFormId: consentFormId ?? this.consentFormId,
      consentThemeId: consentThemeId ?? this.consentThemeId,
      title: title ?? this.title,
      description: description ?? this.description,
      purposeCategories: purposeCategories ?? this.purposeCategories,
      customFields: customFields ?? this.customFields,
      consentformUrl: consentformUrl ?? this.consentformUrl,
      headerText: headerText ?? this.headerText,
      headerDescription: headerDescription ?? this.headerDescription,
      footerDescription: footerDescription ?? this.footerDescription,
      acceptConsentText: acceptConsentText ?? this.acceptConsentText,
      acceptText: acceptText ?? this.acceptText,
      cancelText: cancelText ?? this.cancelText,
      linkToPolicyText: linkToPolicyText ?? this.linkToPolicyText,
      linkToPolicyUrl: linkToPolicyUrl ?? this.linkToPolicyUrl,
      logoImage: logoImage ?? this.logoImage,
      headerBackgroundImage:
          headerBackgroundImage ?? this.headerBackgroundImage,
      bodyBackgroundImage: bodyBackgroundImage ?? this.bodyBackgroundImage,
      uid: uid ?? this.uid,
      status: status ?? this.status,
      version: version ?? this.version,
      createdBy: createdBy ?? this.createdBy,
      createdDate: createdDate ?? this.createdDate,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  @override
  List<Object> get props {
    return [
      consentFormId,
      consentThemeId,
      title,
      description,
      purposeCategories,
      customFields,
      consentformUrl,
      headerText,
      headerDescription,
      footerDescription,
      acceptConsentText,
      acceptText,
      cancelText,
      linkToPolicyText,
      linkToPolicyUrl,
      logoImage,
      headerBackgroundImage,
      bodyBackgroundImage,
      uid,
      status,
      version,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
