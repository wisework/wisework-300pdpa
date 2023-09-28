part of 'consent_form_bloc.dart';

sealed class ConsentFormState extends Equatable {
  const ConsentFormState();
  
  @override
  List<Object> get props => [];
}

final class ConsentFormInitial extends ConsentFormState {}
