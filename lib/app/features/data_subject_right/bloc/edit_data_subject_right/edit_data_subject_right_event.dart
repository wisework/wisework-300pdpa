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

class UpdateEditDataSubjectRightStateEvent extends EditDataSubjectRightEvent {
  const UpdateEditDataSubjectRightStateEvent({
    required this.dataSubjectRight,
  });

  final DataSubjectRightModel dataSubjectRight;

  @override
  List<Object> get props => [dataSubjectRight];
}

class DownloadDataSubjectRightFileEvent extends EditDataSubjectRightEvent {
  const DownloadDataSubjectRightFileEvent({
    required this.path,
  });

  final String path;

  @override
  List<Object> get props => [path];
}
