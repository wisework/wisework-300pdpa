part of 'request_reason_tp_bloc.dart';

abstract class RequestReasonTpEvent extends Equatable {
  const RequestReasonTpEvent();

  @override
  List<Object> get props => [];
}

class GetRequestReasonTpEvent extends RequestReasonTpEvent {
  const GetRequestReasonTpEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateRequestReasonTpEvent extends RequestReasonTpEvent {
  const UpdateRequestReasonTpEvent({
    required this.requestReason,
    required this.updateType,
  });

  final RequestReasonTemplateModel requestReason;
  final UpdateType updateType;

  @override
  List<Object> get props => [requestReason, updateType];
}

