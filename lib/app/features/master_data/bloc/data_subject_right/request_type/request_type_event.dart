part of 'request_type_bloc.dart';

abstract class RequestTypeEvent extends Equatable {
  const RequestTypeEvent();

  @override
  List<Object> get props => [];
}
class GetRequestTypesEvent extends RequestTypeEvent {
  const GetRequestTypesEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateRequestTypesChangedEvent extends RequestTypeEvent {
  const UpdateRequestTypesChangedEvent({
    required this.requestType,
    required this.updateType,
  });

  final RequestTypeModel requestType;
  final UpdateType updateType;

  @override
  List<Object> get props => [requestType, updateType];
}