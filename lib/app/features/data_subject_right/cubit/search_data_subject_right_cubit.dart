// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_verification_model.dart';
part 'search_data_subject_right_state.dart';

class SearchDataSubjectRightCubit extends Cubit<SearchDataSubjectRightState> {
  SearchDataSubjectRightCubit()
      : super(const SearchDataSubjectRightState(
          initialdataSubjectRights: [],
          dataSubjectRights: [],
          initialprocessRequests: [],
          processRequests: [],
          initialrequesterInputs: [],
          requesterInputs: [],
          initialrequesterVerifications: [],
          requesterVerifications: [],
        ));
  void initialDataSubjectRight(
    List<DataSubjectRightModel> dataSubjectRights,
    List<ProcessRequestModel> processRequests,
    List<RequesterInputModel> requesterInputs,
    List<RequesterVerificationModel> requesterVerifications,
  ) {
    emit(
      state.copyWith(
        initialdataSubjectRights: dataSubjectRights,
        dataSubjectRights: dataSubjectRights,
        initialprocessRequests: processRequests,
        processRequests: processRequests,
        initialrequesterInputs: requesterInputs,
        requesterInputs: requesterInputs,
        initialrequesterVerifications: requesterVerifications,
        requesterVerifications: requesterVerifications,
      ),
    );
  }
void searchDataSubjectRights(String keyword) {
    List<DataSubjectRightModel> filteredDataSubjectRights =
        state.dataSubjectRights
            .where((dsr) => dsr.dataRequester.contains(keyword))
            .toList();

    List<RequesterInputModel> filteredRequesterInputs =
        state.requesterInputs
            .where((requester) => requester.title.contains(keyword))
            .toList();

    emit(
      state.copyWith(
        dataSubjectRights: filteredDataSubjectRights,
        requesterInputs: filteredRequesterInputs,
      ),
    );
  }

}
