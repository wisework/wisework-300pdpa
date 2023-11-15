// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'reject_type_event.dart';
part 'reject_type_state.dart';

class RejectTypeBloc extends Bloc<RejectTypeEvent, RejectTypeState> {
  RejectTypeBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const RejectTypeInitial()) {
    on<GetRejectTypeEvent>(_getRejectTypesHandler);
    on<UpdateRejectTypeEvent>(_updateRejectTypesHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getRejectTypesHandler(
    GetRejectTypeEvent event,
    Emitter<RejectTypeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const RejectTypeError('Required company ID'));
      return;
    }

    emit(const GettingRejectType());

    final result = await _masterDataRepository.getRejectTypes(event.companyId);

    result.fold(
      (failure) => emit(RejectTypeError(failure.errorMessage)),
      (rejectTypes) => emit(GotRejectTypes(
        rejectTypes..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }

  Future<void> _updateRejectTypesHandler(
    UpdateRejectTypeEvent event,
    Emitter<RejectTypeState> emit,
  ) async {
    if (state is GotRejectTypes) {
      final rejectTypes = (state as GotRejectTypes).rejectTypes;

      List<RejectTypeModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = rejectTypes.map((rejectType) => rejectType).toList()
            ..add(event.rejectType);
          break;
        case UpdateType.updated:
          for (RejectTypeModel rejectType in rejectTypes) {
            if (rejectType.id == event.rejectType.id) {
              updated.add(event.rejectType);
            } else {
              updated.add(rejectType);
            }
          }
          break;
        case UpdateType.deleted:
          updated = rejectTypes
              .where((rejectType) => rejectType.id != event.rejectType.id)
              .toList();
          break;
      }

      emit(
        GotRejectTypes(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
