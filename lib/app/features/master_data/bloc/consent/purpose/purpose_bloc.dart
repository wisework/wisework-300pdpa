// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'purpose_event.dart';
part 'purpose_state.dart';

class PurposeBloc extends Bloc<PurposeEvent, PurposeState> {
  PurposeBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const PurposeInitial()) {
    on<GetPurposesEvent>(_onGetPurposesHandler);
    on<UpdatePurposeEvent>(_onUpdatePurposeHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _onGetPurposesHandler(
    GetPurposesEvent event,
    Emitter<PurposeState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const PurposeError('Required company ID'));
      return;
    }

    emit(const LoadingPurposes());

    final result = await _masterDataRepository.getPurposes(event.companyId);

    result.fold(
      (failure) => emit(PurposeError(failure.errorMessage)),
      (purposes) => emit(LoadedPurposes(purposes)),
    );
  }

  void _onUpdatePurposeHandler(
    UpdatePurposeEvent event,
    Emitter<PurposeState> emit,
  ) {
    if (state is LoadedPurposes) {
      List<PurposeModel> purposes = [];

      for (PurposeModel purpose in (state as LoadedPurposes).purposes) {
        if (purpose.id == event.purpose.id) {
          purposes.add(event.purpose);
        } else {
          purposes.add(purpose);
        }
      }

      emit(LoadedPurposes(purposes));
    }
  }
}
