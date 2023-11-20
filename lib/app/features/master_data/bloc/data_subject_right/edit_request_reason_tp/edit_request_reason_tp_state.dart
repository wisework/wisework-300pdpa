part of 'edit_request_reason_tp_bloc.dart';

abstract class EditRequestReasonTpState extends Equatable {
  const EditRequestReasonTpState();

  @override
  List<Object> get props => [];
}

class EditRequestReasonTpInitial extends EditRequestReasonTpState {
  const EditRequestReasonTpInitial();

  @override
  List<Object> get props => [];
}

class EditRequestReasonTpError extends EditRequestReasonTpState {
  const EditRequestReasonTpError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GetingCurrentRequestReasonTp extends EditRequestReasonTpState {
  const GetingCurrentRequestReasonTp();

  @override
  List<Object> get props => [];
}

class GotCurrentRequestReasonTp extends EditRequestReasonTpState {
  const GotCurrentRequestReasonTp(
    this.requestReasonTp,
    this.reasons,
  );

  final RequestReasonTemplateModel requestReasonTp;
  final List<String> reasons;

  @override
  List<Object> get props => [requestReasonTp, reasons];
}

class CreatingCurrentRequestReasonTp extends EditRequestReasonTpState {
  const CreatingCurrentRequestReasonTp();

  @override
  List<Object> get props => [];
}

class CreatedCurrentRequestReasonTp extends EditRequestReasonTpState {
  const CreatedCurrentRequestReasonTp(this.requestReasonTp);

  final RequestReasonTemplateModel requestReasonTp;

  @override
  List<Object> get props => [requestReasonTp];
}

class UpdatingCurrentRequestReasonTp extends EditRequestReasonTpState {
  const UpdatingCurrentRequestReasonTp();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentRequestReasonTp extends EditRequestReasonTpState {
  const UpdatedCurrentRequestReasonTp(
    this.requestReasonTp,
    this.reasons,
  );

  final RequestReasonTemplateModel requestReasonTp;
  final List<String> reasons;

  @override
  List<Object> get props => [requestReasonTp, reasons];
}

class DeletingCurrentRequestReasonTp extends EditRequestReasonTpState {
  const DeletingCurrentRequestReasonTp();

  @override
  List<Object> get props => [];
}

class DeletedCurrentRequestReasonTp extends EditRequestReasonTpState {
  const DeletedCurrentRequestReasonTp(this.requestReasonTpId);

  final String requestReasonTpId;

  @override
  List<Object> get props => [];
}
