part of 'edit_reject_type_bloc.dart';

abstract class EditRejectTypeState extends Equatable {
  const EditRejectTypeState();

  @override
  List<Object> get props => [];
}

class EditRejectTypeInitial extends EditRejectTypeState {
  const EditRejectTypeInitial();

  @override
  List<Object> get props => [];
}

class EditRejectTypeError extends EditRejectTypeState {
  const EditRejectTypeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GetingCurrentRejectType extends EditRejectTypeState {
  const GetingCurrentRejectType();

  @override
  List<Object> get props => [];
}

class GotCurrentRejectType extends EditRejectTypeState {
  const GotCurrentRejectType(
    this.rejectType,
    this.dataSubjectRights,
  );

  final RejectTypeModel rejectType;
  final List<DataSubjectRightModel> dataSubjectRights;

  @override
  List<Object> get props => [
        rejectType,
        dataSubjectRights,
      ];
}

class CreatingCurrentRejectType extends EditRejectTypeState {
  const CreatingCurrentRejectType();

  @override
  List<Object> get props => [];
}

class CreatedCurrentRejectType extends EditRejectTypeState {
  const CreatedCurrentRejectType(this.rejectType);

  final RejectTypeModel rejectType;

  @override
  List<Object> get props => [rejectType];
}

class UpdatingCurrentRejectType extends EditRejectTypeState {
  const UpdatingCurrentRejectType();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentRejectType extends EditRejectTypeState {
  const UpdatedCurrentRejectType(
    this.rejectType,
    this.dataSubjectRights,
  );

  final RejectTypeModel rejectType;
  final List<DataSubjectRightModel> dataSubjectRights;

  @override
  List<Object> get props => [
        rejectType,
        dataSubjectRights,
      ];
}

class DeletingCurrentRejectType extends EditRejectTypeState {
  const DeletingCurrentRejectType();

  @override
  List<Object> get props => [];
}

class DeletedCurrentRejectType extends EditRejectTypeState {
  const DeletedCurrentRejectType(this.rejectTypeId);

  final String rejectTypeId;

  @override
  List<Object> get props => [];
}
