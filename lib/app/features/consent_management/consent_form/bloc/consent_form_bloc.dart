import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'consent_form_event.dart';
part 'consent_form_state.dart';

class ConsentFormBloc extends Bloc<ConsentFormEvent, ConsentFormState> {
  ConsentFormBloc() : super(ConsentFormInitial()) {
    on<ConsentFormEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
