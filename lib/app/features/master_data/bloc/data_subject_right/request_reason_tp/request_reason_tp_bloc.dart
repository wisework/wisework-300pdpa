import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'request_reason_tp_event.dart';
part 'request_reason_tp_state.dart';

class RequestReasonTpBloc extends Bloc<RequestReasonTpEvent, RequestReasonTpState> {
  RequestReasonTpBloc() : super(RequestReasonTpInitial()) {
    on<RequestReasonTpEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
