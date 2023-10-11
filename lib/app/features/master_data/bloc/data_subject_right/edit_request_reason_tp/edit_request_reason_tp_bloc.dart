import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_request_reason_tp_event.dart';
part 'edit_request_reason_tp_state.dart';

class EditRequestReasonTpBloc extends Bloc<EditRequestReasonTpEvent, EditRequestReasonTpState> {
  EditRequestReasonTpBloc() : super(EditRequestReasonTpInitial()) {
    on<EditRequestReasonTpEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
