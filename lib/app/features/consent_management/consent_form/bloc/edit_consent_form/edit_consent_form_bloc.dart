// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_consent_form_event.dart';
part 'edit_consent_form_state.dart';

class EditConsentFormBloc
    extends Bloc<EditConsentFormEvent, EditConsentFormState> {
  EditConsentFormBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const EditConsentFormInitial()) {
    on<GetCurrentConsentFormEvent>(_getCurrentConsentFormHandler);
    on<CreateCurrentConsentFormEvent>(_createCurrentConsentFormHandler);
    on<UpdateCurrentConsentFormEvent>(_updateCurrentConsentFormHandler);
    on<UpdateEditConsentFormStateEvent>(_updateEditConsentFormStateHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentConsentFormHandler(
    GetCurrentConsentFormEvent event,
    Emitter<EditConsentFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditConsentFormError('Required company ID'));
      return;
    }

    emit(const GetingCurrentConsentForm());

    final emptyConsentForm = ConsentFormModel.empty();
    ConsentFormModel gotConsentForm = emptyConsentForm;
    List<MandatoryFieldModel> gotMandatoryFields = [];
    List<PurposeModel> gotPurposes = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<CustomFieldModel> gotCustomFields = [];

    if (event.consentFormId.isNotEmpty) {
      final consentFormResult = await _consentRepository.getConsentFormById(
        event.consentFormId,
        event.companyId,
      );
      consentFormResult.fold(
        (failure) {
          emit(EditConsentFormError(failure.errorMessage));
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
        emit(EditConsentFormError(failure.errorMessage));
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
        emit(EditConsentFormError(failure.errorMessage));
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
        emit(EditConsentFormError(failure.errorMessage));
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
        emit(EditConsentFormError(failure.errorMessage));
        return;
      },
      (customFields) {
        gotCustomFields = customFields;
      },
    );

    //? Filter data for Consent Form
    if (gotConsentForm != emptyConsentForm) {
      final purposeCategories =
          gotConsentForm.purposeCategories.map((category) {
        final purposeCategory = gotPurposeCategories.firstWhere(
          (pc) => pc.id == category.id,
          orElse: () => category,
        );

        return purposeCategory.copyWith(priority: category.priority);
      }).toList();
      // ..sort((a, b) => a.priority.compareTo(b.priority));

      gotConsentForm = gotConsentForm.copyWith(
        purposeCategories: purposeCategories,
      );
    }

    emit(
      GotCurrentConsentForm(
        gotConsentForm,
        gotMandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
        gotPurposes,
        gotPurposeCategories..sort((a, b) => a.priority.compareTo(b.priority)),
        gotCustomFields,
      ),
    );
  }

  Future<void> _createCurrentConsentFormHandler(
    CreateCurrentConsentFormEvent event,
    Emitter<EditConsentFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditConsentFormError('Required company ID'));
      return;
    }

    List<MandatoryFieldModel> mandatoryFields = [];
    List<PurposeModel> purposes = [];
    List<PurposeCategoryModel> purposeCategories = [];
    List<CustomFieldModel> customFields = [];

    if (state is GotCurrentConsentForm) {
      final settings = state as GotCurrentConsentForm;

      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
      customFields = settings.customFields;
    } else if (state is UpdateCurrentConsentForm) {
      final settings = state as UpdateCurrentConsentForm;

      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
      customFields = settings.customFields;
    }

    emit(const CreatingCurrentConsentForm());

    const headerText = [
      LocalizedModel(language: 'en-US', text: 'Header'),
    ];
    const headerDescription = [
      LocalizedModel(language: 'en-US', text: ''),
    ];
    const footerDescription = [
      LocalizedModel(language: 'en-US', text: ''),
    ];
    const acceptConsentText = [
      LocalizedModel(language: 'en-US', text: 'Accept consent')
    ];
    const linkToPolicyText = [
      LocalizedModel(language: 'en-US', text: 'Link to policy'),
    ];
    const submitText = [
      LocalizedModel(language: 'en-US', text: 'Submit'),
    ];
    const cancelText = [
      LocalizedModel(language: 'en-US', text: 'Cancel'),
    ];

    final consentForm = event.consentForm.copyWith(
      headerText: headerText,
      headerDescription: headerDescription,
      footerDescription: footerDescription,
      acceptConsentText: acceptConsentText,
      submitText: submitText,
      cancelText: cancelText,
      linkToPolicyText: linkToPolicyText,
      linkToPolicyUrl: '',
    );

    final result = await _consentRepository.createConsentForm(
      consentForm,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (consentForm) => emit(
        CreatedCurrentConsentForm(
          consentForm,
          mandatoryFields,
          purposes,
          purposeCategories,
          customFields,
        ),
      ),
    );
  }

  Future<void> _updateCurrentConsentFormHandler(
    UpdateCurrentConsentFormEvent event,
    Emitter<EditConsentFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditConsentFormError('Required company ID'));
      return;
    }

    List<MandatoryFieldModel> mandatoryFields = [];
    List<PurposeModel> purposes = [];
    List<PurposeCategoryModel> purposeCategories = [];
    List<CustomFieldModel> customFields = [];

    if (state is GotCurrentConsentForm) {
      final settings = state as GotCurrentConsentForm;

      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
      customFields = settings.customFields;
    } else if (state is UpdateCurrentConsentForm) {
      final settings = state as UpdateCurrentConsentForm;

      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      purposeCategories = settings.purposeCategories;
      customFields = settings.customFields;
    }

    emit(const UpdatingCurrentConsentForm());

    final result = await _consentRepository.updateConsentForm(
      event.consentForm,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (_) => emit(
        UpdateCurrentConsentForm(
          event.consentForm,
          mandatoryFields,
          purposes,
          purposeCategories,
          customFields,
        ),
      ),
    );
  }

  Future<void> _updateEditConsentFormStateHandler(
    UpdateEditConsentFormStateEvent event,
    Emitter<EditConsentFormState> emit,
  ) async {
    List<PurposeCategoryModel> purposeCategories = [];

    if (state is GotCurrentConsentForm) {
      final consentForm = (state as GotCurrentConsentForm).consentForm;
      final mandatoryFields = (state as GotCurrentConsentForm).mandatoryFields;
      final purposes = (state as GotCurrentConsentForm).purposes;
      final customFields = (state as GotCurrentConsentForm).customFields;

      purposeCategories =
          consentForm.purposeCategories.map((category) => category).toList();
      purposeCategories.add(event.purposeCategory);

      emit(
        GotCurrentConsentForm(
          consentForm.copyWith(purposeCategories: purposeCategories),
          mandatoryFields,
          purposes,
          purposeCategories,
          customFields,
        ),
      );
    } else if (state is UpdateCurrentConsentForm) {
      final consentForm = (state as UpdateCurrentConsentForm).consentForm;
      final mandatoryFields =
          (state as UpdateCurrentConsentForm).mandatoryFields;
      final purposes = (state as UpdateCurrentConsentForm).purposes;
      final customFields = (state as UpdateCurrentConsentForm).customFields;

      purposeCategories =
          consentForm.purposeCategories.map((category) => category).toList();
      purposeCategories.add(event.purposeCategory);

      emit(
        UpdateCurrentConsentForm(
          consentForm.copyWith(purposeCategories: purposeCategories),
          mandatoryFields,
          purposes,
          purposeCategories,
          customFields,
        ),
      );
    }
  }
}
