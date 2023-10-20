// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'request_reason_tp_state.dart';

class RequestReasonTpCubit extends Cubit<RequestReasonTpState> {
  RequestReasonTpCubit() : super(RequestReasonTpInitial());
}
