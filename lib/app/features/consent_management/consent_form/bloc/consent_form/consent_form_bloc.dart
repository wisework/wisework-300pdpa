// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/repositories/consent_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'consent_form_event.dart';
part 'consent_form_state.dart';

class ConsentFormBloc extends Bloc<ConsentFormEvent, ConsentFormState> {
  ConsentFormBloc({
    required ConsentRepository consentRepository,
    required MasterDataRepository masterDataRepository,
  })  : _consentRepository = consentRepository,
        _masterDataRepository = masterDataRepository,
        super(const ConsentFormInitial()) {
    on<GetConsentFormsEvent>(_getConstFormsHandler);
    on<UpdateConsentFormEvent>(_updateConsentFormsEvent);
  }

  final ConsentRepository _consentRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getConstFormsHandler(
    GetConsentFormsEvent event,
    Emitter<ConsentFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const ConsentFormError('Required company ID'));
      return;
    }

    emit(const GettingConsentForms());

    final List<String> allPurposeCategories = [];
    List<PurposeCategoryModel> gotPurposeCategories = [];

    final result = await _consentRepository.getConsentForms(event.companyId);

    await result.fold((failure) {
      emit(ConsentFormError(failure.errorMessage));
      return;
    }, (consentForms) async {
      allPurposeCategories
          .addAll(consentForms.expand((form) => form.purposeCategories));

      for (String purposeCategoryId in allPurposeCategories) {
        final result = await _masterDataRepository.getPurposeCategoryById(
          purposeCategoryId,
          event.companyId,
        );

        result.fold((failure) => emit(ConsentFormError(failure.errorMessage)),
            (purposeCategory) {
          if (!gotPurposeCategories.contains(purposeCategory)) {
            gotPurposeCategories.add(purposeCategory);
          }
        });
      }

      emit(
        GotConsentForms(
            consentForms
              ..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
            gotPurposeCategories
              ..sort((a, b) => b.priority.compareTo(a.priority))),
      );
    });
  }

  Future<void> _updateConsentFormsEvent(
    UpdateConsentFormEvent event,
    Emitter<ConsentFormState> emit,
  ) async {
    if (state is GotConsentForms) {
      final consentForms = (state as GotConsentForms).consentForms;

      List<ConsentFormModel> updated = [];
      List<PurposeCategoryModel> purposeCategories = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = consentForms.map((consentForm) => consentForm).toList()
            ..add(event.consentForm);
          break;
        case UpdateType.updated:
          for (ConsentFormModel consentForm in consentForms) {
            if (consentForm.id == event.consentForm.id) {
              updated.add(event.consentForm);
            } else {
              updated.add(consentForm);
            }
          }
          break;
        case UpdateType.deleted:
          break;
      }

      emit(
        GotConsentForms(
            updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
            purposeCategories
              ..sort((a, b) => b.priority.compareTo(a.priority))),
      );
    }
  }
}
