// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';

part 'purpose_category_state.dart';

class PurposeCategoryCubit extends Cubit<PurposeCategoryState> {
  PurposeCategoryCubit()
      : super(const PurposeCategoryState(
          purposes: [],
          purposeList: [],
        ));

  Future<void> initialPurposelist(List<PurposeModel> purposes,
      PurposeCategoryModel purposeCategoryModel) async {
    final purposeList = purposes
        .where((id) => purposeCategoryModel.purposes.contains(id))
        .toList();
    state.copyWith(purposeList: purposeList);

    state.copyWith(
        purposes: purposeCategoryModel.purposes
            .map((purpose) => purpose.id)
            .toList());

    emit(state.copyWith(
        purposes: purposeCategoryModel.purposes
            .map((purpose) => purpose.id)
            .toList()));

    emit(state.copyWith(purposeList: purposeList));
  }

  void choosePurposeCategorySelected(String purposeCategory) {
    final templateSelected =
        state.purposes.map((template) => template).toList();
    if (templateSelected.contains(purposeCategory)) {
      templateSelected.remove(purposeCategory);
      emit(state.copyWith(purposes: templateSelected));
    } else {
      templateSelected.add(purposeCategory);
      emit(state.copyWith(purposes: templateSelected));
    }
  }

  void removePurpose(String purpose) {
    final templateSelected =
        state.purposes.map((template) => template).toList();

    if (templateSelected.contains(purpose)) {
      templateSelected.remove(purpose);
      emit(state.copyWith(purposes: templateSelected));
    }
  }
}
