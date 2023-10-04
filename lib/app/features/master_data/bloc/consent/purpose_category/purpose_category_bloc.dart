// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'purpose_category_event.dart';
part 'purpose_category_state.dart';

class PurposeCategoryBloc
    extends Bloc<PurposeCategoryEvent, PurposeCategoryState> {
  PurposeCategoryBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const PurposeCategoryInitial()) {
    on<GetPurposeCategoriesEvent>(_getPurposeCategoriesHandler);
    on<UpdatePurposeCategoryEvent>(_updatePurposeCategoryHandler);
  }
  final MasterDataRepository _masterDataRepository;

  Future<void> _getPurposeCategoriesHandler(
    GetPurposeCategoriesEvent event,
    Emitter<PurposeCategoryState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const PurposeCategoryError('Required company ID'));
      return;
    }

    emit(const GettingPurposeCategories());

    final result =
        await _masterDataRepository.getPurposeCategories(event.companyId);

    result.fold(
      (failure) => emit(PurposeCategoryError(failure.errorMessage)),
      (purposeCategories) => emit(GotPurposeCategories(
        purposeCategories
          ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }

  Future<void> _updatePurposeCategoryHandler(
    UpdatePurposeCategoryEvent event,
    Emitter<PurposeCategoryState> emit,
  ) async {
    if (state is GotPurposeCategories) {
      final purposeCategories =
          (state as GotPurposeCategories).purposeCategories;

      List<PurposeCategoryModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = purposeCategories
              .map((purposeCategories) => purposeCategories)
              .toList()
            ..add(event.purposeCategory);
          break;
        case UpdateType.updated:
          for (PurposeCategoryModel purposeCategories in purposeCategories) {
            if (purposeCategories.id == event.purposeCategory.id) {
              updated.add(event.purposeCategory);
            } else {
              updated.add(purposeCategories);
            }
          }
          break;
        case UpdateType.deleted:
          updated = purposeCategories
              .where((purposeCategories) =>
                  purposeCategories.id != event.purposeCategory.id)
              .toList();
          break;
      }

      emit(
        GotPurposeCategories(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
