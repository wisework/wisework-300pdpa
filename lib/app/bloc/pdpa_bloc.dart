import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pdpa_event.dart';
part 'pdpa_state.dart';

class PdpaBloc extends Bloc<PdpaEvent, PdpaState> {
  PdpaBloc() : super(PdpaInitial()) {
    on<PdpaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
