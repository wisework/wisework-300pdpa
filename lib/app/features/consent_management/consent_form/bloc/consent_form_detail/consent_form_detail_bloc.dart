import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
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
    List<MandatoryFieldModel> gotMandatoryFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<PurposeModel> gotPurposes = [];
    List<CustomFieldModel> gotCustomFields = [];
    List<ConsentThemeModel> gotConsentThemes = [];

    await result.fold(
      (failure) {
        emit(ConsentFormDetailError(failure.errorMessage));
        return;
      },
      (consentForm) async {
        gotConsentForm = consentForm;

        for (String mandatoryFieldId in consentForm.mandatoryFields) {
          final result = await _masterDataRepository.getMandatoryFieldById(
            mandatoryFieldId,
            event.companyId,
          );

          result.fold(
            (failure) => emit(ConsentFormDetailError(failure.errorMessage)),
            (mandatoryField) => gotMandatoryFields.add(mandatoryField),
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

        final result = await _consentRepository.getConsentThemes(
          event.companyId,
        );

        result.fold(
          (failure) => emit(ConsentFormDetailError(failure.errorMessage)),
          (consentThemes) {
            gotConsentThemes = consentThemes;
          },
        );
      },
    );

    emit(
      GotConsentFormDetail(
        gotConsentForm,
        gotMandatoryFields,
        gotPurposeCategories..sort((a, b) => b.priority.compareTo(a.priority)),
        gotPurposes,
        gotCustomFields,
        gotConsentThemes
          ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        gotConsentThemes.firstWhere(
          (theme) => theme.id == gotConsentForm.consentThemeId,
          orElse: () => ConsentThemeModel.initial(),
        ),
      ),
    );
  }
}
