// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
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

    List<CustomFieldModel> gotCustomFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<PurposeModel> gotPurposes = [];

    final resultCustomfield = await _masterDataRepository.getCustomFields(
      event.companyId,
    );
    resultCustomfield
        .fold((failure) => emit(EditConsentFormError(failure.errorMessage)),
            (customField) {
      gotCustomFields = customField;
    });

    if (event.consentFormId.isEmpty) {
      emit(
        GotCurrentConsentForm(
          ConsentFormModel.empty(),
          gotCustomFields,
          const [],
          const [],
        ),
      );
      return;
    }

    final result = await _consentRepository.getConsentFormById(
      event.consentFormId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    await result.fold(
      (failure) {
        emit(EditConsentFormError(failure.errorMessage));
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
              (failure) => emit(EditConsentFormError(failure.errorMessage)),
              (customField) {
            if (!gotCustomFields.contains(customField)) {
              gotCustomFields.add(customField);
            }
          });
        }

        for (String purposeCategoryId in consentForm.purposeCategories) {
          final result = await _masterDataRepository.getPurposeCategoryById(
            purposeCategoryId,
            event.companyId,
          );

          await result.fold(
            (failure) {
              emit(EditConsentFormError(failure.errorMessage));
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
                    EditConsentFormError(failure.errorMessage),
                  ),
                  (purpose) => gotPurposes.add(purpose),
                );
              }
            },
          );
        }
      },
    );

    emit(
      GotCurrentConsentForm(
        gotConsentForm,
        gotCustomFields,
        gotPurposeCategories..sort((a, b) => b.priority.compareTo(a.priority)),
        gotPurposes,
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

    final ConsentFormModel consentForm;

    List<LocalizedModel> acceptConsentText = [
      const LocalizedModel(language: 'en-US', text: 'Accept consent')
    ];
    List<LocalizedModel> cancelText = [
      const LocalizedModel(language: 'en-US', text: 'Cancel')
    ];
    List<LocalizedModel> footerDescription = [
      const LocalizedModel(language: 'en-US', text: '')
    ];
    List<LocalizedModel> headerDescription = [
      const LocalizedModel(language: 'en-US', text: '')
    ];
    List<LocalizedModel> headerText = [
      const LocalizedModel(language: 'en-US', text: 'Header')
    ];
    List<LocalizedModel> linkToPolicyText = [
      const LocalizedModel(language: 'en-US', text: 'Link to policy')
    ];
    List<LocalizedModel> submitText = [
      const LocalizedModel(language: 'en-US', text: 'Submit')
    ];

    consentForm = ConsentFormModel(
      id: event.consentForm.id,
      title: event.consentForm.title,
      description: event.consentForm.description,
      purposeCategories: event.consentForm.purposeCategories,
      customFields: event.consentForm.customFields,
      headerText: headerText,
      headerDescription: headerDescription,
      footerDescription: footerDescription,
      acceptConsentText: acceptConsentText,
      submitText: submitText,
      cancelText: cancelText,
      linkToPolicyText: linkToPolicyText,
      linkToPolicyUrl: event.consentForm.linkToPolicyUrl,
      consentFormUrl: event.consentForm.consentFormUrl,
      consentThemeId: event.consentForm.consentThemeId,
      logoImage: event.consentForm.logoImage,
      headerBackgroundImage: event.consentForm.headerBackgroundImage,
      bodyBackgroundImage: event.consentForm.bodyBackgroundImage,
      status: event.consentForm.status,
      createdBy: event.consentForm.createdBy,
      createdDate: event.consentForm.createdDate,
      updatedBy: event.consentForm.updatedBy,
      updatedDate: event.consentForm.updatedDate,
    );

    final result = await _consentRepository.createConsentForm(
      consentForm,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold((failure) => emit(EditConsentFormError(failure.errorMessage)),
        (consentForm) {
      emit(CreatedCurrentConsentForm(consentForm));
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

    emit(const UpdatingCurrentConsentForm());

    final result = await _consentRepository.updateConsentForm(
      event.consentForm,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    // result.fold(
    //   (failure) => emit(EditConsentFormError(failure.errorMessage)),
    //   (_) => emit(UpdatedCurrentConsentForm(event.consentForm)),
    // );
  }
}
