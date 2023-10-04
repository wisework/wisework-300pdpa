part of 'custom_field_bloc.dart';

abstract class CustomFieldEvent extends Equatable {
  const CustomFieldEvent();

  @override
  List<Object> get props => [];
}

class GetCustomFieldEvent extends CustomFieldEvent {
  const GetCustomFieldEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateCustomFieldEvent extends CustomFieldEvent {
  const UpdateCustomFieldEvent({
    required this.customfield,
    required this.updateType,
  });

  final CustomFieldModel customfield;
  final UpdateType updateType;

  @override
  List<Object> get props => [customfield, updateType];
}
