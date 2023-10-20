part of 'mandatory_field_bloc.dart';

abstract class MandatoryFieldEvent extends Equatable {
  const MandatoryFieldEvent();

  @override
  List<Object> get props => [];
}

class GetMandatoryFieldsEvent extends MandatoryFieldEvent {
  const GetMandatoryFieldsEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateMandatoryFieldsEvent extends MandatoryFieldEvent {
  const UpdateMandatoryFieldsEvent({
    required this.mandatoryFields,
    required this.companyId,
  });

  final List<MandatoryFieldModel> mandatoryFields;
  final String companyId;

  @override
  List<Object> get props => [mandatoryFields, companyId];
}
