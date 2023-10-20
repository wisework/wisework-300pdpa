part of 'mandatory_field_bloc.dart';

abstract class MandatoryFieldState extends Equatable {
  const MandatoryFieldState();

  @override
  List<Object> get props => [];
}

final class MandatoryFieldInitial extends MandatoryFieldState {
  const MandatoryFieldInitial();

  @override
  List<Object> get props => [];
}

final class MandatoryFieldError extends MandatoryFieldState {
  const MandatoryFieldError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingMandatoryFields extends MandatoryFieldState {
  const GettingMandatoryFields();

  @override
  List<Object> get props => [];
}

class GotMandatoryFields extends MandatoryFieldState {
  const GotMandatoryFields(this.mandatoryFields);

  final List<MandatoryFieldModel> mandatoryFields;

  @override
  List<Object> get props => [mandatoryFields];
}
