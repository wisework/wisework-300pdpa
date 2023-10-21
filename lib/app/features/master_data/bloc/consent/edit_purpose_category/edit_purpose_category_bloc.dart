// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_purpose_category_event.dart';
part 'edit_purpose_category_state.dart';

class EditPurposeCategoryBloc
    extends Bloc<EditPurposeCategoryEvent, EditPurposeCategoryState> {
  EditPurposeCategoryBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const EditPurposeCategoryInitial()) {
    on<GetCurrentPurposeCategoryEvent>(_getCurrentPurposeCategoryHandler);
    on<CreateCurrentPurposeCategoryEvent>(_createCurrentPurposeCategoryHandler);
    on<UpdateCurrentPurposeCategoryEvent>(_updateCurrentPurposeCategoryHandler);
    on<DeleteCurrentPurposeCategoryEvent>(_deleteCurrentPurposeCategoryHandler);
  }
  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentPurposeCategoryHandler(
    GetCurrentPurposeCategoryEvent event,
    Emitter<EditPurposeCategoryState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditPurposeCategoryError('Required company ID'));
      return;
    }
    if (event.purposeCategoryId.isEmpty) {
      final result = await _masterDataRepository.getPurposes(
        event.companyId,
      );

      result.fold(
        (failure) => emit(EditPurposeCategoryError(failure.errorMessage)),
        (purposes) => emit(GotCurrentPurposeCategory(
          PurposeCategoryModel.empty(),
          purposes,
        )),
      );
      return;
    }

    emit(const GetingCurrentPurposeCategory());

    final result = await _masterDataRepository.getPurposeCategoryById(
      event.purposeCategoryId,
      event.companyId,
    );

    await result.fold(
      (failure) {
        emit(EditPurposeCategoryError(failure.errorMessage));
        return;
      },
      (purposeCategory) async {
        final result = await _masterDataRepository.getPurposes(
          event.companyId,
        );

        result.fold(
          (failure) => emit(EditPurposeCategoryError(failure.errorMessage)),
          (purposes) => emit(GotCurrentPurposeCategory(
            purposeCategory,
            purposes,
          )),
        );
      },
    );
  }

  Future<void> _createCurrentPurposeCategoryHandler(
    CreateCurrentPurposeCategoryEvent event,
    Emitter<EditPurposeCategoryState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditPurposeCategoryError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentPurposeCategory());

    final result = await _masterDataRepository.createPurposeCategory(
      event.purposeCategory,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditPurposeCategoryError(failure.errorMessage)),
      (purposeCategory) => emit(CreatedCurrentPurposeCategory(purposeCategory)),
    );
  }

  Future<void> _updateCurrentPurposeCategoryHandler(
    UpdateCurrentPurposeCategoryEvent event,
    Emitter<EditPurposeCategoryState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditPurposeCategoryError('Required company ID'));
      return;
    }

    List<PurposeModel> purposes = [];
    if (state is GotCurrentPurposeCategory) {
      purposes = (state as GotCurrentPurposeCategory).purposes;
    } else if (state is UpdatedCurrentPurposeCategory) {
      purposes = (state as UpdatedCurrentPurposeCategory).purposes;
    }

    emit(const UpdatingCurrentPurposeCategory());

    final result = await _masterDataRepository.updatePurposeCategory(
      event.purposeCategory,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditPurposeCategoryError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentPurposeCategory(
        event.purposeCategory,
        purposes,
      )),
    );
  }

  Future<void> _deleteCurrentPurposeCategoryHandler(
    DeleteCurrentPurposeCategoryEvent event,
    Emitter<EditPurposeCategoryState> emit,
  ) async {
    if (event.purposeCategoryId.isEmpty) return;

    if (event.companyId.isEmpty) {
      emit(const EditPurposeCategoryError('Required company ID'));
      return;
    }

    emit(const DeletingCurrentPurposeCategory());

    final result = await _masterDataRepository.deletePurposeCategory(
      event.purposeCategoryId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditPurposeCategoryError(failure.errorMessage)),
      (_) => emit(DeletedCurrentPurposeCategory(event.purposeCategoryId)),
    );
  }
}
