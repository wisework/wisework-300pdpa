import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'consent_form_cubit_state.dart';

class ConsentFormCubit extends Cubit<ConsentFormCubitState> {
  ConsentFormCubit()
      : super(const ConsentFormCubitState(
          sort: SortType.desc,
        ));

  void sortConsentFormChange(
    SortType type,
  ) {
    emit(
      state.copyWith(
        sort: type,
      ),
    );
  }
}
