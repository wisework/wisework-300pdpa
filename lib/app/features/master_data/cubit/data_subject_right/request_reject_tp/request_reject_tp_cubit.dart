// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reject_template_model.dart';

part 'request_reject_tp_state.dart';

class RequestRejectTpCubit extends Cubit<RequestRejectTpState> {
  RequestRejectTpCubit()
      : super(const RequestRejectTpState(
          rejects: [],
          rejectList: [],
          request: '',
        ));

  Future<void> initialRejectList(List<RejectTypeModel> rejects,
      RequestRejectTemplateModel requestRejectModel) async {
    final rejectList = rejects
        .where((id) => requestRejectModel.rejectTypes.contains(id))
        .toList();
    state.copyWith(rejectList: rejectList);

    state.copyWith(
        rejects: requestRejectModel.rejectTypes
            .map((purpose) => purpose.id)
            .toList());

    emit(state.copyWith(
        rejects: requestRejectModel.rejectTypes
            .map((purpose) => purpose.id)
            .toList()));

    emit(state.copyWith(rejectList: rejectList));
  }

  void chooseRequestRejectSelected(String requestReject) {
    final templateSelected = state.rejects.map((template) => template).toList();
    if (templateSelected.contains(requestReject)) {
      templateSelected.remove(requestReject);
      emit(state.copyWith(rejects: templateSelected));
    } else {
      templateSelected.add(requestReject);
      emit(state.copyWith(rejects: templateSelected));
    }
  }

  void removeReject(String reject) {
    final templateSelected = state.rejects.map((template) => template).toList();

    if (templateSelected.contains(reject)) {
      templateSelected.remove(reject);
      emit(state.copyWith(rejects: templateSelected));
    }
  }
}
