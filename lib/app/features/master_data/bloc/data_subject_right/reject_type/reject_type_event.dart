part of 'reject_type_bloc.dart';

abstract class RejectTypeEvent extends Equatable {
  const RejectTypeEvent();

  @override
  List<Object> get props => [];
}
class GetRejectTypeEvent extends RejectTypeEvent {
  const GetRejectTypeEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateRejectTypeEvent extends RejectTypeEvent {
  const UpdateRejectTypeEvent({
    required this.rejectType,
    required this.updateType,
  });

  final RejectTypeModel rejectType;
  final UpdateType updateType;

  @override
  List<Object> get props => [rejectType, updateType];
}