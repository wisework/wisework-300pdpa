part of 'edit_custom_field_bloc.dart';

abstract class EditCustomFieldEvent extends Equatable {
  const EditCustomFieldEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentCustomFieldEvent extends EditCustomFieldEvent {
  const GetCurrentCustomFieldEvent({
    required this.customfieldId,
    required this.companyId,
  });

  final String customfieldId;
  final String companyId;

  @override
  List<Object> get props => [customfieldId, companyId];
}

class CreateCurrentCustomFieldEvent extends EditCustomFieldEvent {
  const CreateCurrentCustomFieldEvent({
    required this.customfield,
    required this.companyId,
  });

  final CustomFieldModel customfield;
  final String companyId;

  @override
  List<Object> get props => [customfield, companyId];
}

class UpdateCurrentCustomFieldEvent extends EditCustomFieldEvent {
  const UpdateCurrentCustomFieldEvent({
    required this.customfield,
    required this.companyId,
  });

  final CustomFieldModel customfield;
  final String companyId;

  @override
  List<Object> get props => [customfield, companyId];
}

class DeleteCurrentCustomFieldEvent extends EditCustomFieldEvent {
  const DeleteCurrentCustomFieldEvent({
    required this.customfieldId,
    required this.companyId,
  });

  final String customfieldId;
  final String companyId;

  @override
  List<Object> get props => [customfieldId, companyId];
}
