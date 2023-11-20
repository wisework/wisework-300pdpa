// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';

part 'form_data_subject_right_state.dart';

class FormDataSubjectRightCubit extends Cubit<FormDataSubjectRightState> {
  FormDataSubjectRightCubit()
      : super(
          FormDataSubjectRightState(
            currentPage: 0,
            dataSubjectRight: DataSubjectRightModel.empty(),
          ),
        );

  void setDataSubjectRight(DataSubjectRightModel dataSubjectRight) {
    emit(state.copyWith(dataSubjectRight: dataSubjectRight));
  }

  void nextPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  void previousPage(int page) {
    emit(state.copyWith(currentPage: page));
  }
}
