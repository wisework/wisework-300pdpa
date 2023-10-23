// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
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
    on<UpdatePurposeCategoriesChangedEvent>(
        _updatePurposeCategoriesChangedHandler);
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

    List<PurposeModel> gotPurposes = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];

    final purposeResult = await _masterDataRepository.getPurposes(
      event.companyId,
    );
    purposeResult.fold(
      (failure) {
        emit(PurposeCategoryError(failure.errorMessage));
        return;
      },
      (purposes) {
        gotPurposes = purposes;
      },
    );

    final purposeCategoryResult =
        await _masterDataRepository.getPurposeCategories(
      event.companyId,
    );
    purposeCategoryResult.fold(
      (failure) {
        emit(PurposeCategoryError(failure.errorMessage));
        return;
      },
      (purposeCategories) {
        for (PurposeCategoryModel category in purposeCategories) {
          final purposeIds =
              category.purposes.map((purpose) => purpose.id).toList();
          final purposes = gotPurposes
              .where((purpose) => purposeIds.contains(purpose.id))
              .toList();

          gotPurposeCategories.add(category.copyWith(purposes: purposes));
        }

        emit(
          GotPurposeCategories(
            gotPurposeCategories
              ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
          ),
        );
      },
    );
  }

  Future<void> _updatePurposeCategoriesChangedHandler(
    UpdatePurposeCategoriesChangedEvent event,
    Emitter<PurposeCategoryState> emit,
  ) async {
    if (state is GotPurposeCategories) {
      final purposeCategories =
          (state as GotPurposeCategories).purposeCategories;

      List<PurposeCategoryModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = purposeCategories.map((category) => category).toList()
            ..add(event.purposeCategory);
          break;
        case UpdateType.updated:
          updated = purposeCategories
              .map((category) => category.id == event.purposeCategory.id
                  ? event.purposeCategory
                  : category)
              .toList();
          break;
        case UpdateType.deleted:
          updated = purposeCategories
              .where((category) => category.id != event.purposeCategory.id)
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
