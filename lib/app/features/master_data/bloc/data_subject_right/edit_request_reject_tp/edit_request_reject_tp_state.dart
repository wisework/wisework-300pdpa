part of 'edit_request_reject_tp_bloc.dart';

abstract class EditRequestRejectTpState extends Equatable {
  const EditRequestRejectTpState();

  @override
  List<Object> get props => [];
}

class EditRequestRejectTpInitial extends EditRequestRejectTpState {
  const EditRequestRejectTpInitial();

  @override
  List<Object> get props => [];
}

class EditRequestRejectTpError extends EditRequestRejectTpState {
  const EditRequestRejectTpError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GetingCurrentRequestRejectTp extends EditRequestRejectTpState {
  const GetingCurrentRequestRejectTp();

  @override
  List<Object> get props => [];
}

class GotCurrentRequestRejectTp extends EditRequestRejectTpState {
  const GotCurrentRequestRejectTp(
    this.requestRejectTp,
    this.rejects,
  );

  final RequestRejectTemplateModel requestRejectTp;
  final List<String> rejects;

  @override
  List<Object> get props => [requestRejectTp, rejects];
}

class CreatingCurrentRequestRejectTp extends EditRequestRejectTpState {
  const CreatingCurrentRequestRejectTp();

  @override
  List<Object> get props => [];
}

class CreatedCurrentRequestRejectTp extends EditRequestRejectTpState {
  const CreatedCurrentRequestRejectTp(this.requestRejectTp);

  final RequestRejectTemplateModel requestRejectTp;

  @override
  List<Object> get props => [requestRejectTp];
}

class UpdatingCurrentRequestRejectTp extends EditRequestRejectTpState {
  const UpdatingCurrentRequestRejectTp();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentRequestRejectTp extends EditRequestRejectTpState {
  const UpdatedCurrentRequestRejectTp(
    this.requestRejectTp,
    this.rejects,
  );

  final RequestRejectTemplateModel requestRejectTp;
  final List<String> rejects;

  @override
  List<Object> get props => [requestRejectTp, rejects];
}

class DeletingCurrentRequestRejectTp extends EditRequestRejectTpState {
  const DeletingCurrentRequestRejectTp();

  @override
  List<Object> get props => [];
}

class DeletedCurrentRequestRejectTp extends EditRequestRejectTpState {
  const DeletedCurrentRequestRejectTp(this.requestRejectTpId);

  final String requestRejectTpId;

  @override
  List<Object> get props => [];
}
