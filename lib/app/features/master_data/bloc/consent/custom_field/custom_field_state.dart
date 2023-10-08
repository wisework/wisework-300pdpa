part of 'custom_field_bloc.dart';

abstract class CustomFieldState extends Equatable {
  const CustomFieldState();

  @override
  List<Object> get props => [];
}

class CustomFieldInitial extends CustomFieldState {
  const CustomFieldInitial();

  @override
  List<Object> get props => [];
}

class CustomfieldError extends CustomFieldState {
  const CustomfieldError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingCustomField extends CustomFieldState {
  const GettingCustomField();

  @override
  List<Object> get props => [];
}

class GotCustomFields extends CustomFieldState {
  const GotCustomFields(this.customfields);

  final List<CustomFieldModel> customfields;

  @override
  List<Object> get props => [customfields];
}