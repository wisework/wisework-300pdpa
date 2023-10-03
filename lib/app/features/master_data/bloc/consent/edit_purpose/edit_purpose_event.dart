part of 'edit_purpose_bloc.dart';

abstract class EditPurposeEvent extends Equatable {
  const EditPurposeEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentPurposeEvent extends EditPurposeEvent {
  const GetCurrentPurposeEvent({
    required this.purposeId,
    required this.companyId,
  });

  final String purposeId;
  final String companyId;

  @override
  List<Object> get props => [purposeId, companyId];
}

class CreateCurrentPurposeEvent extends EditPurposeEvent {
  const CreateCurrentPurposeEvent({
    required this.purpose,
    required this.companyId,
  });

  final PurposeModel purpose;
  final String companyId;

  @override
  List<Object> get props => [purpose, companyId];
}

class UpdateCurrentPurposeEvent extends EditPurposeEvent {
  const UpdateCurrentPurposeEvent({
    required this.purpose,
    required this.companyId,
  });

  final PurposeModel purpose;
  final String companyId;

  @override
  List<Object> get props => [purpose, companyId];
}

class DeleteCurrentPurposeEvent extends EditPurposeEvent {
  const DeleteCurrentPurposeEvent({
    required this.purposeId,
    required this.companyId,
  });

  final String purposeId;
  final String companyId;

  @override
  List<Object> get props => [purposeId, companyId];
}
