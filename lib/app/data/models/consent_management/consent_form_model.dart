import 'package:equatable/equatable.dart';

import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class ConsentFormModel extends Equatable {
  const ConsentFormModel({
    required this.id,
    required this.title,
    required this.description,
    required this.purposeCategories,
    required this.customFields,
    required this.headerText,
    required this.headerDescription,
    required this.footerDescription,
    required this.acceptConsentText,
    required this.acceptText,
    required this.cancelText,
    required this.linkToPolicyText,
    required this.linkToPolicyUrl,
    required this.consentFormUrl,
    required this.consentThemeId,
    required this.logoImage,
    required this.headerBackgroundImage,
    required this.bodyBackgroundImage,
    required this.status,
    required this.createdBy,
    required this.createdDate,
    required this.updatedBy,
    required this.updatedDate,
  });

  final String id;
  final List<LocalizedModel> title;
  final List<LocalizedModel> description;
  final List<String> purposeCategories;
  final List<String> customFields;
  final List<LocalizedModel> headerText;
  final List<LocalizedModel> headerDescription;
  final List<LocalizedModel> footerDescription;
  final List<LocalizedModel> acceptConsentText;
  final List<LocalizedModel> acceptText;
  final List<LocalizedModel> cancelText;
  final List<LocalizedModel> linkToPolicyText;
  final String linkToPolicyUrl;
  final String consentFormUrl;
  final String consentThemeId;
  final String logoImage;
  final String headerBackgroundImage;
  final String bodyBackgroundImage;
  final ActiveStatus status;
  final String createdBy;
  final DateTime createdDate;
  final String updatedBy;
  final DateTime updatedDate;

  ConsentFormModel.empty()
      : this(
          id: '',
          title: [],
          description: [],
          purposeCategories: [],
          customFields: [],
          headerText: [],
          headerDescription: [],
          footerDescription: [],
          acceptConsentText: [],
          acceptText: [],
          cancelText: [],
          linkToPolicyText: [],
          linkToPolicyUrl: '',
          consentFormUrl: '',
          consentThemeId: '',
          logoImage: '',
          headerBackgroundImage: '',
          bodyBackgroundImage: '',
          status: ActiveStatus.active,
          createdBy: '',
          createdDate: DateTime.fromMillisecondsSinceEpoch(0),
          updatedBy: '',
          updatedDate: DateTime.fromMillisecondsSinceEpoch(0),
        );

  ConsentFormModel.fromMap(DataMap map)
      : this(
          id: map['id'] as String,
          title: List<LocalizedModel>.from(
            (map['title'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          description: List<LocalizedModel>.from(
            (map['description'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          purposeCategories:
              List<String>.from(map['purposeCategories'] as List<dynamic>),
          customFields: List<String>.from(map['customFields'] as List<dynamic>),
          headerText: List<LocalizedModel>.from(
            (map['headerText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          headerDescription: List<LocalizedModel>.from(
            (map['headerDescription'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          footerDescription: List<LocalizedModel>.from(
            (map['footerDescription'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          acceptConsentText: List<LocalizedModel>.from(
            (map['acceptConsentText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          acceptText: List<LocalizedModel>.from(
            (map['acceptText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          cancelText: List<LocalizedModel>.from(
            (map['cancelText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          linkToPolicyText: List<LocalizedModel>.from(
            (map['linkToPolicyText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          linkToPolicyUrl: map['linkToPolicyUrl'] as String,
          consentFormUrl: map['consentFormUrl'] as String,
          consentThemeId: map['consentThemeId'] as String,
          logoImage: map['logoImage'] as String,
          headerBackgroundImage: map['headerBackgroundImage'] as String,
          bodyBackgroundImage: map['bodyBackgroundImage'] as String,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  DataMap toMap() => {
        'title': title.map((item) => item.toMap()).toList(),
        'description': description.map((item) => item.toMap()).toList(),
        'purposeCategories': purposeCategories,
        'customFields': customFields,
        'headerText': headerText.map((item) => item.toMap()).toList(),
        'headerDescription':
            headerDescription.map((item) => item.toMap()).toList(),
        'footerDescription':
            footerDescription.map((item) => item.toMap()).toList(),
        'acceptConsentText':
            acceptConsentText.map((item) => item.toMap()).toList(),
        'acceptText': acceptText.map((item) => item.toMap()).toList(),
        'cancelText': cancelText.map((item) => item.toMap()).toList(),
        'linkToPolicyText':
            linkToPolicyText.map((item) => item.toMap()).toList(),
        'linkToPolicyUrl': linkToPolicyUrl,
        'consentFormUrl': consentFormUrl,
        'consentThemeId': consentThemeId,
        'logoImage': logoImage,
        'headerBackgroundImage': headerBackgroundImage,
        'bodyBackgroundImage': bodyBackgroundImage,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  factory ConsentFormModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return ConsentFormModel.fromMap(response);
  }

  ConsentFormModel copyWith({
    String? id,
    List<LocalizedModel>? title,
    List<LocalizedModel>? description,
    List<String>? purposeCategories,
    List<String>? customFields,
    List<LocalizedModel>? headerText,
    List<LocalizedModel>? headerDescription,
    List<LocalizedModel>? footerDescription,
    List<LocalizedModel>? acceptConsentText,
    List<LocalizedModel>? acceptText,
    List<LocalizedModel>? cancelText,
    List<LocalizedModel>? linkToPolicyText,
    String? linkToPolicyUrl,
    String? consentFormUrl,
    String? consentThemeId,
    String? logoImage,
    String? headerBackgroundImage,
    String? bodyBackgroundImage,
    ActiveStatus? status,
    String? createdBy,
    DateTime? createdDate,
    String? updatedBy,
    DateTime? updatedDate,
  }) {
    return ConsentFormModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      purposeCategories: purposeCategories ?? this.purposeCategories,
      customFields: customFields ?? this.customFields,
      headerText: headerText ?? this.headerText,
      headerDescription: headerDescription ?? this.headerDescription,
      footerDescription: footerDescription ?? this.footerDescription,
      acceptConsentText: acceptConsentText ?? this.acceptConsentText,
      acceptText: acceptText ?? this.acceptText,
      cancelText: cancelText ?? this.cancelText,
      linkToPolicyText: linkToPolicyText ?? this.linkToPolicyText,
      linkToPolicyUrl: linkToPolicyUrl ?? this.linkToPolicyUrl,
      consentFormUrl: consentFormUrl ?? this.consentFormUrl,
      consentThemeId: consentThemeId ?? this.consentThemeId,
      logoImage: logoImage ?? this.logoImage,
      headerBackgroundImage:
          headerBackgroundImage ?? this.headerBackgroundImage,
      bodyBackgroundImage: bodyBackgroundImage ?? this.bodyBackgroundImage,
      status: status ?? this.status,
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
      description,
      purposeCategories,
      customFields,
      headerText,
      headerDescription,
      footerDescription,
      acceptConsentText,
      acceptText,
      cancelText,
      linkToPolicyText,
      linkToPolicyUrl,
      consentFormUrl,
      consentThemeId,
      logoImage,
      headerBackgroundImage,
      bodyBackgroundImage,
      status,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
    ];
  }
}
