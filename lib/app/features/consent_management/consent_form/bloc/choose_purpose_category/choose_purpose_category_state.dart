part of 'choose_purpose_category_bloc.dart';

abstract class ChoosePurposeCategoryState extends Equatable {
  const ChoosePurposeCategoryState();

  @override
  List<Object> get props => [];
}

class ChoosePurposeCategoryInitial extends ChoosePurposeCategoryState {
  const ChoosePurposeCategoryInitial();

  @override
  List<Object> get props => [];
}

class GetingCurrentPurposeCategory extends ChoosePurposeCategoryState {
  const GetingCurrentPurposeCategory();

  @override
  List<Object> get props => [];
}

class GotCurrentPurposeCategory extends ChoosePurposeCategoryState {
  const GotCurrentPurposeCategory(
    this.purposeCategories,
    this.purposes,
  );

  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;

  @override
  List<Object> get props => [
        purposeCategories,
        purposes,
      ];
}

class ChoosePurposeCategoryError extends ChoosePurposeCategoryState {
  const ChoosePurposeCategoryError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
