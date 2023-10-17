part of 'request_reason_tp_bloc.dart';

abstract class RequestReasonTpState extends Equatable {
  const RequestReasonTpState();

  @override
  List<Object> get props => [];
}

class RequestReasonTpInitial extends RequestReasonTpState {
  const RequestReasonTpInitial();

  @override
  List<Object> get props => [];
}

class RequestReasonError extends RequestReasonTpState {
  const RequestReasonError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingRequestReasons extends RequestReasonTpState {
  const GettingRequestReasons();

  @override
  List<Object> get props => [];
}

class GotRequestReasons extends RequestReasonTpState {
  const GotRequestReasons(this.requestReasons);

  final List<RequestReasonTemplateModel> requestReasons;

  @override
  List<Object> get props => [requestReasons];
}
