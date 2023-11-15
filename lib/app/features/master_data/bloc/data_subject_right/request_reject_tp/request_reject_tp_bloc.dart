// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/request_reject_template_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'request_reject_tp_event.dart';
part 'request_reject_tp_state.dart';

class RequestRejectTpBloc
    extends Bloc<RequestRejectTpEvent, RequestRejectTpState> {
  RequestRejectTpBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const RequestRejectTpInitial()) {
    on<GetRequestRejectTpEvent>(_getRequestRejectTemplatesHandler);
    on<UpdateRequestRejectTpEvent>(_updateRequestRejectTemplateHandler);
  }
  final MasterDataRepository _masterDataRepository;

  Future<void> _getRequestRejectTemplatesHandler(
    GetRequestRejectTpEvent event,
    Emitter<RequestRejectTpState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const RequestRejectError('Required company ID'));
      return;
    }

    emit(const GettingRequestRejects());

    final result =
        await _masterDataRepository.getRequestRejectTemplates(event.companyId);

    result.fold(
      (failure) => emit(RequestRejectError(failure.errorMessage)),
      (requestRejects) => emit(GotRequestRejects(
        requestRejects..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }

  Future<void> _updateRequestRejectTemplateHandler(
    UpdateRequestRejectTpEvent event,
    Emitter<RequestRejectTpState> emit,
  ) async {
    if (state is GotRequestRejects) {
      final requestRejects = (state as GotRequestRejects).requestRejects;

      List<RequestRejectTemplateModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = requestRejects
              .map((requestRejects) => requestRejects)
              .toList()
            ..add(event.requestReject);
          break;
        case UpdateType.updated:
          for (RequestRejectTemplateModel requestRejects in requestRejects) {
            if (requestRejects.id == event.requestReject.id) {
              updated.add(event.requestReject);
            } else {
              updated.add(requestRejects);
            }
          }
          break;
        case UpdateType.deleted:
          updated = requestRejects
              .where((requestRejects) =>
                  requestRejects.id != event.requestReject.id)
              .toList();
          break;
      }

      emit(
        GotRequestRejects(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
