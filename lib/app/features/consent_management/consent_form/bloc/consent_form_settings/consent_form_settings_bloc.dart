// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/etc/user_reorder_item.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

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
    on<UpdateConsentFormSettingsEvent>(_updateConsentFormSettingsHandler);
    on<UpdateConsentThemesEvent>(_updateConsentThemesHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getConsentFormSettingsHandler(
    GetConsentFormSettingsEvent event,
    Emitter<ConsentFormSettingsState> emit,
  ) async {
    if (event.consentFormId.isEmpty) {
      emit(const ConsentFormSettingsError('Required consent form ID'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const ConsentFormSettingsError('Required company ID'));
      return;
    }

    emit(const GettingConsentFormSettings());

    ConsentFormModel gotConsentForm = ConsentFormModel.empty();
    List<MandatoryFieldModel> gotMandatoryFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<CustomFieldModel> gotCustomFields = [];
    List<PurposeModel> gotPurposes = [];
    List<ConsentThemeModel> gotConsentThemes = [];

    final result = await _consentRepository.getConsentFormById(
      event.consentFormId,
      event.companyId,
    );

    await result.fold(
      (failure) {
        emit(ConsentFormSettingsError(failure.errorMessage));
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
            (failure) => emit(ConsentFormSettingsError(failure.errorMessage)),
            (mandatoryField) => gotMandatoryFields.add(mandatoryField),
          );
        }

        for (UserReorderItem item in consentForm.purposeCategories) {
          final result = await _masterDataRepository.getPurposeCategoryById(
            item.id,
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

    emit(
      GotConsentFormSettings(
        gotConsentForm,
        gotMandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
        gotPurposeCategories..sort((a, b) => a.priority.compareTo(b.priority)),
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

  Future<void> _updateConsentFormSettingsHandler(
    UpdateConsentFormSettingsEvent event,
    Emitter<ConsentFormSettingsState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const ConsentFormSettingsError('Required company ID'));
      return;
    }

    List<MandatoryFieldModel> mandatoryFields = [];
    List<PurposeCategoryModel> purposeCategories = [];
    List<PurposeModel> purposes = [];
    List<CustomFieldModel> customFields = [];
    List<ConsentThemeModel> consentThemes = [];

    if (state is GotConsentFormSettings) {
      final settings = state as GotConsentFormSettings;

      mandatoryFields = settings.mandatoryFields;
      purposeCategories = settings.purposeCategories;
      purposes = settings.purposes;
      customFields = settings.customFields;
      consentThemes = settings.consentThemes;
    } else if (state is UpdatedConsentFormSettings) {
      final settings = state as UpdatedConsentFormSettings;

      mandatoryFields = settings.mandatoryFields;
      purposeCategories = settings.purposeCategories;
      purposes = settings.purposes;
      customFields = settings.customFields;
      consentThemes = settings.consentThemes;
    }

    emit(const UpdatingConsentFormSettings());

    final result = await _consentRepository.updateConsentForm(
      event.consentForm,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(ConsentFormSettingsError(failure.errorMessage)),
      (_) => emit(
        GotConsentFormSettings(
          event.consentForm,
          mandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
          purposeCategories..sort((a, b) => a.priority.compareTo(b.priority)),
          purposes,
          customFields,
          consentThemes..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
          consentThemes.firstWhere(
            (theme) => theme.id == event.consentForm.consentThemeId,
            orElse: () => ConsentThemeModel.initial(),
          ),
        ),
      ),
    );
  }

  Future<void> _updateConsentThemesHandler(
    UpdateConsentThemesEvent event,
    Emitter<ConsentFormSettingsState> emit,
  ) async {
    ConsentFormModel consentForm = ConsentFormModel.empty();
    List<MandatoryFieldModel> mandatoryFields = [];
    List<PurposeCategoryModel> purposeCategories = [];
    List<PurposeModel> purposes = [];
    List<CustomFieldModel> customFields = [];
    List<ConsentThemeModel> consentThemes = [];
    ConsentThemeModel consentTheme = ConsentThemeModel.initial();

    if (state is GotConsentFormSettings) {
      final settings = state as GotConsentFormSettings;

      consentForm = settings.consentForm;
      mandatoryFields = settings.mandatoryFields;
      purposeCategories = settings.purposeCategories;
      purposes = settings.purposes;
      customFields = settings.customFields;
      consentThemes = settings.consentThemes;
      consentTheme = settings.consentTheme;
    } else if (state is UpdatedConsentFormSettings) {
      final settings = state as UpdatedConsentFormSettings;

      consentForm = settings.consentForm;
      mandatoryFields = settings.mandatoryFields;
      purposeCategories = settings.purposeCategories;
      purposes = settings.purposes;
      customFields = settings.customFields;
      consentThemes = settings.consentThemes;
      consentTheme = settings.consentTheme;
    }

    List<ConsentThemeModel> updated = [];

    switch (event.updateType) {
      case UpdateType.created:
        updated = consentThemes.map((theme) => theme).toList()
          ..add(event.consentTheme);
        break;
      case UpdateType.updated:
        for (ConsentThemeModel consentTheme in consentThemes) {
          if (consentTheme.id == event.consentTheme.id) {
            updated.add(event.consentTheme);
          } else {
            updated.add(consentTheme);
          }
        }
        break;
      case UpdateType.deleted:
        updated = consentThemes
            .where((theme) => theme.id != event.consentTheme.id)
            .toList();

        if (consentForm.consentThemeId == event.consentTheme.id) {
          consentForm = consentForm.copyWith(consentThemeId: '');
        }

        if (consentTheme.id == event.consentTheme.id) {
          consentTheme = ConsentThemeModel.initial();
        }
        break;
    }

    emit(
      GotConsentFormSettings(
        consentForm,
        mandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
        purposeCategories..sort((a, b) => a.priority.compareTo(b.priority)),
        purposes,
        customFields,
        updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        consentTheme,
      ),
    );
  }
}
