import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_purpose_category_event.dart';
part 'edit_purpose_category_state.dart';

class EditPurposeCategoryBloc extends Bloc<EditPurposeCategoryEvent, EditPurposeCategoryState> {
  EditPurposeCategoryBloc() : super(EditPurposeCategoryInitial()) {
    on<EditPurposeCategoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
