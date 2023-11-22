// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';

part 'search_data_subject_right_state.dart';

class SearchDataSubjectRightCubit extends Cubit<SearchDataSubjectRightState> {
  SearchDataSubjectRightCubit()
      : super(const SearchDataSubjectRightState(
          initialDataSubjectRights: [],
          dataSubjectRights: [],
          initialRequesterInputs: [],
          requesterInputs: [],
        ));

  void initialUserConsent(
    List<DataSubjectRightModel> dataSubjectRights,
    List<RequesterInputModel> requesterInputs,
  ) {
    emit(
      state.copyWith(
        initialDataSubjectRights: dataSubjectRights,
        dataSubjectRights: dataSubjectRights,
        initialRequesterInputs: requesterInputs,
        requesterInputs: requesterInputs,
      ),
    );
  }

  void searchDataSubjectRight(String search, String language) {
  }
}
