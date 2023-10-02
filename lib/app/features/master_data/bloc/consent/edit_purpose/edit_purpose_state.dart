part of 'edit_purpose_bloc.dart';

abstract class EditPurposeState extends Equatable {
  const EditPurposeState();

  @override
  List<Object> get props => [];
}

class EditPurposeInitial extends EditPurposeState {
  const EditPurposeInitial();

  @override
  List<Object> get props => [];
}

class EditPurposeError extends EditPurposeState {
  const EditPurposeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GetingCurrentPurpose extends EditPurposeState {
  const GetingCurrentPurpose();

  @override
  List<Object> get props => [];
}

class GotCurrentPurpose extends EditPurposeState {
  const GotCurrentPurpose(this.purpose);

  final PurposeModel purpose;

  @override
  List<Object> get props => [purpose];
}

class UpdatingCurrentPurpose extends EditPurposeState {
  const UpdatingCurrentPurpose();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentPurpose extends EditPurposeState {
  const UpdatedCurrentPurpose(this.purpose);

  final PurposeModel purpose;

  @override
  List<Object> get props => [purpose];
}
