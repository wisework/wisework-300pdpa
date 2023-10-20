// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'choose_purpose_category_cubit.dart';

class ChoosePurposeCategoryCubitState extends Equatable {
  const ChoosePurposeCategoryCubitState({
    required this.consentForm,
    required this.expandId,
    required this.purposeCategory,
  });
  final String expandId;
  final ConsentFormModel consentForm;
  final List<PurposeCategoryModel> purposeCategory;

  ChoosePurposeCategoryCubitState copyWith({
    String? expandId,
    ConsentFormModel? consentForm,
    List<PurposeCategoryModel>? purposeCategory,
  }) {
    return ChoosePurposeCategoryCubitState(
      expandId: expandId ?? this.expandId,
      consentForm: consentForm ?? this.consentForm,
      purposeCategory: purposeCategory ?? this.purposeCategory,
    );
  }

  @override
  List<Object> get props => [
        purposeCategory,
        consentForm,
        expandId,
      ];
}
