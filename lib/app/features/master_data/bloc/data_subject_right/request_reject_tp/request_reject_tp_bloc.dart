import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'request_reject_tp_event.dart';
part 'request_reject_tp_state.dart';

class RequestRejectTpBloc extends Bloc<RequestRejectTpEvent, RequestRejectTpState> {
  RequestRejectTpBloc() : super(RequestRejectTpInitial()) {
    on<RequestRejectTpEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
