part of 'consent_form_bloc.dart';

abstract class ConsentFormEvent extends Equatable {
  const ConsentFormEvent();

  @override
  List<Object> get props => [];
}

class GetConsentFormsEvent extends ConsentFormEvent {
  const GetConsentFormsEvent({
    required this.companyId,
    required this.sort,
  });

  final String companyId;
  final SortType sort;

  @override
  List<Object> get props => [
        companyId,
        sort,
      ];
}

class GetPurposeCategoriesEvent extends ConsentFormEvent {
  const GetPurposeCategoriesEvent({
    required this.purposeCategoryId,
    required this.companyId,
  });
  final String companyId;
  final String purposeCategoryId;

  @override
  List<Object> get props => [
        purposeCategoryId,
        companyId,
      ];
}

class UpdateConsentFormEvent extends ConsentFormEvent {
  const UpdateConsentFormEvent({
    required this.consentForm,
    required this.updateType,
  });

  final ConsentFormModel consentForm;
  final UpdateType updateType;

  @override
  List<Object> get props => [
        consentForm,
        updateType,
      ];
}

class SearchConsentSearchChanged extends ConsentFormEvent {
  const SearchConsentSearchChanged({
    required this.companyId,
    required this.search,
  });

  final String search;
  final String companyId;

  @override
  List<Object> get props => [
        companyId,
        search,
      ];
}

class ConsentFormsSortChanged extends ConsentFormEvent {
  const ConsentFormsSortChanged();

  @override
  List<Object> get props => [];
}
