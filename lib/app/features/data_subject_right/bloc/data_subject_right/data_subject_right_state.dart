part of 'data_subject_right_bloc.dart';

abstract class DataSubjectRightState extends Equatable {
  const DataSubjectRightState();

  @override
  List<Object> get props => [];
}

class DataSubjectRightInitial extends DataSubjectRightState {
  const DataSubjectRightInitial();

  @override
  List<Object> get props => [];
}

class DataSubjectRightError extends DataSubjectRightState {
  const DataSubjectRightError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingDataSubjectRights extends DataSubjectRightState {
  const GettingDataSubjectRights();

  @override
  List<Object> get props => [];
}

class GotDataSubjectRights extends DataSubjectRightState {
  const GotDataSubjectRights(
    this.dataSubjectRights,
    this.processRequests,
    this.requestTypes,
  );

  final List<DataSubjectRightModel> dataSubjectRights;
  final List<Map<String, ProcessRequestModel>> processRequests;
  final List<RequestTypeModel> requestTypes;

  @override
  List<Object> get props => [dataSubjectRights, processRequests, requestTypes];
}
