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

class LoadingPurposes extends PurposeState {
  const LoadingPurposes();

  @override
  List<Object> get props => [];
}

class LoadedPurposes extends PurposeState {
  const LoadedPurposes(this.purposes);

  final List<PurposeModel> purposes;

  @override
  List<Object> get props => [purposes];
}

class PurposeError extends PurposeState {
  const PurposeError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
