part of 'reject_type_bloc.dart';

abstract class RejectTypeState extends Equatable {
  const RejectTypeState();

  @override
  List<Object> get props => [];
}

class RejectTypeInitial extends RejectTypeState {
  const RejectTypeInitial();

  @override
  List<Object> get props => [];
}
class RejectTypeError extends RejectTypeState {
  const RejectTypeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingRejectType extends RejectTypeState {
  const GettingRejectType();

  @override
  List<Object> get props => [];
}

class GotRejectTypes extends RejectTypeState {
  const GotRejectTypes(this.rejectTypes);

  final List<RejectTypeModel> rejectTypes;

  @override
  List<Object> get props => [rejectTypes];
}
