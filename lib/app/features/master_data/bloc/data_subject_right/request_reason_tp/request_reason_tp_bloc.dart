// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
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
    List<RequestTypeModel> gotRequests = [];
    List<ReasonTypeModel> gotReasons = [];
    List<RequestReasonTemplateModel> gotRequestReasons = [];

    final requestResult = await _masterDataRepository.getRequestTypes(
      event.companyId,
    );
    requestResult.fold(
      (failure) {
        emit(RequestReasonError(failure.errorMessage));
        return;
      },
      (requests) {
        gotRequests = requests;
      },
    );

    final reasonResult = await _masterDataRepository.getReasonTypes(
      event.companyId,
    );
    reasonResult.fold(
      (failure) {
        emit(RequestReasonError(failure.errorMessage));
        return;
      },
      (reasons) {
        gotReasons = reasons;
      },
    );

    final requestReasonResult =
        await _masterDataRepository.getRequestReasonTemplates(
      event.companyId,
    );
    requestReasonResult.fold(
      (failure) {
        emit(RequestReasonError(failure.errorMessage));
        return;
      },
      (requestReasonTemplates) {
        for (RequestReasonTemplateModel requestReason
            in requestReasonTemplates) {
          final requestIds = requestReason.requestTypeId;
          final requests = gotRequests
              .where((request) => requestIds.contains(request.id))
              .first;
          final reasonIds =
              requestReason.reasonTypesId.map((reason) => reason).toList();
          final reasons = gotReasons
              .where((reason) => reasonIds.contains(reason.id))
              .toList();

          gotRequestReasons.add(requestReason.copyWith(
            requestTypeId: requests.id,
            reasonTypesId: reasons.map((e) => e.id).toList(),
          ));
        }
        emit(
          GotRequestReasons(
            gotRequestReasons
              ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
            gotRequests,
          ),
        );
      },
    );
  }

  Future<void> _updateRequestReasonTemplateHandler(
    UpdateRequestReasonTpEvent event,
    Emitter<RequestReasonTpState> emit,
  ) async {
    if (state is GotRequestReasons) {
      final requestReasons = (state as GotRequestReasons).requestReasons;

      List<RequestReasonTemplateModel> updated = [];
      List<RequestTypeModel> gotRequests = [];
      gotRequests = (state as GotRequestTypes)
          .requestTypes
          .map((purpose) => purpose)
          .toList();

      switch (event.updateType) {
        case UpdateType.created:
          updated = requestReasons
              .map((requestReasons) => requestReasons)
              .toList()
            ..add(event.requestReason);
          break;
        case UpdateType.updated:
          for (RequestReasonTemplateModel requestReasons in requestReasons) {
            if (requestReasons.id == event.requestReason.id) {
              updated.add(event.requestReason);
            } else {
              updated.add(requestReasons);
            }
          }
          break;
        case UpdateType.deleted:
          updated = requestReasons
              .where((requestReasons) =>
                  requestReasons.id != event.requestReason.id)
              .toList();
          break;
      }

      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        GotRequestReasons(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
          gotRequests,
        ),
      );
    }
  }
}
