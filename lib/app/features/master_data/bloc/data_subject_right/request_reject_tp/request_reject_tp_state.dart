part of 'request_reject_tp_bloc.dart';

abstract class RequestRejectTpState extends Equatable {
  const RequestRejectTpState();

  @override
  List<Object> get props => [];
}

class RequestRejectTpInitial extends RequestRejectTpState {
  const RequestRejectTpInitial();

  @override
  List<Object> get props => [];
}

class RequestRejectError extends RequestRejectTpState {
  const RequestRejectError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingRequestRejects extends RequestRejectTpState {
  const GettingRequestRejects();

  @override
  List<Object> get props => [];
}

class GotRequestRejects extends RequestRejectTpState {
  const GotRequestRejects(
    this.requestRejects,
    this.requests,
  );

  final List<RequestRejectTemplateModel> requestRejects;
  final List<RequestTypeModel> requests;

  @override
  List<Object> get props => [requestRejects, requests];
}
