part of 'user_consent_bloc.dart';

sealed class UserConsentState extends Equatable {
  const UserConsentState();
  
  @override
  List<Object> get props => [];
}

final class UserConsentInitial extends UserConsentState {}
