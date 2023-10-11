part of 'request_type_bloc.dart';

abstract class RequestTypeState extends Equatable {
  const RequestTypeState();

  @override
  List<Object> get props => [];
}

class RequestTypeInitial extends RequestTypeState {
  const RequestTypeInitial();

  @override
  List<Object> get props => [];
}

class RequestTypeError extends RequestTypeState {
  const RequestTypeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingRequestType extends RequestTypeState {
  const GettingRequestType();

  @override
  List<Object> get props => [];
}

class GotRequestTypes extends RequestTypeState {
  const GotRequestTypes(this.requestTypes);

  final List<RequestTypeModel> requestTypes;

  @override
  List<Object> get props => [requestTypes];
}
