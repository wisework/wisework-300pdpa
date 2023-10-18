import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'data_subject_right_event.dart';
part 'data_subject_right_state.dart';

class DataSubjectRightBloc extends Bloc<DataSubjectRightEvent, DataSubjectRightState> {
  DataSubjectRightBloc() : super(DataSubjectRightInitial()) {
    on<DataSubjectRightEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
