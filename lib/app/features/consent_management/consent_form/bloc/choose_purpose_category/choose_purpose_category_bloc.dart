import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'choose_purpose_category_event.dart';
part 'choose_purpose_category_state.dart';

class ChoosePurposeCategoryBloc
    extends Bloc<ChoosePurposeCategoryEvent, ChoosePurposeCategoryState> {
  ChoosePurposeCategoryBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        _consentRepository = consentRepository,
        super(const ChoosePurposeCategoryInitial()) {
    on<GetCurrentAllPurposeCategoryEvent>(_getCurrentAllPurposeCategoryHandler);
  }

  final ConsentRepository _consentRepository;
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

    ConsentFormModel gotConsentForm = ConsentFormModel.empty();
    final List<String> allPurpose = [];
    final List<PurposeModel> gotPurpose = [];

    final resultPurposeCategories =
        await _masterDataRepository.getPurposeCategories(event.companyId);

    await resultPurposeCategories.fold(
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

        if (event.consentFormId.isEmpty) {
          emit(GotCurrentPurposeCategory(
            purposeCategories..sort((a, b) => b.priority.compareTo(a.priority)),
            gotPurpose,
            ConsentFormModel.empty(),
          ));
          return;
        }

        final result = await _consentRepository.getConsentFormById(
          event.consentFormId,
          event.companyId,
        );

        await Future.delayed(const Duration(milliseconds: 800));

        await result.fold((failure) {
          emit(ChoosePurposeCategoryError(failure.errorMessage));
          return;
        }, (consentForm) async {
          emit(GotCurrentPurposeCategory(
            purposeCategories..sort((a, b) => b.priority.compareTo(a.priority)),
            gotPurpose,
            consentForm,
          ));
        });
      },
    );
  }
}
