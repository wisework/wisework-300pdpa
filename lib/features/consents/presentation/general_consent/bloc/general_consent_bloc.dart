import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'general_consent_event.dart';
part 'general_consent_state.dart';

class GeneralConsentBloc extends Bloc<GeneralConsentEvent, GeneralConsentState> {
  GeneralConsentBloc() : super(GeneralConsentInitial()) {
    on<GeneralConsentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
