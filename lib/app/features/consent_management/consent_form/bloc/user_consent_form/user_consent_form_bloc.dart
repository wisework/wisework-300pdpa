// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'user_consent_form_event.dart';
part 'user_consent_form_state.dart';

class UserConsentFormBloc
    extends Bloc<UserConsentFormEvent, UserConsentFormState> {
  UserConsentFormBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const UserConsentFormInitial()) {
    on<GetUserConsentFormEvent>(_getUserConsentFormHandler);
    on<SubmitUserConsentFormEvent>(_submitUserConsentFormHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getUserConsentFormHandler(
    GetUserConsentFormEvent event,
    Emitter<UserConsentFormState> emit,
  ) async {
    if (event.consentFormId.isEmpty) {
      emit(const UserConsentFormError('Required consent form ID'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const UserConsentFormError('Required company ID'));
      return;
    }

    emit(const GettingUserConsentForm());

    final emptyConsentForm = ConsentFormModel.empty();
    ConsentFormModel gotConsentForm = emptyConsentForm;
    List<MandatoryFieldModel> gotMandatoryFields = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<PurposeModel> gotPurposes = [];
    List<CustomFieldModel> gotCustomFields = [];
    ConsentThemeModel gotConsentTheme = ConsentThemeModel.initial();

    final consentFormResult = await _consentRepository.getConsentFormById(
      event.consentFormId,
      event.companyId,
    );
    consentFormResult.fold(
      (failure) {
        emit(UserConsentFormError(failure.errorMessage));
        return;
      },
      (consentForm) {
        gotConsentForm = consentForm;
      },
    );

    final mandatoryFieldResult = await _masterDataRepository.getMandatoryFields(
      event.companyId,
    );
    mandatoryFieldResult.fold(
      (failure) {
        emit(UserConsentFormError(failure.errorMessage));
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
        emit(UserConsentFormError(failure.errorMessage));
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
        emit(UserConsentFormError(failure.errorMessage));
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
        emit(UserConsentFormError(failure.errorMessage));
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
          (failure) => emit(UserConsentFormError(failure.errorMessage)),
          (consentThemes) {
            gotConsentTheme = consentThemes;
          },
        );
      }
    }

    emit(
      GotUserConsentForm(
        gotConsentForm,
        gotMandatoryFields..sort((a, b) => a.priority.compareTo(b.priority)),
        gotPurposes,
        gotPurposeCategories,
        gotCustomFields,
        gotConsentTheme,
      ),
    );
  }

  Future<void> _submitUserConsentFormHandler(
    SubmitUserConsentFormEvent event,
    Emitter<UserConsentFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const UserConsentFormError('Required company ID'));
      return;
    }

    emit(const SubmittingUserConsentForm());

    final result = await _consentRepository.createUserConsent(
      event.userConsent,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(UserConsentFormError(failure.errorMessage)),
      (userConsent) => emit(
        SubmittedUserConsentForm(
          userConsent,
          event.consentForm,
        ),
      ),
    );
  }
}
