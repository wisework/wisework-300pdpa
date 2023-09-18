import 'package:equatable/equatable.dart';


class ConsentTheme extends Equatable{
  const ConsentTheme({
    required this.themeId,
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

  ConsentTheme.empty()
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

  final String themeId;
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

  @override
  List<Object?> get props {
    return [
      themeId,
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