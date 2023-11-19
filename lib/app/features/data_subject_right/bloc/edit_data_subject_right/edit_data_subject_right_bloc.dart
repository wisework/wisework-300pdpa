// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/master_data/reason_type_model.dart';
import 'package:pdpa/app/data/models/master_data/reject_type_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'edit_data_subject_right_event.dart';
part 'edit_data_subject_right_state.dart';

class EditDataSubjectRightBloc
    extends Bloc<EditDataSubjectRightEvent, EditDataSubjectRightState> {
  EditDataSubjectRightBloc({
    required DataSubjectRightRepository dataSubjectRightRepository,
    required MasterDataRepository masterDataRepository,
  })  : _dataSubjectRightRepository = dataSubjectRightRepository,
        _masterDataRepository = masterDataRepository,
        super(const EditDataSubjectRightInitial()) {
    on<GetCurrentDataSubjectRightEvent>(_getCurrentDsrHandler);
    on<CreateCurrentDataSubjectRightEvent>(_createCurrentDsrHandler);
    on<UpdateCurrentDataSubjectRightEvent>(_updateCurrentDsrHandler);
  }

  final DataSubjectRightRepository _dataSubjectRightRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getCurrentDsrHandler(
    GetCurrentDataSubjectRightEvent event,
    Emitter<EditDataSubjectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditDataSubjectRightError('Required company ID'));
      return;
    }

    emit(const GettingCurrentDataSubjectRight());

    final result = await _dataSubjectRightRepository.getDataSubjectRightById(
      event.dataSubjectRightId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    await result.fold((failure) {
      emit(EditDataSubjectRightError(failure.errorMessage));
    }, (dataSubjectRight) async {
      List<RequestTypeModel> gotRequestTypes = [];
      final requestTypeResult = await _masterDataRepository.getRequestTypes(
        event.companyId,
      );
      requestTypeResult.fold(
        (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
        (requestTypes) => gotRequestTypes = requestTypes,
      );

      List<ReasonTypeModel> gotReasonTypes = [];
      final reasonTypeResult = await _masterDataRepository.getReasonTypes(
        event.companyId,
      );
      reasonTypeResult.fold(
        (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
        (reasonTypes) => gotReasonTypes = reasonTypes,
      );

      List<RejectTypeModel> gotRejectTypes = [];
      final rejectTypeResult = await _masterDataRepository.getRejectTypes(
        event.companyId,
      );
      rejectTypeResult.fold(
        (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
        (rejectTypes) => gotRejectTypes = rejectTypes,
      );

      emit(
        GotCurrentDataSubjectRight(
          dataSubjectRight,
          gotRequestTypes,
          gotReasonTypes,
          gotRejectTypes,
        ),
      );
    });
  }

  Future<void> _createCurrentDsrHandler(
    CreateCurrentDataSubjectRightEvent event,
    Emitter<EditDataSubjectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditDataSubjectRightError('Required company ID'));
      return;
    }

    emit(const CreatingCurrentDataSubjectRight());

    final result = await _dataSubjectRightRepository.createDataSubjectRight(
      event.dataSubjectRight,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
      (dataSubjectRight) => emit(
        CreatedCurrentDataSubjectRight(dataSubjectRight),
      ),
    );
  }

  Future<void> _updateCurrentDsrHandler(
    UpdateCurrentDataSubjectRightEvent event,
    Emitter<EditDataSubjectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const EditDataSubjectRightError('Required company ID'));
      return;
    }

    List<RequestTypeModel> requestTypes = [];
    List<ReasonTypeModel> reasonTypes = [];
    List<RejectTypeModel> rejectTypes = [];
    if (state is GotCurrentDataSubjectRight) {
      final settings = state as GotCurrentDataSubjectRight;

      requestTypes = settings.requestTypes;
      reasonTypes = settings.reasonTypes;
      rejectTypes = settings.rejectTypes;
    } else if (state is UpdatedCurrentDataSubjectRight) {
      final settings = state as UpdatedCurrentDataSubjectRight;

      requestTypes = settings.requestTypes;
      reasonTypes = settings.reasonTypes;
      rejectTypes = settings.rejectTypes;
    }

    emit(const UpdatingCurrentDataSubjectRight());

    final result = await _dataSubjectRightRepository.updateDataSubjectRight(
      event.dataSubjectRight,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditDataSubjectRightError(failure.errorMessage)),
      (_) => emit(
        UpdatedCurrentDataSubjectRight(
          event.dataSubjectRight,
          requestTypes,
          reasonTypes,
          rejectTypes,
        ),
      ),
    );
  }
}
