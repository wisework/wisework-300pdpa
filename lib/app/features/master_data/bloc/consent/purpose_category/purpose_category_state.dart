part of 'purpose_category_bloc.dart';

abstract class PurposeCategoryState extends Equatable {
  const PurposeCategoryState();

  @override
  List<Object> get props => [];
}

class PurposeCategoryInitial extends PurposeCategoryState {
  const PurposeCategoryInitial();

  @override
  List<Object> get props => [];
}

class PurposeCategoryError extends PurposeCategoryState {
  const PurposeCategoryError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingPurposeCategories extends PurposeCategoryState {
  const GettingPurposeCategories();

  @override
  List<Object> get props => [];
}

class GotPurposeCategories extends PurposeCategoryState {
  const GotPurposeCategories(this.purposeCategories);

  final List<PurposeCategoryModel> purposeCategories;

  @override
  List<Object> get props => [purposeCategories];
}
