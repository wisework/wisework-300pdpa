// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reject_template_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
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
    List<RequestTypeModel> gotRequests = [];
    List<RejectTypeModel> gotRejects = [];
    List<RequestRejectTemplateModel> gotRequestRejects = [];

    final requestResult = await _masterDataRepository.getRequestTypes(
      event.companyId,
    );
    requestResult.fold(
      (failure) {
        emit(RequestRejectError(failure.errorMessage));
        return;
      },
      (requests) {
        gotRequests = requests;
      },
    );

    final rejectResult = await _masterDataRepository.getRejectTypes(
      event.companyId,
    );
    rejectResult.fold(
      (failure) {
        emit(RequestRejectError(failure.errorMessage));
        return;
      },
      (rejects) {
        gotRejects = rejects;
      },
    );

    final requestRejectResult =
        await _masterDataRepository.getRequestRejectTemplates(
      event.companyId,
    );
    requestRejectResult.fold(
      (failure) {
        emit(RequestRejectError(failure.errorMessage));
        return;
      },
      (requestRejectTemplates) {
        for (RequestRejectTemplateModel requestReject
            in requestRejectTemplates) {
          final requestIds = requestReject.requestTypeId;
          final requests = gotRequests
              .where((request) => requestIds.contains(request.id))
              .first;
          final rejectIds =
              requestReject.rejectTypesId.map((reject) => reject).toList();
          final rejects = gotRejects
              .where((reject) => rejectIds.contains(reject.id))
              .toList();

          gotRequestRejects.add(requestReject.copyWith(
            requestTypeId: requests.id,
            rejectTypesId: rejects.map((e) => e.id).toList(),
          ));
        }
        emit(
          GotRequestRejects(
            gotRequestRejects
              ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
            gotRequests,
          ),
        );
      },
    );
  }

  Future<void> _updateRequestRejectTemplateHandler(
    UpdateRequestRejectTpEvent event,
    Emitter<RequestRejectTpState> emit,
  ) async {
    if (state is GotRequestRejects) {
      final requestRejects = (state as GotRequestRejects).requestRejects;

      List<RequestRejectTemplateModel> updated = [];
      List<RequestTypeModel> gotRequests = [];
      gotRequests = (state as GotRequestTypes)
          .requestTypes
          .map((purpose) => purpose)
          .toList();

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

      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        GotRequestRejects(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
          gotRequests,
        ),
      );
    }
  }
}
