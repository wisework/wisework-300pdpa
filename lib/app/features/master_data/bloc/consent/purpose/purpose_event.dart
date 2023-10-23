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

class UpdatePurposesChangedEvent extends PurposeEvent {
  const UpdatePurposesChangedEvent({
    required this.purpose,
    required this.updateType,
  });

  final PurposeModel purpose;
  final UpdateType updateType;

  @override
  List<Object> get props => [purpose, updateType];
}
