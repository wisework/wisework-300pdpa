part of 'request_reject_tp_bloc.dart';

abstract class RequestRejectTpEvent extends Equatable {
  const RequestRejectTpEvent();

  @override
  List<Object> get props => [];
}

class GetRequestRejectTpEvent extends RequestRejectTpEvent {
  const GetRequestRejectTpEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateRequestRejectTpEvent extends RequestRejectTpEvent {
  const UpdateRequestRejectTpEvent({
    required this.requestReject,
    required this.updateType,
  });

  final RequestRejectTemplateModel requestReject;
  final UpdateType updateType;

  @override
  List<Object> get props => [requestReject, updateType];
}