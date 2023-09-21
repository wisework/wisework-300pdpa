part of 'general_consent_bloc.dart';

abstract class GeneralConsentState extends Equatable {
  const GeneralConsentState();
  
  @override
  List<Object> get props => [];
}

class GeneralConsentInitial extends GeneralConsentState {
  const GeneralConsentInitial();
  
  @override
  List<Object> get props => [];
}

class GeneralConsentError extends GeneralConsentState {
  const GeneralConsentError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}


