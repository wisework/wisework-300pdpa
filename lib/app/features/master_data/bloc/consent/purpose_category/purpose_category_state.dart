part of 'purpose_category_bloc.dart';

sealed class PurposeCategoryState extends Equatable {
  const PurposeCategoryState();
  
  @override
  List<Object> get props => [];
}

final class PurposeCategoryInitial extends PurposeCategoryState {}
