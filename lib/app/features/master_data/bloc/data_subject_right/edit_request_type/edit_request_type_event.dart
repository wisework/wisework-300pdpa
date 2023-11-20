part of 'edit_request_type_bloc.dart';

abstract class EditRequestTypeEvent extends Equatable {
  const EditRequestTypeEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentRequestTypeEvent extends EditRequestTypeEvent {
  const GetCurrentRequestTypeEvent({
    required this.requestTypeId,
    required this.companyId,
  });

  final String requestTypeId;
  final String companyId;

  @override
  List<Object> get props => [requestTypeId, companyId];
}

class CreateCurrentRequestTypeEvent extends EditRequestTypeEvent {
  const CreateCurrentRequestTypeEvent({
    required this.requestType,
    required this.companyId,
  });

  final RequestTypeModel requestType;
  final String companyId;

  @override
  List<Object> get props => [requestType, companyId];
}

class UpdateCurrentRequestTypeEvent extends EditRequestTypeEvent {
  const UpdateCurrentRequestTypeEvent({
    required this.requestType,
    required this.companyId,
  });

  final RequestTypeModel requestType;
  final String companyId;

  @override
  List<Object> get props => [requestType, companyId];
}

class DeleteCurrentRequestTypeEvent extends EditRequestTypeEvent {
  const DeleteCurrentRequestTypeEvent({
    required this.requestTypeId,
    required this.companyId,
  });

  final String requestTypeId;
  final String companyId;

  @override
  List<Object> get props => [requestTypeId, companyId];
}

class UpdateEditRequestTypeStateEvent extends EditRequestTypeEvent {
  const UpdateEditRequestTypeStateEvent({
    required this.reject,
  });

  final RejectTypeModel reject;

  @override
  List<Object> get props => [reject];
}
