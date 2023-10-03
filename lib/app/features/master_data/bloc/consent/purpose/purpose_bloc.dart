// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'purpose_event.dart';
part 'purpose_state.dart';

class PurposeBloc extends Bloc<PurposeEvent, PurposeState> {
  PurposeBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const PurposeInitial()) {
    on<GetPurposesEvent>(_getPurposesHandler);
    on<UpdatePurposeEvent>(_updatePurposeHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getPurposesHandler(
    GetPurposesEvent event,
    Emitter<PurposeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const PurposeError('Required company ID'));
      return;
    }

    emit(const GettingPurposes());

    final result = await _masterDataRepository.getPurposes(event.companyId);

    result.fold(
      (failure) => emit(PurposeError(failure.errorMessage)),
      (purposes) => emit(GotPurposes(
        purposes..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }

  Future<void> _updatePurposeHandler(
    UpdatePurposeEvent event,
    Emitter<PurposeState> emit,
  ) async {
    if (state is GotPurposes) {
      final purposes = (state as GotPurposes).purposes;

      List<PurposeModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = purposes.map((purpose) => purpose).toList()
            ..add(event.purpose);
          break;
        case UpdateType.updated:
          for (PurposeModel purpose in purposes) {
            if (purpose.id == event.purpose.id) {
              updated.add(event.purpose);
            } else {
              updated.add(purpose);
            }
          }
          break;
        case UpdateType.deleted:
          updated = purposes
              .where((purpose) => purpose.id != event.purpose.id)
              .toList();
          break;
      }

      emit(
        GotPurposes(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
