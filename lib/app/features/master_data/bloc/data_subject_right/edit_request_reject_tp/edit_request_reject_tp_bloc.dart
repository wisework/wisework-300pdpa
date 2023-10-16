import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_request_reject_tp_event.dart';
part 'edit_request_reject_tp_state.dart';

class EditRequestRejectTpBloc extends Bloc<EditRequestRejectTpEvent, EditRequestRejectTpState> {
  EditRequestRejectTpBloc() : super(EditRequestRejectTpInitial()) {
    on<EditRequestRejectTpEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
