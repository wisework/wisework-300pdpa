part of 'purpose_bloc.dart';

abstract class PurposeEvent extends Equatable {
  const PurposeEvent();

  @override
  List<Object> get props => [];
}

class GetPurposesEvent extends PurposeEvent {
  const GetPurposesEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdatePurposeEvent extends PurposeEvent {
  const UpdatePurposeEvent({required this.purpose});

  final PurposeModel purpose;

  @override
  List<Object> get props => [purpose];
}
