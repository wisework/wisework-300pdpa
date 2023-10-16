import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'consent_form_detail_event.dart';
part 'consent_form_detail_state.dart';

class ConsentFormDetailBloc
    extends Bloc<ConsentFormDetailEvent, ConsentFormDetailState> {
  ConsentFormDetailBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const ConsentFormDetailInitial()) {
    on<GetConsentFormEvent>(_getConsentFormHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getConsentFormHandler(
    GetConsentFormEvent event,
    Emitter<ConsentFormDetailState> emit,
  ) async {
    if (event.consentId.isEmpty) {
      emit(const ConsentFormDetailError('Required consent ID'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const ConsentFormDetailError('Required company ID'));
      return;
    }

    emit(const GettingConsentFormDetail());

    final result = await _consentRepository.getConsentFormById(
      event.consentId,
      event.companyId,
    );

    ConsentFormModel gotConsentForm = ConsentFormModel.empty();
    List<CustomFieldModel> gotCustomFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<PurposeModel> gotPurposes = [];

    await result.fold(
      (failure) {
        emit(ConsentFormDetailError(failure.errorMessage));
        return;
      },
      (consentForm) async {
        gotConsentForm = consentForm;

        for (String customFieldId in consentForm.customFields) {
          final result = await _masterDataRepository.getCustomFieldById(
            customFieldId,
            event.companyId,
          );

          result.fold(
            (failure) => emit(ConsentFormDetailError(failure.errorMessage)),
            (customField) => gotCustomFields.add(customField),
          );
        }

        for (String purposeCategoryId in consentForm.purposeCategories) {
          final result = await _masterDataRepository.getPurposeCategoryById(
            purposeCategoryId,
            event.companyId,
          );

          await result.fold(
            (failure) {
              emit(ConsentFormDetailError(failure.errorMessage));
              return;
            },
            (purposeCategory) async {
              gotPurposeCategories.add(purposeCategory);

              for (String purposeId in purposeCategory.purposes) {
                final result = await _masterDataRepository.getPurposeById(
                  purposeId,
                  event.companyId,
                );

                result.fold(
                  (failure) => emit(
                    ConsentFormDetailError(failure.errorMessage),
                  ),
                  (purpose) => gotPurposes.add(purpose),
                );
              }
            },
          );
        }
      },
    );

    emit(GotConsentFormDetail(
      gotConsentForm,
      gotCustomFields,
      gotPurposeCategories,
      gotPurposes,
    ));
  }
}
