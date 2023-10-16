part of 'request_type_bloc.dart';

abstract class RequestTypeEvent extends Equatable {
  const RequestTypeEvent();

  @override
  List<Object> get props => [];
}
class GetRequestTypeEvent extends RequestTypeEvent {
  const GetRequestTypeEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateRequestTypeEvent extends RequestTypeEvent {
  const UpdateRequestTypeEvent({
    required this.requestType,
    required this.updateType,
  });

  final RequestTypeModel requestType;
  final UpdateType updateType;

  @override
  List<Object> get props => [requestType, updateType];
}