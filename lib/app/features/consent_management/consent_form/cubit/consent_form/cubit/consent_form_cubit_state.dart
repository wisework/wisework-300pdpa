// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'consent_form_cubit.dart';

class ConsentFormCubitState extends Equatable {
  const ConsentFormCubitState({
    required this.sort,
  });

  final SortType sort;

  ConsentFormCubitState copyWith({
    SortType? sort,
  }) {
    return ConsentFormCubitState(
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object> get props => [sort];
}
