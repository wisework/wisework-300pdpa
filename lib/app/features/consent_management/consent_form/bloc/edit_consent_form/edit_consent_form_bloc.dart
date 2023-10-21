// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/etc/user_reorder_item.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

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
    on<UpdatePurposeCategoriesEvent>(_updatePurposeCategoriesHandler);
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

    ConsentFormModel gotConsentForm = ConsentFormModel.empty();
    List<MandatoryFieldModel> gotMandatoryFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<PurposeModel> gotPurposes = [];
    List<CustomFieldModel> gotCustomFields = [];

    if (event.consentFormId.isNotEmpty) {
      final consentFormResult = await _consentRepository.getConsentFormById(
        event.consentFormId,
        event.companyId,
      );
      consentFormResult.fold(
        (failure) => emit(EditConsentFormError(failure.errorMessage)),
        (consentForm) {
          gotConsentForm = consentForm;
        },
      );
    }

    final mandatoryFieldResult = await _masterDataRepository.getMandatoryFields(
      event.companyId,
    );
    mandatoryFieldResult.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (mandatoryField) {
        gotMandatoryFields = mandatoryField;
      },
    );

    final purposeCategoryResult =
        await _masterDataRepository.getPurposeCategories(
      event.companyId,
    );
    purposeCategoryResult.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (purposeCategories) {
        gotPurposeCategories = purposeCategories;
      },
    );

    final purposeResult = await _masterDataRepository.getPurposes(
      event.companyId,
    );
    purposeResult.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (purposes) {
        gotPurposes = purposes;
      },
    );

    final customFieldResult = await _masterDataRepository.getCustomFields(
      event.companyId,
    );
    customFieldResult.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (customFields) {
        gotCustomFields = customFields;
      },
    );

    emit(
      GotCurrentConsentForm(
        gotConsentForm,
        gotMandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
        gotPurposeCategories..sort((a, b) => a.priority.compareTo(b.priority)),
        gotPurposes,
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

    emit(const CreatingCurrentConsentForm());

    const cancelText = [
      LocalizedModel(language: 'en-US', text: 'Cancel'),
    ];
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

    final List<PurposeCategoryModel> purposeCategories = [];

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

    for (UserReorderItem item in event.consentForm.purposeCategories) {
      final result = await _masterDataRepository.getPurposeCategoryById(
        item.id,
        event.companyId,
      );

      result.fold((failure) => emit(EditConsentFormError(failure.errorMessage)),
          (purposeCategory) {
        purposeCategories.add(purposeCategory);
      });
    }

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold((failure) => emit(EditConsentFormError(failure.errorMessage)),
        (consentForm) {
      emit(CreatedCurrentConsentForm(consentForm,
          purposeCategories..sort((a, b) => b.priority.compareTo(a.priority))));
    });
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
    List<PurposeCategoryModel> purposeCategories = [];
    List<PurposeModel> purposes = [];
    List<CustomFieldModel> customFields = [];

    if (state is GotCurrentConsentForm) {
      final settings = state as GotCurrentConsentForm;

      mandatoryFields = settings.mandatoryFields;
      purposeCategories = settings.purposeCategories;
      purposes = settings.purposes;
      customFields = settings.customFields;
    } else if (state is UpdateEditConsentForm) {
      final settings = state as UpdateEditConsentForm;
      mandatoryFields = settings.mandatoryFields;
      purposeCategories = settings.purposeCategories;
      purposes = settings.purposes;
      customFields = settings.customFields;
    }

    emit(const UpdatingEditConsentForm());

    final result = await _consentRepository.updateConsentForm(
      event.consentForm,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditConsentFormError(failure.errorMessage)),
      (_) => emit(
        GotCurrentConsentForm(
          event.consentForm,
          mandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
          purposeCategories..sort((a, b) => a.priority.compareTo(b.priority)),
          purposes,
          customFields,
        ),
      ),
    );
  }

  Future<void> _updatePurposeCategoriesHandler(
    UpdatePurposeCategoriesEvent event,
    Emitter<EditConsentFormState> emit,
  ) async {
    ConsentFormModel consentForm = ConsentFormModel.empty();
    List<MandatoryFieldModel> mandatoryFields = [];

    List<PurposeModel> purposes = [];
    List<CustomFieldModel> customFields = [];

    if (state is GotCurrentConsentForm) {
      final settings = state as GotCurrentConsentForm;

      consentForm = settings.consentForm;
      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      customFields = settings.customFields;
    } else if (state is UpdateEditConsentForm) {
      final settings = state as UpdateEditConsentForm;

      consentForm = settings.consentForm;
      mandatoryFields = settings.mandatoryFields;
      purposes = settings.purposes;
      customFields = settings.customFields;
    }

    List<PurposeCategoryModel> updated = [];

    switch (event.updateType) {
      case UpdateType.created:
      case UpdateType.updated:
        updated = event.purposeCategory;
        break;
      case UpdateType.deleted:
        break;
    }

    emit(
      GotCurrentConsentForm(
        consentForm,
        mandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
        updated..sort((a, b) => b.priority.compareTo(a.priority)),
        purposes,
        customFields,
      ),
    );
  }
}
