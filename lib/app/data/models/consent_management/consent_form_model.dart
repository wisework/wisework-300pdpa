// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class ConsentFormModel extends Equatable {
  const ConsentFormModel({
    required this.consentFormId,
    required this.themeId,
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
    required this.language,
    required this.status,
    required this.version,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
    required this.companyId,
  });

  final String consentFormId;
  final String themeId;
  final String title;
  final String description;
  final List<String> purposeCategories;
  final List<String> customFields;
  final String consentformUrl;
  final String headerText;
  final String headerDescription;
  final String footerDescription;
  final String acceptConsentText;
  final String acceptText;
  final String cancelText;
  final String linkToPolicyText;
  final String linkToPolicyUrl;
  final String logoImage;
  final String headerBackgroundImage;
  final String bodyBackgroundImage;
  final String uid;
  final String language;
  final ActiveStatus status;
  final int version;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;
  final String companyId;

  ConsentFormModel.empty()
      : this(
          consentFormId: '',
          themeId: '',
          title: '',
          description: '',
          purposeCategories: [],
          customFields: [],
          consentformUrl: '',
          headerText: '',
          headerDescription: '',
          footerDescription: '',
          acceptConsentText: '',
          acceptText: '',
          cancelText: '',
          linkToPolicyText: '',
          linkToPolicyUrl: '',
          logoImage: '',
          headerBackgroundImage: '',
          bodyBackgroundImage: '',
          uid: '',
          language: '',
          status: ActiveStatus.active,
          version: 1,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
          companyId: '',
        );

  ConsentFormModel.fromMap(DataMap map)
      : this(
          consentFormId: map['consentFormId'] as String,
          themeId: map['themeId'] as String,
          title: map['title'] as String,
          description: map['description'] as String,
          purposeCategories:
              List<dynamic>.from((map['purposeCategories'] as List<dynamic>))
                  .map((item) => item.toString())
                  .toList(),
          customFields:
              List<dynamic>.from((map['customFields'] as List<dynamic>))
                  .map((item) => item.toString())
                  .toList(),
          consentformUrl: map['consentformUrl'] as String,
          headerText: map['headerText'] as String,
          headerDescription: map['headerDescription'] as String,
          footerDescription: map['footerDescription'] as String,
          acceptConsentText: map['acceptConsentText'] as String,
          acceptText: map['acceptText'] as String,
          cancelText: map['cancelText'] as String,
          linkToPolicyText: map['linkToPolicyText'] as String,
          linkToPolicyUrl: map['linkToPolicyUrl'] as String,
          logoImage: map['logoImage'] as String,
          headerBackgroundImage: map['headerBackgroundImage'] as String,
          bodyBackgroundImage: map['bodyBackgroundImage'] as String,
          uid: map['uid'] as String,
          language: map['language'] as String,
          status: ActiveStatus.values[map['status'] as int],
          version: map['version'] as int,
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
          companyId: map['companyId'] as String,
        );

  DataMap toMap() => {
        'consentFormId': consentFormId,
        'themeId': themeId,
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
        'language': language,
        'status': status.index,
        'version': version,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
        'companyId': companyId,
      };

  factory ConsentFormModel.fromJson(String source) =>
      ConsentFormModel.fromMap(json.decode(source) as DataMap);

  String toJson() => json.encode(toMap());

  ConsentFormModel copyWith({
    String? consentFormId,
    String? themeId,
    String? title,
    String? description,
    List<String>? purposeCategories,
    List<String>? customFields,
    String? consentformUrl,
    String? headerText,
    String? headerDescription,
    String? footerDescription,
    String? acceptConsentText,
    String? acceptText,
    String? cancelText,
    String? linkToPolicyText,
    String? linkToPolicyUrl,
    String? logoImage,
    String? headerBackgroundImage,
    String? bodyBackgroundImage,
    String? uid,
    String? language,
    ActiveStatus? status,
    int? version,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
    String? companyId,
  }) {
    return ConsentFormModel(
      consentFormId: consentFormId ?? this.consentFormId,
      themeId: themeId ?? this.themeId,
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
      language: language ?? this.language,
      status: status ?? this.status,
      version: version ?? this.version,
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
      consentFormId,
      themeId,
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
      language,
      status,
      version,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
      companyId,
    ];
  }
}
