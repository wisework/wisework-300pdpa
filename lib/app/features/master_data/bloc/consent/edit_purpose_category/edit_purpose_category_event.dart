part of 'edit_purpose_category_bloc.dart';

abstract class EditPurposeCategoryEvent extends Equatable {
  const EditPurposeCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentPurposeCategoryEvent extends EditPurposeCategoryEvent {
  const GetCurrentPurposeCategoryEvent({
    required this.purposeCategoryId,
    required this.companyId,
  });

  final String purposeCategoryId;
  final String companyId;

  @override
  List<Object> get props => [purposeCategoryId, companyId];
}

class CreateCurrentPurposeCategoryEvent extends EditPurposeCategoryEvent {
  const CreateCurrentPurposeCategoryEvent({
    required this.purposeCategory,
    required this.companyId,
  });

  final PurposeCategoryModel purposeCategory;
  final String companyId;

  @override
  List<Object> get props => [purposeCategory, companyId];
}

class UpdateCurrentPurposeCategoryEvent extends EditPurposeCategoryEvent {
  const UpdateCurrentPurposeCategoryEvent({
    required this.purposeCategory,
    required this.companyId,
  });

  final PurposeCategoryModel purposeCategory;
  final String companyId;

  @override
  List<Object> get props => [purposeCategory, companyId];
}

class DeleteCurrentPurposeCategoryEvent extends EditPurposeCategoryEvent {
  const DeleteCurrentPurposeCategoryEvent({
    required this.purposeCategoryId,
    required this.companyId,
  });

  final String purposeCategoryId;
  final String companyId;

  @override
  List<Object> get props => [purposeCategoryId, companyId];
}
