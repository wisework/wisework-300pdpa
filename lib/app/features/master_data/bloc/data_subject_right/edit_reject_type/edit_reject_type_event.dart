part of 'edit_reject_type_bloc.dart';

abstract class EditRejectTypeEvent extends Equatable {
  const EditRejectTypeEvent();

  @override
  List<Object> get props => [];
}
class GetCurrentRejectTypeEvent extends EditRejectTypeEvent {
  const GetCurrentRejectTypeEvent({
    required this.rejectTypeId,
    required this.companyId,
  });

  final String rejectTypeId;
  final String companyId;

  @override
  List<Object> get props => [rejectTypeId, companyId];
}

class CreateCurrentRejectTypeEvent extends EditRejectTypeEvent {
  const CreateCurrentRejectTypeEvent({
    required this.rejectType,
    required this.companyId,
  });

  final RejectTypeModel rejectType;
  final String companyId;

  @override
  List<Object> get props => [rejectType, companyId];
}

class UpdateCurrentRejectTypeEvent extends EditRejectTypeEvent {
  const UpdateCurrentRejectTypeEvent({
    required this.rejectType,
    required this.companyId,
  });

  final RejectTypeModel rejectType;
  final String companyId;

  @override
  List<Object> get props => [rejectType, companyId];
}

class DeleteCurrentRejectTypeEvent extends EditRejectTypeEvent {
  const DeleteCurrentRejectTypeEvent({
    required this.rejectTypeId,
    required this.companyId,
  });

  final String rejectTypeId;
  final String companyId;

  @override
  List<Object> get props => [rejectTypeId, companyId];
}
