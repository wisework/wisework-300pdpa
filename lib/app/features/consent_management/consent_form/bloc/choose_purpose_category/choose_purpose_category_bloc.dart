import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'choose_purpose_category_event.dart';
part 'choose_purpose_category_state.dart';

class ChoosePurposeCategoryBloc
    extends Bloc<ChoosePurposeCategoryEvent, ChoosePurposeCategoryState> {
  ChoosePurposeCategoryBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const ChoosePurposeCategoryInitial()) {
    on<GetCurrentAllPurposeCategoryEvent>(_getCurrentAllPurposeCategoryHandler);
  }

  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentAllPurposeCategoryHandler(
    GetCurrentAllPurposeCategoryEvent event,
    Emitter<ChoosePurposeCategoryState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const ChoosePurposeCategoryError('Required company ID'));
      return;
    }

    emit(const GetingCurrentPurposeCategory());

    final List<String> allPurpose = [];
    final List<PurposeModel> gotPurpose = [];

    final result =
        await _masterDataRepository.getPurposeCategories(event.companyId);

    await result.fold(
      (failure) {
        emit(ChoosePurposeCategoryError(failure.errorMessage));
        return;
      },
      (purposeCategories) async {
        allPurpose.addAll(purposeCategories.expand((form) => form.purposes));

        for (String purposeId in allPurpose) {
          final result = await _masterDataRepository.getPurposeById(
            purposeId,
            event.companyId,
          );

          result.fold(
            (failure) => emit(ChoosePurposeCategoryError(failure.errorMessage)),
            (purpose) => gotPurpose.add(purpose),
          );
        }

        emit(GotCurrentPurposeCategory(
            purposeCategories..sort((a, b) => b.priority.compareTo(a.priority)),
            gotPurpose));
      },
    );
  }
}
