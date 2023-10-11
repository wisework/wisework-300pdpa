part of 'edit_purpose_category_bloc.dart';

abstract class EditPurposeCategoryState extends Equatable {
  const EditPurposeCategoryState();

  @override
  List<Object> get props => [];
}

class EditPurposeCategoryInitial extends EditPurposeCategoryState {
  const EditPurposeCategoryInitial();

  @override
  List<Object> get props => [];
}

class EditPurposeCategoryError extends EditPurposeCategoryState {
  const EditPurposeCategoryError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GetingCurrentPurposeCategory extends EditPurposeCategoryState {
  const GetingCurrentPurposeCategory();

  @override
  List<Object> get props => [];
}

class GotCurrentPurposeCategory extends EditPurposeCategoryState {
  const GotCurrentPurposeCategory(this.purposeCategory);

  final PurposeCategoryModel purposeCategory;

  @override
  List<Object> get props => [purposeCategory];
}

class CreatingCurrentPurposeCategory extends EditPurposeCategoryState {
  const CreatingCurrentPurposeCategory();

  @override
  List<Object> get props => [];
}

class CreatedCurrentPurposeCategory extends EditPurposeCategoryState {
  const CreatedCurrentPurposeCategory(this.purposeCategory);

  final PurposeCategoryModel purposeCategory;

  @override
  List<Object> get props => [purposeCategory];
}

class UpdatingCurrentPurposeCategory extends EditPurposeCategoryState {
  const UpdatingCurrentPurposeCategory();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentPurposeCategory extends EditPurposeCategoryState {
  const UpdatedCurrentPurposeCategory(this.purposeCategory);

  final PurposeCategoryModel purposeCategory;

  @override
  List<Object> get props => [purposeCategory];
}

class DeletingCurrentPurposeCategory extends EditPurposeCategoryState {
  const DeletingCurrentPurposeCategory();

  @override
  List<Object> get props => [];
}

class DeletedCurrentPurposeCategory extends EditPurposeCategoryState {
  const DeletedCurrentPurposeCategory(this.purposeCategoryId);

  final String purposeCategoryId;

  @override
  List<Object> get props => [];
}
