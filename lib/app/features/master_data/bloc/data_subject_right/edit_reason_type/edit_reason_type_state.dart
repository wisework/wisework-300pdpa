part of 'edit_reason_type_bloc.dart';

abstract class EditReasonTypeState extends Equatable {
  const EditReasonTypeState();

  @override
  List<Object> get props => [];
}

class EditReasonTypeInitial extends EditReasonTypeState {
  const EditReasonTypeInitial();

  @override
  List<Object> get props => [];
}

class EditReasonTypeError extends EditReasonTypeState {
  const EditReasonTypeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GetingCurrentReasonType extends EditReasonTypeState {
  const GetingCurrentReasonType();

  @override
  List<Object> get props => [];
}

class GotCurrentReasonType extends EditReasonTypeState {
  const GotCurrentReasonType(this.reasonType);

  final ReasonTypeModel reasonType;

  @override
  List<Object> get props => [reasonType];
}

class CreatingCurrentReasonType extends EditReasonTypeState {
  const CreatingCurrentReasonType();

  @override
  List<Object> get props => [];
}

class CreatedCurrentReasonType extends EditReasonTypeState {
  const CreatedCurrentReasonType(this.reasonType);

  final ReasonTypeModel reasonType;

  @override
  List<Object> get props => [reasonType];
}

class UpdatingCurrentReasonType extends EditReasonTypeState {
  const UpdatingCurrentReasonType();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentReasonType extends EditReasonTypeState {
  const UpdatedCurrentReasonType(this.reasonType);

  final ReasonTypeModel reasonType;

  @override
  List<Object> get props => [reasonType];
}

class DeletingCurrentReasonType extends EditReasonTypeState {
  const DeletingCurrentReasonType();

  @override
  List<Object> get props => [];
}

class DeletedCurrentReasonType extends EditReasonTypeState {
  const DeletedCurrentReasonType(this.reasonTypeId);

  final String reasonTypeId;

  @override
  List<Object> get props => [];
}