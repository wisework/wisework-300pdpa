part of 'edit_data_subject_right_bloc.dart';

abstract class EditDataSubjectRightState extends Equatable {
  const EditDataSubjectRightState();

  @override
  List<Object> get props => [];
}

class EditDataSubjectRightInitial extends EditDataSubjectRightState {
  const EditDataSubjectRightInitial();

  @override
  List<Object> get props => [];
}

class EditDataSubjectRightError extends EditDataSubjectRightState {
  const EditDataSubjectRightError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingCurrentDataSubjectRight extends EditDataSubjectRightState {
  const GettingCurrentDataSubjectRight();

  @override
  List<Object> get props => [];
}

class GotCurrentDataSubjectRight extends EditDataSubjectRightState {
  const GotCurrentDataSubjectRight(
    this.dataSubjectRight,
    this.mandatoryFields,
  );

  final DataSubjectRightModel dataSubjectRight;
  final List<MandatoryFieldModel> mandatoryFields;

  @override
  List<Object> get props => [dataSubjectRight, mandatoryFields];
}

class CreatingCurrentDataSubjectRight extends EditDataSubjectRightState {
  const CreatingCurrentDataSubjectRight();

  @override
  List<Object> get props => [];
}

class CreatedCurrentDataSubjectRight extends EditDataSubjectRightState {
  const CreatedCurrentDataSubjectRight(
    this.dataSubjectRight,
  );

  final DataSubjectRightModel dataSubjectRight;

  @override
  List<Object> get props => [dataSubjectRight];
}

class UpdatingCurrentDataSubjectRight extends EditDataSubjectRightState {
  const UpdatingCurrentDataSubjectRight();

  @override
  List<Object> get props => [];
}

class UpdatedCurrentDataSubjectRight extends EditDataSubjectRightState {
  const UpdatedCurrentDataSubjectRight(
    this.dataSubjectRight,
    this.mandatoryFields,
  );

  final DataSubjectRightModel dataSubjectRight;
  final List<MandatoryFieldModel> mandatoryFields;

  @override
  List<Object> get props => [dataSubjectRight, mandatoryFields];
}
