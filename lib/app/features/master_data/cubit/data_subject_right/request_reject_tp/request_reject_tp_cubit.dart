import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'request_reject_tp_state.dart';

class RequestRejectTpCubit extends Cubit<RequestRejectTpState> {
  RequestRejectTpCubit() : super(RequestRejectTpInitial());
}
