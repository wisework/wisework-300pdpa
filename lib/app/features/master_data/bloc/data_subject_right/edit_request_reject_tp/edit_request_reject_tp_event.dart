part of 'edit_request_reject_tp_bloc.dart';

abstract class EditRequestRejectTpEvent extends Equatable {
  const EditRequestRejectTpEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentRequestRejectTpEvent extends EditRequestRejectTpEvent {
  const GetCurrentRequestRejectTpEvent({
    required this.requestRejectTpId,
    required this.companyId,
  });

  final String requestRejectTpId;
  final String companyId;

  @override
  List<Object> get props => [requestRejectTpId, companyId];
}

class CreateCurrentRequestRejectTpEvent extends EditRequestRejectTpEvent {
  const CreateCurrentRequestRejectTpEvent({
    required this.requestRejectTp,
    required this.companyId,
  });

  final RequestRejectTemplateModel requestRejectTp;
  final String companyId;

  @override
  List<Object> get props => [requestRejectTp, companyId];
}

class UpdateCurrentRequestRejectTpEvent extends EditRequestRejectTpEvent {
  const UpdateCurrentRequestRejectTpEvent({
    required this.requestRejectTp,
    required this.companyId,
  });

  final RequestRejectTemplateModel requestRejectTp;
  final String companyId;

  @override
  List<Object> get props => [requestRejectTp, companyId];
}

class DeleteCurrentRequestRejectTpEvent extends EditRequestRejectTpEvent {
  const DeleteCurrentRequestRejectTpEvent({
    required this.requestRejectTpId,
    required this.companyId,
  });

  final String requestRejectTpId;
  final String companyId;

  @override
  List<Object> get props => [requestRejectTpId, companyId];
}
