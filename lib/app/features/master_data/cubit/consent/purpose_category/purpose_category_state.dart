// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'purpose_category_cubit.dart';

class PurposeCategoryState extends Equatable {
  const PurposeCategoryState({
    required this.purposes,
    required this.purposeList,
  });

  final List<String> purposes;
  final List<PurposeModel> purposeList;

  PurposeCategoryState copyWith({
    List<String>? purposes,
    List<PurposeModel>? purposeList,
  }) {
    return PurposeCategoryState(
      purposes: purposes ?? this.purposes,
      purposeList: purposeList ?? this.purposeList,
    );
  }

  @override
  List<Object> get props => [purposes, purposeList];
}
