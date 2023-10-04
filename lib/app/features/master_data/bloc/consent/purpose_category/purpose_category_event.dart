part of 'purpose_category_bloc.dart';

abstract class PurposeCategoryEvent extends Equatable {
  const PurposeCategoryEvent();

  @override
  List<Object> get props => [];
}

class GetPurposeCategoriesEvent extends PurposeCategoryEvent {
  const GetPurposeCategoriesEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdatePurposeCategoryEvent extends PurposeCategoryEvent {
  const UpdatePurposeCategoryEvent({
    required this.purposeCategory,
    required this.updateType,
  });

  final PurposeCategoryModel purposeCategory;
  final UpdateType updateType;

  @override
  List<Object> get props => [purposeCategory, updateType];
}
