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
    on<UpdateEditPurposeCategoryStateEvent>(
        _updateEditPurposeCategoryStateHandler);
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

    emit(const GettingCurrentPurposeCategory());

    final emptyPurposeCategory = PurposeCategoryModel.empty();
    PurposeCategoryModel gotPurposeCategory = emptyPurposeCategory;
    List<PurposeModel> gotPurposes = [];

    if (event.purposeCategoryId.isNotEmpty) {
      final purposeCategoryResult =
          await _masterDataRepository.getPurposeCategoryById(
        event.purposeCategoryId,
        event.companyId,
      );
      purposeCategoryResult.fold(
        (failure) {
          emit(EditPurposeCategoryError(failure.errorMessage));
          return;
        },
        (purposeCategory) {
          gotPurposeCategory = purposeCategory;
        },
      );
    }

    final purposeResult = await _masterDataRepository.getPurposes(
      event.companyId,
    );
    purposeResult.fold(
      (failure) {
        emit(EditPurposeCategoryError(failure.errorMessage));
        return;
      },
      (purposes) {
        gotPurposes = purposes;
      },
    );

    if (gotPurposeCategory != emptyPurposeCategory) {
      final purposeIds =
          gotPurposeCategory.purposes.map((purpose) => purpose.id).toList();

      gotPurposeCategory = gotPurposeCategory.copyWith(
        purposes: gotPurposes.where((purpose) {
          return purposeIds.contains(purpose.id);
        }).toList(),
      );
    }

    emit(GotCurrentPurposeCategory(gotPurposeCategory, gotPurposes));
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

  Future<void> _updateEditPurposeCategoryStateHandler(
    UpdateEditPurposeCategoryStateEvent event,
    Emitter<EditPurposeCategoryState> emit,
  ) async {
    List<PurposeModel> purposes = [];

    if (state is GotCurrentPurposeCategory) {
      final purposeCategory =
          (state as GotCurrentPurposeCategory).purposeCategory;

      purposes = (state as GotCurrentPurposeCategory)
          .purposes
          .map((purpose) => purpose)
          .toList();
      purposes.add(event.purpose);

      emit(GotCurrentPurposeCategory(purposeCategory, purposes));
    } else if (state is UpdatedCurrentPurposeCategory) {
      final purposeCategory =
          (state as UpdatedCurrentPurposeCategory).purposeCategory;

      purposes = (state as UpdatedCurrentPurposeCategory)
          .purposes
          .map((purpose) => purpose)
          .toList();
      purposes.add(event.purpose);

      emit(UpdatedCurrentPurposeCategory(purposeCategory, purposes));
    }
  }
}
