// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'user_data_subject_right_form_event.dart';
part 'user_data_subject_right_form_state.dart';

class UserDataSubjectRightFormBloc
    extends Bloc<UserDataSubjectRightFormEvent, UserDataSubjectRightFormState> {
  UserDataSubjectRightFormBloc(
      {required DataSubjectRightRepository dataSubjectRightRepository,
      required MasterDataRepository masterDataRepository})
      : _dataSubjectRightRepository = dataSubjectRightRepository,
        _masterDataRepository = masterDataRepository,
        super(const UserDataSubjectRightFormInitial()) {
    on<GetUserDataSubjectRightFormEvent>(_getUserDataSubjectRightFormHandler);
    // on<SubmitUserDataSubjectRightFormEvent>(
    //     _submitUserDataSubjectRightFormHandler);
  }

  final DataSubjectRightRepository _dataSubjectRightRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getUserDataSubjectRightFormHandler(
    GetUserDataSubjectRightFormEvent event,
    Emitter<UserDataSubjectRightFormState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const UserDataSubjectRightFormError('Required company ID'));
      return;
    }

    emit(const GettingUserDataSubjectRightForm());

    List<MandatoryFieldModel> gotMandatoryFields = [];
    // List<RequestTypeModel> gotRequestTypes = [];
    // List<ReasonTypeModel> gotReasonTypes = [];
    // List<RejectTypeModel> gotRejectTypes = [];
    // List<RequestReasonTemplateModel> gotRequestReasonTemplates = [];
    // List<RequestRejectTemplateModel> gotRequestRejectTemplates = [];

    final mandatoryResult = await _masterDataRepository.getMandatoryFields(
      event.companyId,
    );
    mandatoryResult.fold(
      (failure) => emit(UserDataSubjectRightFormError(failure.errorMessage)),
      (mandatoryFields) => gotMandatoryFields = mandatoryFields,
    );

    // Try to get DSR
    await _dataSubjectRightRepository.getDataSubjectRights(event.companyId);

    // final requestResult = await _masterDataRepository.getRequestTypes(
    //   event.companyId,
    // );
    // requestResult.fold(
    //   (failure) => emit(UserDataSubjectRightFormError(failure.errorMessage)),
    //   (requestTypes) => gotRequestTypes = requestTypes,
    // );

    await Future.delayed(const Duration(milliseconds: 800));
    // print(gotMandatoryFields);

    emit(GotUserDataSubjectRightForm(gotMandatoryFields));
  }
}
