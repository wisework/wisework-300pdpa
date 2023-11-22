// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/presets/request_types_preset.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'data_subject_right_event.dart';
part 'data_subject_right_state.dart';

class DataSubjectRightBloc
    extends Bloc<DataSubjectRightEvent, DataSubjectRightState> {
  DataSubjectRightBloc({
    required DataSubjectRightRepository dataSubjectRightRepository,
    required MasterDataRepository masterDataRepository,
  })  : _dataSubjectRightRepository = dataSubjectRightRepository,
        _masterDataRepository = masterDataRepository,
        super(const DataSubjectRightInitial()) {
    on<GetDataSubjectRightsEvent>(_getDataSubjectRightsHandler);
    on<UpdateDataSubjectRightsEvent>(_updateDataSubjectRightsHandler);
  }

  final DataSubjectRightRepository _dataSubjectRightRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getDataSubjectRightsHandler(
    GetDataSubjectRightsEvent event,
    Emitter<DataSubjectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const DataSubjectRightError('Required company ID'));
      return;
    }

    emit(const GettingDataSubjectRights());

    final result = await _dataSubjectRightRepository.getDataSubjectRights(
      event.companyId,
    );

    await result.fold(
      (failure) {
        emit(DataSubjectRightError(failure.errorMessage));
      },
      (dataSubjectRights) async {
        List<DataSubjectRightModel> updated = [];

        for (DataSubjectRightModel from in dataSubjectRights) {
          //? Sort Process Requests
          List<ProcessRequestModel> processRequestSorted = [];

          for (ProcessRequestModel request in from.processRequests) {
            final reasonTypes = request.reasonTypes
              ..sort((a, b) => a.id.compareTo(b.id));
            processRequestSorted
                .add(request.copyWith(reasonTypes: reasonTypes));
          }

          processRequestSorted = processRequestSorted
            ..sort((a, b) => a.requestType.compareTo(b.requestType));

          updated.add(
            from.copyWith(
              dataRequester: from.dataRequester
                ..sort(
                  (a, b) => a.priority.compareTo(b.priority),
                ),
              dataOwner: from.dataOwner
                ..sort(
                  (a, b) => a.priority.compareTo(b.priority),
                ),
              processRequests: processRequestSorted,
            ),
          );
        }

        updated.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

        //? Get process request from all data subject right
        List<Map<String, ProcessRequestModel>> processRequests = [];
        for (DataSubjectRightModel from in updated) {
          for (ProcessRequestModel request in from.processRequests) {
            processRequests.add({from.id: request});
          }
        }

        List<RequestTypeModel> gotRequestTypes = requestTypesPreset;
        final result = await _masterDataRepository.getRequestTypes(
          event.companyId,
        );
        result.fold(
          (failure) => emit(DataSubjectRightError(failure.errorMessage)),
          (requestTypes) => gotRequestTypes.addAll(requestTypes),
        );

        emit(GotDataSubjectRights(updated, processRequests, gotRequestTypes));
      },
    );
  }

  Future<void> _updateDataSubjectRightsHandler(
    UpdateDataSubjectRightsEvent event,
    Emitter<DataSubjectRightState> emit,
  ) async {
    if (state is GotDataSubjectRights) {
      final dataSubjectRights =
          (state as GotDataSubjectRights).dataSubjectRights;
      final requestTypes = (state as GotDataSubjectRights).requestTypes;

      List<DataSubjectRightModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = dataSubjectRights.map((dsr) => dsr).toList()
            ..add(event.dataSubjectRight);
          break;
        case UpdateType.updated:
          for (DataSubjectRightModel dsr in dataSubjectRights) {
            if (dsr.id == event.dataSubjectRight.id) {
              updated.add(event.dataSubjectRight);
            } else {
              updated.add(dsr);
            }
          }
          break;
        case UpdateType.deleted:
          updated = dataSubjectRights
              .where((purpose) => purpose.id != event.dataSubjectRight.id)
              .toList();
          break;
      }

      updated.sort((a, b) => b.updatedDate.compareTo(a.updatedDate));

      //? Get process request from all data subject right
      List<Map<String, ProcessRequestModel>> processRequests = [];
      for (DataSubjectRightModel from in updated) {
        for (ProcessRequestModel request in from.processRequests) {
          processRequests.add({from.id: request});
        }
      }

      emit(GotDataSubjectRights(updated, processRequests, requestTypes));
    }
  }
}
