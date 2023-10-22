import 'package:equatable/equatable.dart';

import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/typedef.dart';

class ConsentFormModel extends Equatable {
  const ConsentFormModel({
    required this.id,
    required this.title,
    required this.description,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.customFields,
    required this.consentFormUrl,
    required this.consentThemeId,
    required this.headerText,
    required this.headerDescription,
    required this.footerDescription,
    required this.acceptConsentText,
    required this.linkToPolicyText,
    required this.linkToPolicyUrl,
    required this.submitText,
    required this.cancelText,
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
  final List<String> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<String> customFields;
  final String consentFormUrl;
  final String consentThemeId;
  final List<LocalizedModel> headerText;
  final List<LocalizedModel> headerDescription;
  final List<LocalizedModel> footerDescription;
  final List<LocalizedModel> acceptConsentText;
  final List<LocalizedModel> linkToPolicyText;
  final String linkToPolicyUrl;
  final List<LocalizedModel> submitText;
  final List<LocalizedModel> cancelText;
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
          mandatoryFields: [],
          purposeCategories: [],
          customFields: [],
          consentFormUrl: '',
          consentThemeId: '',
          headerText: [],
          headerDescription: [],
          footerDescription: [],
          acceptConsentText: [],
          linkToPolicyText: [],
          linkToPolicyUrl: '',
          submitText: [],
          cancelText: [],
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
          mandatoryFields:
              List<String>.from(map['mandatoryFields'] as List<dynamic>),
          purposeCategories: List<PurposeCategoryModel>.from(
            (map['purposeCategories'] as List<dynamic>)
                .map<PurposeCategoryModel>(
              (item) => PurposeCategoryModel.fromMap(item as DataMap),
            ),
          ),
          customFields: List<String>.from(map['customFields'] as List<dynamic>),
          consentFormUrl: map['consentFormUrl'] as String,
          consentThemeId: map['consentThemeId'] as String,
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
          linkToPolicyText: List<LocalizedModel>.from(
            (map['linkToPolicyText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          linkToPolicyUrl: map['linkToPolicyUrl'] as String,
          submitText: List<LocalizedModel>.from(
            (map['submitText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          cancelText: List<LocalizedModel>.from(
            (map['cancelText'] as List<dynamic>).map<LocalizedModel>(
              (item) => LocalizedModel.fromMap(item as DataMap),
            ),
          ),
          logoImage: map['logoImage'] as String,
          headerBackgroundImage: map['headerBackgroundImage'] as String,
          bodyBackgroundImage: map['bodyBackgroundImage'] as String,
          status: ActiveStatus.values[map['status'] as int],
          createdBy: map['createdBy'] as String,
          createdDate: DateTime.parse(map['createdDate'] as String),
          updatedBy: map['updatedBy'] as String,
          updatedDate: DateTime.parse(map['updatedDate'] as String),
        );

  factory ConsentFormModel.fromDocument(FirebaseDocument document) {
    DataMap response = document.data()!;
    response['id'] = document.id;
    return ConsentFormModel.fromMap(response);
  }

  DataMap toMap() => {
        'title': title.map((item) => item.toMap()).toList(),
        'description': description.map((item) => item.toMap()).toList(),
        'mandatoryFields': mandatoryFields,
        'purposeCategories': purposeCategories.fold(
          {},
          (map, purposeCategory) =>
              map..addAll({purposeCategory.id: purposeCategory.priority}),
        ),
        'customFields': customFields,
        'consentFormUrl': consentFormUrl,
        'consentThemeId': consentThemeId,
        'headerText': headerText.map((item) => item.toMap()).toList(),
        'headerDescription':
            headerDescription.map((item) => item.toMap()).toList(),
        'footerDescription':
            footerDescription.map((item) => item.toMap()).toList(),
        'acceptConsentText':
            acceptConsentText.map((item) => item.toMap()).toList(),
        'linkToPolicyText':
            linkToPolicyText.map((item) => item.toMap()).toList(),
        'linkToPolicyUrl': linkToPolicyUrl,
        'submitText': submitText.map((item) => item.toMap()).toList(),
        'cancelText': cancelText.map((item) => item.toMap()).toList(),
        'logoImage': logoImage,
        'headerBackgroundImage': headerBackgroundImage,
        'bodyBackgroundImage': bodyBackgroundImage,
        'status': status.index,
        'createdBy': createdBy,
        'createdDate': createdDate.toIso8601String(),
        'updatedBy': updatedBy,
        'updatedDate': updatedDate.toIso8601String(),
      };

  ConsentFormModel copyWith({
    String? id,
    List<LocalizedModel>? title,
    List<LocalizedModel>? description,
    List<String>? mandatoryFields,
    List<PurposeCategoryModel>? purposeCategories,
    List<String>? customFields,
    String? consentFormUrl,
    String? consentThemeId,
    List<LocalizedModel>? headerText,
    List<LocalizedModel>? headerDescription,
    List<LocalizedModel>? footerDescription,
    List<LocalizedModel>? acceptConsentText,
    List<LocalizedModel>? linkToPolicyText,
    String? linkToPolicyUrl,
    List<LocalizedModel>? submitText,
    List<LocalizedModel>? cancelText,
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
      mandatoryFields: mandatoryFields ?? this.mandatoryFields,
      purposeCategories: purposeCategories ?? this.purposeCategories,
      customFields: customFields ?? this.customFields,
      consentFormUrl: consentFormUrl ?? this.consentFormUrl,
      consentThemeId: consentThemeId ?? this.consentThemeId,
      headerText: headerText ?? this.headerText,
      headerDescription: headerDescription ?? this.headerDescription,
      footerDescription: footerDescription ?? this.footerDescription,
      acceptConsentText: acceptConsentText ?? this.acceptConsentText,
      linkToPolicyText: linkToPolicyText ?? this.linkToPolicyText,
      linkToPolicyUrl: linkToPolicyUrl ?? this.linkToPolicyUrl,
      submitText: submitText ?? this.submitText,
      cancelText: cancelText ?? this.cancelText,
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

  ConsentFormModel setCreate(String email, DateTime date) => copyWith(
        createdBy: email,
        createdDate: date,
        updatedBy: email,
        updatedDate: date,
      );

  ConsentFormModel setUpdate(String email, DateTime date) => copyWith(
        updatedBy: email,
        updatedDate: date,
      );

  @override
  List<Object> get props {
    return [
      title,
      description,
      mandatoryFields,
      purposeCategories,
      customFields,
      consentFormUrl,
      consentThemeId,
      headerText,
      headerDescription,
      footerDescription,
      acceptConsentText,
      linkToPolicyText,
      linkToPolicyUrl,
      submitText,
      cancelText,
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
