part of 'edit_reason_type_bloc.dart';

abstract class EditReasonTypeEvent extends Equatable {
  const EditReasonTypeEvent();

  @override
  List<Object> get props => [];
}
class GetCurrentReasonTypeEvent extends EditReasonTypeEvent {
  const GetCurrentReasonTypeEvent({
    required this.reasonTypeId,
    required this.companyId,
  });

  final String reasonTypeId;
  final String companyId;

  @override
  List<Object> get props => [reasonTypeId, companyId];
}

class CreateCurrentReasonTypeEvent extends EditReasonTypeEvent {
  const CreateCurrentReasonTypeEvent({
    required this.reasonType,
    required this.companyId,
  });

  final ReasonTypeModel reasonType;
  final String companyId;

  @override
  List<Object> get props => [reasonType, companyId];
}

class UpdateCurrentReasonTypeEvent extends EditReasonTypeEvent {
  const UpdateCurrentReasonTypeEvent({
    required this.reasonType,
    required this.companyId,
  });

  final ReasonTypeModel reasonType;
  final String companyId;

  @override
  List<Object> get props => [reasonType, companyId];
}

class DeleteCurrentReasonTypeEvent extends EditReasonTypeEvent {
  const DeleteCurrentReasonTypeEvent({
    required this.reasonTypeId,
    required this.companyId,
  });

  final String reasonTypeId;
  final String companyId;

  @override
  List<Object> get props => [reasonTypeId, companyId];
}
