// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'request_reason_tp_event.dart';
part 'request_reason_tp_state.dart';

class RequestReasonTpBloc
    extends Bloc<RequestReasonTpEvent, RequestReasonTpState> {
  RequestReasonTpBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const RequestReasonTpInitial()) {
    on<GetRequestReasonTpEvent>(_getRequestReasonTemplatesHandler);
    on<UpdateRequestReasonTpEvent>(_updateRequestReasonTemplateHandler);
  }
  final MasterDataRepository _masterDataRepository;

  Future<void> _getRequestReasonTemplatesHandler(
    GetRequestReasonTpEvent event,
    Emitter<RequestReasonTpState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const RequestReasonError('Required company ID'));
      return;
    }

    emit(const GettingRequestReasons());

    final result =
        await _masterDataRepository.getRequestReasonTemplates(event.companyId);

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(RequestReasonError(failure.errorMessage)),
      (requestReasons) => emit(GotRequestReasons(
        requestReasons..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }

  Future<void> _updateRequestReasonTemplateHandler(
    UpdateRequestReasonTpEvent event,
    Emitter<RequestReasonTpState> emit,
  ) async {
    if (state is GotRequestReasons) {
      final requestReasons = (state as GotRequestReasons).requestReasons;

      List<RequestReasonTemplateModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = requestReasons
              .map((requestReasons) => requestReasons)
              .toList()
            ..add(event.requestReason);
          break;
        case UpdateType.updated:
          for (RequestReasonTemplateModel requestReasons in requestReasons) {
            if (requestReasons.requestReasonTemplateId ==
                event.requestReason.requestReasonTemplateId) {
              updated.add(event.requestReason);
            } else {
              updated.add(requestReasons);
            }
          }
          break;
        case UpdateType.deleted:
          updated = requestReasons
              .where((requestReasons) =>
                  requestReasons.requestReasonTemplateId !=
                  event.requestReason.requestReasonTemplateId)
              .toList();
          break;
      }

      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        GotRequestReasons(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
