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

part 'user_consent_detail_event.dart';
part 'user_consent_detail_state.dart';

class UserConsentDetailBloc
    extends Bloc<UserConsentDetailEvent, UserConsentDetailState> {
  UserConsentDetailBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const UserConsentDetailInitial()) {
    on<GetUserConsentFormDetailEvent>(_getUserConsentFormDetailHandler);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getUserConsentFormDetailHandler(
    GetUserConsentFormDetailEvent event,
    Emitter<UserConsentDetailState> emit,
  ) async {
    if (event.userConsentId.isEmpty) {
      emit(const UserConsentDetailError('Required user consent ID'));
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const UserConsentDetailError('Required company ID'));
      return;
    }

    emit(const GettingUserConsentDetail());

    final emptyUserConsent = UserConsentModel.empty();
    final emptyConsentForm = ConsentFormModel.empty();

    UserConsentModel gotUserConsent = emptyUserConsent;
    ConsentFormModel gotConsentForm = emptyConsentForm;
    List<MandatoryFieldModel> gotMandatoryFields = [];
    List<PurposeModel> gotPurposes = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];
    List<CustomFieldModel> gotCustomFields = [];
    ConsentThemeModel gotConsentTheme = ConsentThemeModel.initial();

    final userConsentResult = await _consentRepository.getUserConsentById(
      event.userConsentId,
      event.companyId,
    );
    userConsentResult.fold(
      (failure) {
        emit(UserConsentDetailError(failure.errorMessage));
        return;
      },
      (userConsent) {
        gotUserConsent = userConsent;
      },
    );

    if (gotUserConsent.consentFormId.isNotEmpty) {
      final consentFormResult = await _consentRepository.getConsentFormById(
        gotUserConsent.consentFormId,
        event.companyId,
      );
      consentFormResult.fold(
        (failure) {
          emit(UserConsentDetailError(failure.errorMessage));
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
        emit(UserConsentDetailError(failure.errorMessage));
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
        emit(UserConsentDetailError(failure.errorMessage));
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
        emit(UserConsentDetailError(failure.errorMessage));
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
        emit(UserConsentDetailError(failure.errorMessage));
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
          (failure) => emit(UserConsentDetailError(failure.errorMessage)),
          (consentThemes) {
            gotConsentTheme = consentThemes;
          },
        );
      }
    }

    emit(
      GotUserConsentDetail(
        gotUserConsent,
        gotConsentForm,
        gotMandatoryFields,
        gotPurposes,
        gotPurposeCategories,
        gotCustomFields,
        gotConsentTheme,
      ),
    );
  }
}
