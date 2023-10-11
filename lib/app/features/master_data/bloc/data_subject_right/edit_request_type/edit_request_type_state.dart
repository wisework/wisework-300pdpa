part of 'edit_request_type_bloc.dart';

abstract class EditRequestTypeState extends Equatable {
  const EditRequestTypeState();

  @override
  List<Object> get props => [];
}

class EditRequestTypeInitial extends EditRequestTypeState {
  const EditRequestTypeInitial();

  @override
  List<Object> get props => [];
}
class EditRequestTypeError extends EditRequestTypeState {
  const EditRequestTypeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GetingCurrentRequestType extends EditRequestTypeState {
  const GetingCurrentRequestType();

  @override
  List<Object> get props => [];
}

class GotCurrentRequestType extends EditRequestTypeState {
  const GotCurrentRequestType(this.requestType);

  final RequestTypeModel requestType;

  @override
  List<Object> get props => [requestType];
}

class CreatingCurrentRequestType extends EditRequestTypeState {
  const CreatingCurrentRequestType();

  @override
  List<Object> get props => [];
}

class CreatedCurrentRequestType extends EditRequestTypeState {
  const CreatedCurrentRequestType(this.requestType);

  final RequestTypeModel requestType;

  @override
  List<Object> get props => [requestType];
}

class UpdatingCurrentRequestType extends EditRequestTypeState {
  const UpdatingCurrentRequestType();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentRequestType extends EditRequestTypeState {
  const UpdatedCurrentRequestType(this.requestType);

  final RequestTypeModel requestType;

  @override
  List<Object> get props => [requestType];
}

class DeletingCurrentRequestType extends EditRequestTypeState {
  const DeletingCurrentRequestType();

  @override
  List<Object> get props => [];
}

class DeletedCurrentRequestType extends EditRequestTypeState {
  const DeletedCurrentRequestType(this.requestTypeId);

  final String requestTypeId;

  @override
  List<Object> get props => [];
}
