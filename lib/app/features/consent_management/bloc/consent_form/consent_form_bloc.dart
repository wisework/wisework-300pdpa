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

    final result = await _consentRepository.getConsentForms(event.companyId);

    result.fold((failure) => emit(ConsentFormError(failure.errorMessage)),
        (consentForms) async {
      emit(
        GotConsentForms(
          consentForms..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
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
        ),
      );
    }
  }
}
