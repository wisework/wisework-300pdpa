part of 'data_subject_right_bloc.dart';

abstract class DataSubjectRightEvent extends Equatable {
  const DataSubjectRightEvent();

  @override
  List<Object> get props => [];
}

class GetDataSubjectRightsEvent extends DataSubjectRightEvent {
  const GetDataSubjectRightsEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateDataSubjectRightsEvent extends DataSubjectRightEvent {
  const UpdateDataSubjectRightsEvent({
    required this.dataSubjectRight,
    required this.updateType,
  });

  final DataSubjectRightModel dataSubjectRight;
  final UpdateType updateType;

  @override
  List<Object> get props => [dataSubjectRight, updateType];
}
