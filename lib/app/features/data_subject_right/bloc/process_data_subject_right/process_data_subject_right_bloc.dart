// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/repositories/data_subject_right_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'process_data_subject_right_event.dart';
part 'process_data_subject_right_state.dart';

class ProcessDataSubjectRightBloc
    extends Bloc<ProcessDataSubjectRightEvent, ProcessDataSubjectRightState> {
  ProcessDataSubjectRightBloc({
    required DataSubjectRightRepository dataSubjectRightRepository,
    required MasterDataRepository masterDataRepository,
  })  : _dataSubjectRightRepository = dataSubjectRightRepository,
        _masterDataRepository = masterDataRepository,
        super(const ProcessDataSubjectRightInitial()) {
    on<GetProcessDataSubjectRightEvent>(_getProcessDataSubjectRightHandler);
    on<UpdateProcessDataSubjectRightEvent>(
        _updateProcessDataSubjectRightHandler);
  }

  final DataSubjectRightRepository _dataSubjectRightRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _getProcessDataSubjectRightHandler(
    GetProcessDataSubjectRightEvent event,
    Emitter<ProcessDataSubjectRightState> emit,
  ) async {
    if (event.dataSubjectRightId.isEmpty) {
      emit(
        const ProcessDataSubjectRightError('Required data subject right ID'),
      );
      return;
    }
    if (event.companyId.isEmpty) {
      emit(const ProcessDataSubjectRightError('Required company ID'));
      return;
    }

    emit(const GettingProcessDataSubjectRight());

    final result = await _dataSubjectRightRepository.getDataSubjectRightById(
      event.dataSubjectRightId,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(ProcessDataSubjectRightError(failure.errorMessage)),
      (dataSubjectRight) => emit(GotProcessDataSubjectRight(dataSubjectRight)),
    );
  }

  Future<void> _updateProcessDataSubjectRightHandler(
    UpdateProcessDataSubjectRightEvent event,
    Emitter<ProcessDataSubjectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const ProcessDataSubjectRightError('Required company ID'));
      return;
    }

    emit(const UpdatingProcessDataSubjectRight());

    final result = await _dataSubjectRightRepository.updateDataSubjectRight(
      event.dataSubjectRight,
      event.companyId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(ProcessDataSubjectRightError(failure.errorMessage)),
      (_) => emit(UpdatedProcessDataSubjectRight(event.dataSubjectRight)),
    );
  }
}
