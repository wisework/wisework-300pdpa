part of 'reason_type_bloc.dart';

abstract class ReasonTypeEvent extends Equatable {
  const ReasonTypeEvent();

  @override
  List<Object> get props => [];

}
class GetReasonTypeEvent extends ReasonTypeEvent {
  const GetReasonTypeEvent({required this.companyId});

  final String companyId;

  @override
  List<Object> get props => [companyId];
}

class UpdateReasonTypeEvent extends ReasonTypeEvent {
  const UpdateReasonTypeEvent({
    required this.reasonType,
    required this.updateType,
  });

  final ReasonTypeModel reasonType;
  final UpdateType updateType;

  @override
  List<Object> get props => [reasonType, updateType];
}