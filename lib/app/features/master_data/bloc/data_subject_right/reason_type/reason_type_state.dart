part of 'reason_type_bloc.dart';

abstract class ReasonTypeState extends Equatable {
  const ReasonTypeState();

  @override
  List<Object> get props => [];
}

class ReasonTypeInitial extends ReasonTypeState {
  const ReasonTypeInitial();

  @override
  List<Object> get props => [];
}
class ReasonTypeError extends ReasonTypeState {
  const ReasonTypeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingReasonType extends ReasonTypeState {
  const GettingReasonType();

  @override
  List<Object> get props => [];
}

class GotReasonTypes extends ReasonTypeState {
  const GotReasonTypes(this.reasonTypes);

  final List<ReasonTypeModel> reasonTypes;

  @override
  List<Object> get props => [reasonTypes];
}
