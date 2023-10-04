part of 'edit_custom_field_bloc.dart';

abstract class EditCustomFieldState extends Equatable {
  const EditCustomFieldState();

  @override
  List<Object> get props => [];
}

class EditCustomFieldInitial extends EditCustomFieldState {
  const EditCustomFieldInitial();

  @override
  List<Object> get props => [];
}

class EditCustomFieldError extends EditCustomFieldState {
  const EditCustomFieldError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GetingCurrentCustomField extends EditCustomFieldState {
  const GetingCurrentCustomField();

  @override
  List<Object> get props => [];
}

class GotCurrentCustomField extends EditCustomFieldState {
  const GotCurrentCustomField(this.customfield);

  final CustomFieldModel customfield;

  @override
  List<Object> get props => [customfield];
}

class CreatingCurrentCustomField extends EditCustomFieldState {
  const CreatingCurrentCustomField();

  @override
  List<Object> get props => [];
}

class CreatedCurrentCustomField extends EditCustomFieldState {
  const CreatedCurrentCustomField(this.customfield);

  final CustomFieldModel customfield;

  @override
  List<Object> get props => [customfield];
}

class UpdatingCurrentCustomField extends EditCustomFieldState {
  const UpdatingCurrentCustomField();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentCustomField extends EditCustomFieldState {
  const UpdatedCurrentCustomField(this.customfield);

  final CustomFieldModel customfield;

  @override
  List<Object> get props => [customfield];
}

class DeletingCurrentCustomField extends EditCustomFieldState {
  const DeletingCurrentCustomField();

  @override
  List<Object> get props => [];
}

class DeletedCurrentCustomField extends EditCustomFieldState {
  const DeletedCurrentCustomField(this.customfieldId);

  final String customfieldId;

  @override
  List<Object> get props => [];
}
