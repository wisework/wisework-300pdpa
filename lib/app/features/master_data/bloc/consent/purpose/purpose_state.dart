part of 'purpose_bloc.dart';

abstract class PurposeState extends Equatable {
  const PurposeState();

  @override
  List<Object> get props => [];
}

class PurposeInitial extends PurposeState {
  const PurposeInitial();

  @override
  List<Object> get props => [];
}

class PurposeError extends PurposeState {
  const PurposeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class GettingPurposes extends PurposeState {
  const GettingPurposes();

  @override
  List<Object> get props => [];
}

class GotPurposes extends PurposeState {
  const GotPurposes(this.purposes);

  final List<PurposeModel> purposes;

  @override
  List<Object> get props => [purposes];
}
