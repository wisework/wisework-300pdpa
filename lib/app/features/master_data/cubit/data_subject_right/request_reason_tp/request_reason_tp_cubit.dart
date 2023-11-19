// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';

part 'request_reason_tp_state.dart';

class RequestReasonTpCubit extends Cubit<RequestReasonTpState> {
  RequestReasonTpCubit()
      : super(const RequestReasonTpState(
          reasons: [],
          reasonList: [],
          request: '',
        ));

  Future<void> initialReasonList(List<ReasonTypeModel> reasons,
      RequestReasonTemplateModel requestReasonModel) async {
    final reasonList = reasons
        .where((id) => requestReasonModel.reasonTypes.contains(id))
        .toList();
    state.copyWith(reasonList: reasonList);

    state.copyWith(
        reasons: requestReasonModel.reasonTypes
            .map((purpose) => purpose.id)
            .toList());

    emit(state.copyWith(
        reasons: requestReasonModel.reasonTypes
            .map((purpose) => purpose.id)
            .toList()));

    emit(state.copyWith(reasonList: reasonList));
  }

  void chooseRequestReasonSelected(String requestReason) {
    final templateSelected = state.reasons.map((template) => template).toList();
    if (templateSelected.contains(requestReason)) {
      templateSelected.remove(requestReason);
      emit(state.copyWith(reasons: templateSelected));
    } else {
      templateSelected.add(requestReason);
      emit(state.copyWith(reasons: templateSelected));
    }
  }

  void removeReason(String reason) {
    final templateSelected = state.reasons.map((template) => template).toList();

    if (templateSelected.contains(reason)) {
      templateSelected.remove(reason);
      emit(state.copyWith(reasons: templateSelected));
    }
  }
}
