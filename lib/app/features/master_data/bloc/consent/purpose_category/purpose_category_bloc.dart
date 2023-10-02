// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'purpose_category_event.dart';
part 'purpose_category_state.dart';

class PurposeCategoryBloc
    extends Bloc<PurposeCategoryEvent, PurposeCategoryState> {
  PurposeCategoryBloc() : super(PurposeCategoryInitial()) {
    on<PurposeCategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
