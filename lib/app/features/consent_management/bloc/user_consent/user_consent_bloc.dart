// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_consent_event.dart';
part 'user_consent_state.dart';

class UserConsentBloc extends Bloc<UserConsentEvent, UserConsentState> {
  UserConsentBloc() : super(UserConsentInitial()) {
    on<UserConsentEvent>((event, emit) {
     
    });
  }
}
