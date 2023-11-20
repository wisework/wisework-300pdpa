part of 'edit_request_reason_tp_bloc.dart';

abstract class EditRequestReasonTpEvent extends Equatable {
  const EditRequestReasonTpEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentRequestReasonTpEvent extends EditRequestReasonTpEvent {
  const GetCurrentRequestReasonTpEvent({
    required this.requestReasonTpId,
    required this.companyId,
  });

  final String requestReasonTpId;
  final String companyId;

  @override
  List<Object> get props => [requestReasonTpId, companyId];
}

class CreateCurrentRequestReasonTpEvent extends EditRequestReasonTpEvent {
  const CreateCurrentRequestReasonTpEvent({
    required this.requestReasonTp,
    required this.companyId,
  });

  final RequestReasonTemplateModel requestReasonTp;
  final String companyId;

  @override
  List<Object> get props => [requestReasonTp, companyId];
}

class UpdateCurrentRequestReasonTpEvent extends EditRequestReasonTpEvent {
  const UpdateCurrentRequestReasonTpEvent({
    required this.requestReasonTp,
    required this.companyId,
  });

  final RequestReasonTemplateModel requestReasonTp;
  final String companyId;

  @override
  List<Object> get props => [requestReasonTp, companyId];
}

class DeleteCurrentRequestReasonTpEvent extends EditRequestReasonTpEvent {
  const DeleteCurrentRequestReasonTpEvent({
    required this.requestReasonTpId,
    required this.companyId,
  });

  final String requestReasonTpId;
  final String companyId;

  @override
  List<Object> get props => [requestReasonTpId, companyId];
}

class UpdateEditRequestReasonTpStateEvent extends EditRequestReasonTpEvent {
  const UpdateEditRequestReasonTpStateEvent({
    required this.reason,
  });

  final ReasonTypeModel reason;

  @override
  List<Object> get props => [reason];
}
