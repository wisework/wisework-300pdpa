part of 'pdpa_bloc.dart';

sealed class PdpaState extends Equatable {
  const PdpaState();
  
  @override
  List<Object> get props => [];
}

final class PdpaInitial extends PdpaState {}
