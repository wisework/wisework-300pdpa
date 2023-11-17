// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';

part 'form_data_sub_ject_right_event.dart';
part 'form_data_sub_ject_right_state.dart';

class FormDataSubJectRightBloc
    extends Bloc<FormDataSubJectRightEvent, FormDataSubJectRightState> {
  FormDataSubJectRightBloc({
    required MasterDataRepository masterDataRepository,
  })  : _masterDataRepository = masterDataRepository,
        super(const FormDataSubJectRightInitial()) {
    on<GetFormDataSubJectRightEvent>(_getFormDataSubJectRightHandler);
  }
  final MasterDataRepository _masterDataRepository;

  Future<void> _getFormDataSubJectRightHandler(
    GetFormDataSubJectRightEvent event,
    Emitter<FormDataSubJectRightState> emit,
  ) async {
    if (event.companyId.isEmpty) {
      emit(const FormDataSubJectRightError('Required company ID'));
      return;
    }

    emit(const GettingFormDataSubJectRight());

    final result = await _masterDataRepository.getRequestReasonTemplates(
      event.companyId,
    );

    result.fold(
      (failure) => emit(FormDataSubJectRightError(failure.errorMessage)),
      (requestResons) => emit(
        GotRequestReson(
          requestResons..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      ),
    );
  }
}
