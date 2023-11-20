// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'request_type_event.dart';
part 'request_type_state.dart';

class RequestTypeBloc extends Bloc<RequestTypeEvent, RequestTypeState> {
  RequestTypeBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const RequestTypeInitial()) {
    on<GetRequestTypesEvent>(_getRequestTypesHandler);
    on<UpdateRequestTypesChangedEvent>(_updateRequestTypesHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getRequestTypesHandler(
    GetRequestTypesEvent event,
    Emitter<RequestTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const RequestTypeError('Required company ID'));
      return;
    }

    emit(const GettingRequestType());

    List<RejectTypeModel> gotRejectTypes = [];
    List<RequestTypeModel> gotRequestTypes = [];

    final rejectResult = await _masterDataRepository.getRejectTypes(
      event.companyId,
    );
    rejectResult.fold(
      (failure) {
        emit(RequestTypeError(failure.errorMessage));
        return;
      },
      (rejects) {
        gotRejectTypes = rejects;
      },
    );

    final requestTypeResult = await _masterDataRepository.getRequestTypes(
      event.companyId,
    );

    requestTypeResult.fold(
      (failure) {
        emit(RequestTypeError(failure.errorMessage));
        return;
      },
      (requestTypes) {
        for (RequestTypeModel request in requestTypes) {
          final rejectIds =
              request.rejectTypes.map((reject) => reject.id).toList();
          final rejects = gotRejectTypes
              .where((reject) => rejectIds.contains(reject.id))
              .toList();

          gotRequestTypes.add(request.copyWith(rejectTypes: rejects));
        }
        emit(
          GotRequestTypes(
            gotRequestTypes
              ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
          ),
        );
      },
    );
  }

  Future<void> _updateRequestTypesHandler(
    UpdateRequestTypesChangedEvent event,
    Emitter<RequestTypeState> emit,
  ) async {
    if (state is GotRequestTypes) {
      final requestTypes = (state as GotRequestTypes).requestTypes;

      List<RequestTypeModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = requestTypes.map((requestType) => requestType).toList()
            ..add(event.requestType);
          break;
        case UpdateType.updated:
          for (RequestTypeModel requestType in requestTypes) {
            if (requestType.id == event.requestType.id) {
              updated.add(event.requestType);
            } else {
              updated.add(requestType);
            }
          }
          break;
        case UpdateType.deleted:
          updated = requestTypes
              .where((requestType) => requestType.id != event.requestType.id)
              .toList();
          break;
      }

      emit(
        GotRequestTypes(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
