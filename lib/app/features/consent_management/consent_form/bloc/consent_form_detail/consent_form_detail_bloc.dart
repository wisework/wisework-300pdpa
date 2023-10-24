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
    on<UpdateConsentFormEvent>(_getUpdateconsentFormHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getConsentFormHandler(
    GetConsentFormEvent event,
    Emitter<ConsentFormDetailState> emit,
  ) async {
    if (event.consentFormId.isEmpty) {
      emit(const ConsentFormDetailError('Required consent form ID'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const ConsentFormDetailError('Required company ID'));
      return;
    }

    emit(const GettingConsentFormDetail());

    final emptyConsentForm = ConsentFormModel.empty();
    ConsentFormModel gotConsentForm = emptyConsentForm;
    List<MandatoryFieldModel> gotMandatoryFields = [];
    List<PurposeModel> gotPurposes = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<CustomFieldModel> gotCustomFields = [];
    ConsentThemeModel gotConsentTheme = ConsentThemeModel.initial();

    if (event.consentFormId.isNotEmpty) {
      final consentFormResult = await _consentRepository.getConsentFormById(
        event.consentFormId,
        event.companyId,
      );
      consentFormResult.fold(
        (failure) {
          emit(ConsentFormDetailError(failure.errorMessage));
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
        emit(ConsentFormDetailError(failure.errorMessage));
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
        emit(ConsentFormDetailError(failure.errorMessage));
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
        emit(ConsentFormDetailError(failure.errorMessage));
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
        emit(ConsentFormDetailError(failure.errorMessage));
        return;
      },
      (customFields) {
        gotCustomFields = customFields;
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

      if (gotConsentForm.consentThemeId.isNotEmpty) {
        final result = await _consentRepository.getConsentThemeById(
          gotConsentForm.consentThemeId,
          event.companyId,
        );

        result.fold(
          (failure) => emit(ConsentFormDetailError(failure.errorMessage)),
          (consentThemes) {
            gotConsentTheme = consentThemes;
          },
        );
      }
    }

    emit(
      GotConsentFormDetail(
        gotConsentForm,
        gotMandatoryFields..sort((a, b) => b.priority.compareTo(a.priority)),
        gotPurposes,
        gotPurposeCategories..sort((a, b) => b.priority.compareTo(a.priority)),
        gotCustomFields,
        gotConsentTheme,
      ),
    );
  }

  Future<void> _getUpdateconsentFormHandler(
    UpdateConsentFormEvent event,
    Emitter<ConsentFormDetailState> emit,
  ) async {
    ConsentFormModel consentForm = ConsentFormModel.empty();
    List<MandatoryFieldModel> mandatoryFields = [];
    List<PurposeModel> purposes = [];
    List<PurposeCategoryModel> purposeCategories = [];
    List<CustomFieldModel> customFields = [];
    ConsentThemeModel consentTheme = ConsentThemeModel.initial();

    if (state is GotConsentFormDetail) {
      final settings = state as GotConsentFormDetail;

      consentForm = settings.consentForm;
      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
      customFields = settings.customFields;
      consentTheme = settings.consentTheme;
    } else if (state is UpdateConsentFormDetail) {
      final settings = state as UpdateConsentFormDetail;

      consentForm = settings.consentForm;
      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
      customFields = settings.customFields;
      consentTheme = settings.consentTheme;
    }

    ConsentFormModel updatedConsentForm = ConsentFormModel.empty();
    List<MandatoryFieldModel> updateMandatoryFields;
    List<PurposeCategoryModel> updatePurposeCategoryModel;
    List<PurposeModel> updatePurposeModel;
    ConsentThemeModel updateConsentThemeModel;

    switch (event.updateType) {
      case UpdateType.created:
        updatedConsentForm = event.consentForm;
        break;
      case UpdateType.updated:
        if (consentForm.id == event.consentForm.id) {
          updatedConsentForm = event.consentForm;
        }
        break;
      case UpdateType.deleted:
        break;
    }

    GotConsentFormDetail(
      updatedConsentForm,
      mandatoryFields..sort((a, b) => b.priority.compareTo(a.priority)),
      purposes,
      purposeCategories..sort((a, b) => b.priority.compareTo(a.priority)),
      customFields,
      consentTheme,
    );
  }
}
