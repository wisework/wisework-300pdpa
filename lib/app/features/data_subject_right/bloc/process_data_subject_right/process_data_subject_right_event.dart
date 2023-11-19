part of 'process_data_subject_right_bloc.dart';

abstract class ProcessDataSubjectRightEvent extends Equatable {
  const ProcessDataSubjectRightEvent();

  @override
  List<Object> get props => [];
}

class GetProcessDataSubjectRightEvent extends ProcessDataSubjectRightEvent {
  const GetProcessDataSubjectRightEvent({
    required this.dataSubjectRightId,
    required this.companyId,
  });

  final String dataSubjectRightId;
  final String companyId;

  @override
  List<Object> get props => [dataSubjectRightId, companyId];
}

class UpdateProcessDataSubjectRightEvent extends ProcessDataSubjectRightEvent {
  const UpdateProcessDataSubjectRightEvent({
    required this.dataSubjectRight,
    required this.companyId,
  });

  final DataSubjectRightModel dataSubjectRight;
  final String companyId;

  @override
  List<Object> get props => [dataSubjectRight, companyId];
}
