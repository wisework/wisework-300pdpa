import 'package:equatable/equatable.dart';

import 'package:pdpa/core/utils/constants.dart';

class ConsentForm extends Equatable{
  const ConsentForm({
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

  ConsentForm.empty()
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

  @override
  List<Object?> get props {
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