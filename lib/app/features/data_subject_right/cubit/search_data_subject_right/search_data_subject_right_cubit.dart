// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/shared/utils/functions.dart';

part 'search_data_subject_right_state.dart';

class SearchDataSubjectRightCubit extends Cubit<SearchDataSubjectRightState> {
  SearchDataSubjectRightCubit()
      : super(const SearchDataSubjectRightState(
          initialDataSubjectRightForms: [],
          dataSubjectRightForms: [],
          requestTypes: [],
        ));

  void initialDataSubjectRight(
    List<DataSubjectRightModel> dataSubjectRights,
    List<RequestTypeModel> requestTypes,
  ) {
    emit(
      state.copyWith(
        initialDataSubjectRightForms: dataSubjectRights,
        dataSubjectRightForms: dataSubjectRights,
        requestTypes: requestTypes,
      ),
    );
  }

  void searchDataSubjectRight(String search, String language) {
    if (search.isEmpty) {
      emit(state.copyWith(
          dataSubjectRightForms: state.initialDataSubjectRightForms));
      return;
    }
    List<DataSubjectRightModel> searchResult = [];

    searchResult = state.dataSubjectRightForms.where((dataSubjectRight) {
      if (dataSubjectRight.dataRequester.isNotEmpty) {
        final title = dataSubjectRight.dataRequester
            .firstWhere((text) => text.priority == 1)
            .text;

        if (title.contains(search)) return true;
        // for (ProcessRequestModel request in dataSubjectRight.processRequests) {
        //   final title = request.requestType;

        //   final description = state.requestTypes
        //       .firstWhere(
        //         (item) => item.id == title,
        //       )
        //       .description;

        //   final text = description
        //       .firstWhere(
        //         (item) => item.language == language,
        //         orElse: () => const LocalizedModel.empty(),
        //       )
        //       .text;
        //   print(search);
        //   print(text);
        //   if (text.contains(search)) return true;
        // }
      }

      return false;
    }).toList();

    final searchAtRequester =
        state.dataSubjectRightForms.where((dataSubjectRight) {
      // for (DataSubjectRightModel dataSubjectRight
      //     in state.dataSubjectRightForms) {
      //   final title = dataSubjectRight.dataRequester
      //       .firstWhere((text) => text.priority == 1)
      //       .text;

      //   if (title.contains(search)) return true;
      // }
      for (ProcessRequestModel request in dataSubjectRight.processRequests) {
        final title = request.requestType;

        final description = state.requestTypes
            .firstWhere(
              (item) => item.id == title,
            )
            .description;

        final text = description
            .firstWhere(
              (item) => item.language == language,
              orElse: () => const LocalizedModel.empty(),
            )
            .text;
        print(search);
        print(text);
        if (text.contains(search)) return true;
      }
      return false;
    }).toList();

    final currentResultIds =
        searchResult.map((dataSubjectRight) => dataSubjectRight.id).toList();
    for (DataSubjectRightModel dataSubjectRight in searchAtRequester) {
      if (!currentResultIds.contains(dataSubjectRight.id)) {
        searchResult.add(dataSubjectRight);
      }
    }
    print(searchResult);
    print(searchAtRequester);
    emit(
      state.copyWith(
        dataSubjectRightForms: searchResult
          ..sort(((a, b) => b.updatedDate.compareTo(a.updatedDate))),
      ),
    );
  }
}
