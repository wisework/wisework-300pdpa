// ignore: depend_on_referenced_packages
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

    final emptyConsentForm = ConsentFormModel.empty();
    ConsentFormModel gotConsentForm = emptyConsentForm;
    List<MandatoryFieldModel> gotMandatoryFields = [];
    List<PurposeModel> gotPurposes = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<CustomFieldModel> gotCustomFields = [];
    List<ConsentThemeModel> gotConsentThemes = [];

    if (event.consentFormId.isNotEmpty) {
      final consentFormResult = await _consentRepository.getConsentFormById(
        event.consentFormId,
        event.companyId,
      );
      consentFormResult.fold(
        (failure) {
          emit(ConsentFormSettingsError(failure.errorMessage));
          return;
        },
        (consentForm) {
          gotConsentForm = consentForm;
        },
      );
    }

    final mandatoryFieldResult = await _masterDataRepository.getMandatoryFields(
      event.companyId,
    );
    mandatoryFieldResult.fold(
      (failure) {
        emit(ConsentFormSettingsError(failure.errorMessage));
        return;
      },
      (mandatoryField) {
        gotMandatoryFields = mandatoryField;
      },
    );

    final purposeResult = await _masterDataRepository.getPurposes(
      event.companyId,
    );
    purposeResult.fold(
      (failure) {
        emit(ConsentFormSettingsError(failure.errorMessage));
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
        emit(ConsentFormSettingsError(failure.errorMessage));
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
      },
    );

    final customFieldResult = await _masterDataRepository.getCustomFields(
      event.companyId,
    );
    customFieldResult.fold(
      (failure) {
        emit(ConsentFormSettingsError(failure.errorMessage));
        return;
      },
      (customFields) {
        gotCustomFields = customFields;
      },
    );

    final consentThemeResult = await _consentRepository.getConsentThemes(
      event.companyId,
    );
    consentThemeResult.fold(
      (failure) {
        emit(ConsentFormSettingsError(failure.errorMessage));
        return;
      },
      (consentThemes) {
        gotConsentThemes = consentThemes;
      },
    );

    //? Filter data for Consent Form
    if (gotConsentForm != emptyConsentForm) {
      gotConsentForm = gotConsentForm.copyWith(
        purposeCategories: gotConsentForm.purposeCategories.map((category) {
          final purposeCategory = gotPurposeCategories.firstWhere(
            (pc) => pc.id == category.id,
            orElse: () => category,
          );

          return purposeCategory.copyWith(priority: category.priority);
        }).toList(),
      );
    }

    emit(
      GotConsentFormSettings(
        gotConsentForm,
        gotMandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
        gotPurposes,
        gotPurposeCategories,
        // gotPurposeCategories..sort((a, b) => a.priority.compareTo(b.priority)),
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
    List<PurposeModel> purposes = [];
    List<PurposeCategoryModel> purposeCategories = [];
    List<CustomFieldModel> customFields = [];
    List<ConsentThemeModel> consentThemes = [];

    if (state is GotConsentFormSettings) {
      final settings = state as GotConsentFormSettings;

      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
      customFields = settings.customFields;
      consentThemes = settings.consentThemes;
    } else if (state is UpdatedConsentFormSettings) {
      final settings = state as UpdatedConsentFormSettings;

      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
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
          purposes,
          purposeCategories,
          // purposeCategories..sort((a, b) => a.priority.compareTo(b.priority)),
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
    List<PurposeModel> purposes = [];
    // ignore: unused_local_variable
    List<PurposeCategoryModel> purposeCategories = [];
    List<CustomFieldModel> customFields = [];
    List<ConsentThemeModel> consentThemes = [];
    ConsentThemeModel consentTheme = ConsentThemeModel.initial();

    if (state is GotConsentFormSettings) {
      final settings = state as GotConsentFormSettings;

      consentForm = settings.consentForm;
      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
      customFields = settings.customFields;
      consentThemes = settings.consentThemes;
      consentTheme = settings.consentTheme;
    } else if (state is UpdatedConsentFormSettings) {
      final settings = state as UpdatedConsentFormSettings;

      consentForm = settings.consentForm;
      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
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
        purposes,
        consentForm.purposeCategories
          ..sort((a, b) => a.priority.compareTo(b.priority)),
        customFields,
        updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        consentTheme,
      ),
    );
  }
}
