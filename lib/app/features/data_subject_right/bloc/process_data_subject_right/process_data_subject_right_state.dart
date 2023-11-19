part of 'process_data_subject_right_bloc.dart';

abstract class ProcessDataSubjectRightState extends Equatable {
  const ProcessDataSubjectRightState();

  @override
  List<Object> get props => [];
}

class ProcessDataSubjectRightInitial extends ProcessDataSubjectRightState {
  const ProcessDataSubjectRightInitial();

  @override
  List<Object> get props => [];
}

class ProcessDataSubjectRightError extends ProcessDataSubjectRightState {
  const ProcessDataSubjectRightError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingProcessDataSubjectRight extends ProcessDataSubjectRightState {
  const GettingProcessDataSubjectRight();

  @override
  List<Object> get props => [];
}

class GotProcessDataSubjectRight extends ProcessDataSubjectRightState {
  const GotProcessDataSubjectRight(this.dataSubjectRight);

  final DataSubjectRightModel dataSubjectRight;

  @override
  List<Object> get props => [dataSubjectRight];
}

class UpdatingProcessDataSubjectRight extends ProcessDataSubjectRightState {
  const UpdatingProcessDataSubjectRight();

  @override
  List<Object> get props => [];
}

class UpdatedProcessDataSubjectRight extends ProcessDataSubjectRightState {
  const UpdatedProcessDataSubjectRight(this.dataSubjectRight);

  final DataSubjectRightModel dataSubjectRight;

  @override
  List<Object> get props => [dataSubjectRight];
}
