part of 'edit_data_subject_right_bloc.dart';

abstract class EditDataSubjectRightEvent extends Equatable {
  const EditDataSubjectRightEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentDataSubjectRightEvent extends EditDataSubjectRightEvent {
  const GetCurrentDataSubjectRightEvent({
    required this.dataSubjectRightId,
    required this.companyId,
  });

  final String dataSubjectRightId;
  final String companyId;

  @override
  List<Object> get props => [dataSubjectRightId, companyId];
}

class CreateCurrentDataSubjectRightEvent extends EditDataSubjectRightEvent {
  const CreateCurrentDataSubjectRightEvent({
    required this.dataSubjectRight,
    required this.companyId,
  });

  final DataSubjectRightModel dataSubjectRight;
  final String companyId;

  @override
  List<Object> get props => [dataSubjectRight, companyId];
}

class UpdateCurrentDataSubjectRightEvent extends EditDataSubjectRightEvent {
  const UpdateCurrentDataSubjectRightEvent({
    required this.dataSubjectRight,
    required this.companyId,
  });

  final DataSubjectRightModel dataSubjectRight;
  final String companyId;

  @override
  List<Object> get props => [dataSubjectRight, companyId];
}
