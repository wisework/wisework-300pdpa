// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'reason_type_event.dart';
part 'reason_type_state.dart';

class ReasonTypeBloc extends Bloc<ReasonTypeEvent, ReasonTypeState> {
  ReasonTypeBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const ReasonTypeInitial()) {
    on<GetReasonTypeEvent>(_getReasonTypesHandler);
    on<UpdateReasonTypeEvent>(_updateReasonTypesHandler);
  }
  final MasterDataRepository _masterDataRepository;

  Future<void> _getReasonTypesHandler(
    GetReasonTypeEvent event,
    Emitter<ReasonTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const ReasonTypeError('Required company ID'));
      return;
    }

    emit(const GettingReasonType());

    final result = await _masterDataRepository.getReasonTypes(event.companyId);

    result.fold(
      (failure) => emit(ReasonTypeError(failure.errorMessage)),
      (reasonTypes) => emit(GotReasonTypes(
        reasonTypes..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }

  Future<void> _updateReasonTypesHandler(
    UpdateReasonTypeEvent event,
    Emitter<ReasonTypeState> emit,
  ) async {
    if (state is GotReasonTypes) {
      final reasonTypes = (state as GotReasonTypes).reasonTypes;

      List<ReasonTypeModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = reasonTypes.map((reasonType) => reasonType).toList()
            ..add(event.reasonType);
          break;
        case UpdateType.updated:
          for (ReasonTypeModel reasonType in reasonTypes) {
            if (reasonType.reasonTypeId == event.reasonType.reasonTypeId) {
              updated.add(event.reasonType);
            } else {
              updated.add(reasonType);
            }
          }
          break;
        case UpdateType.deleted:
          updated = reasonTypes
              .where((reasonType) =>
                  reasonType.reasonTypeId != event.reasonType.reasonTypeId)
              .toList();
          break;
      }

      emit(
        GotReasonTypes(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
