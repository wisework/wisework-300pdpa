// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'choose_purpose_category_cubit.dart';

class ChoosePurposeCategoryCubitState extends Equatable {
  const ChoosePurposeCategoryCubitState({
    required this.purposeCategorySelected,
    required this.customFieldSelected,
    required this.expandId,
  });
  final String expandId;
  final List<PurposeCategoryModel> purposeCategorySelected;
  final List<CustomFieldModel> customFieldSelected;

  ChoosePurposeCategoryCubitState copyWith({
    String? expandId,
    List<PurposeCategoryModel>? purposeCategorySelected,
    List<CustomFieldModel>? customFieldSelected,
  }) {
    return ChoosePurposeCategoryCubitState(
      expandId: expandId ?? this.expandId,
      purposeCategorySelected:
          purposeCategorySelected ?? this.purposeCategorySelected,
      customFieldSelected: customFieldSelected ?? this.customFieldSelected,
    );
  }

  @override
  List<Object> get props => [
        purposeCategorySelected,
        customFieldSelected,
        expandId,
      ];
}
