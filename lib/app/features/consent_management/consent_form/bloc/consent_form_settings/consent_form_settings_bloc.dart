// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'consent_form_settings_event.dart';
part 'consent_form_settings_state.dart';

class ConsentFormSettingsBloc
    extends Bloc<ConsentFormSettingsEvent, ConsentFormSettingsState> {
  ConsentFormSettingsBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const ConsentFormSettingsInitial()) {
    on<GetConsentFormSettingsEvent>(_getConsentFormSettingsHandler);
    on<UpdateCurrentFormSettingsEvent>(_updateCurrentFormSettingsHandler);
    on<UpdateCurrentThemeSettingsEvent>(_updateCurrentThemeSettingsHandler);
    on<UpdateConsentFormSettingsEvent>(_updateConsentFormSettingsHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getConsentFormSettingsHandler(
    GetConsentFormSettingsEvent event,
    Emitter<ConsentFormSettingsState> emit,
  ) async {
    if (event.consentId.isEmpty) {
      emit(const ConsentFormSettingsError('Required consent ID'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const ConsentFormSettingsError('Required company ID'));
      return;
    }

    emit(const GettingConsentFormSettings());

    final result = await _consentRepository.getConsentFormById(
      event.consentId,
      event.companyId,
    );

    ConsentFormModel gotConsentForm = ConsentFormModel.empty();
    List<CustomFieldModel> gotCustomFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<PurposeModel> gotPurposes = [];
    List<ConsentThemeModel> gotConsentThemes = [];

    await result.fold(
      (failure) {
        emit(ConsentFormSettingsError(failure.errorMessage));
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
            (failure) => emit(ConsentFormSettingsError(failure.errorMessage)),
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
              emit(ConsentFormSettingsError(failure.errorMessage));
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
                    ConsentFormSettingsError(failure.errorMessage),
                  ),
                  (purpose) => gotPurposes.add(purpose),
                );
              }
            },
          );
        }

        final result = await _consentRepository.getConsentThemes(
          event.companyId,
        );

        result.fold(
          (failure) => emit(ConsentFormSettingsError(failure.errorMessage)),
          (consentThemes) {
            gotConsentThemes = consentThemes;
          },
        );
      },
    );

    emit(GotConsentFormSettings(
      gotConsentForm,
      gotCustomFields,
      gotPurposeCategories,
      gotPurposes,
      gotConsentThemes,
      gotConsentThemes.firstWhere(
        (theme) => theme.id == gotConsentForm.consentThemeId,
        orElse: () => ConsentThemeModel.initial(),
      ),
    ));
  }

  void _updateCurrentFormSettingsHandler(
    UpdateCurrentFormSettingsEvent event,
    Emitter<ConsentFormSettingsState> emit,
  ) {
    if (state is GotConsentFormSettings) {
      final settings = state as GotConsentFormSettings;

      emit(
        GotConsentFormSettings(
          event.consentForm,
          settings.customFields,
          settings.purposeCategories,
          settings.purposes,
          settings.consentThemes,
          settings.currentConsentTheme,
        ),
      );
    }
  }

  void _updateCurrentThemeSettingsHandler(
    UpdateCurrentThemeSettingsEvent event,
    Emitter<ConsentFormSettingsState> emit,
  ) {
    if (state is GotConsentFormSettings) {
      final settings = state as GotConsentFormSettings;

      emit(
        GotConsentFormSettings(
          event.consentForm,
          settings.customFields,
          settings.purposeCategories,
          settings.purposes,
          settings.consentThemes,
          event.consentTheme,
        ),
      );
    }
  }

  Future<void> _updateConsentFormSettingsHandler(
    UpdateConsentFormSettingsEvent event,
    Emitter<ConsentFormSettingsState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const ConsentFormSettingsError('Required company ID'));
      return;
    }

    if (state is GotConsentFormSettings) {
      final settings = state as GotConsentFormSettings;

      emit(const UpdatingConsentFormSettings());

      final result = await _consentRepository.updateConsentForm(
        settings.consentForm,
        event.companyId,
      );

      await Future.delayed(const Duration(milliseconds: 800));

      result.fold(
        (failure) => emit(ConsentFormSettingsError(failure.errorMessage)),
        (_) => emit(
          GotConsentFormSettings(
            settings.consentForm,
            settings.customFields,
            settings.purposeCategories,
            settings.purposes,
            settings.consentThemes,
            settings.currentConsentTheme,
          ),
        ),
      );
    }
  }
}
