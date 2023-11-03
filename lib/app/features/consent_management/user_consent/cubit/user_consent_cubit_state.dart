part of 'user_consent_cubit.dart';

sealed class UserConsentCubitState extends Equatable {
  const UserConsentCubitState();

  @override
  List<Object> get props => [];
}

final class UserConsentInitial extends UserConsentCubitState {}
