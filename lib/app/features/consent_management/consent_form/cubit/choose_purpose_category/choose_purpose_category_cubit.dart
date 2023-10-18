import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';

part 'choose_purpose_category_state.dart';

class ChoosePurposeCategoryCubit
    extends Cubit<ChoosePurposeCategoryCubitState> {
  ChoosePurposeCategoryCubit()
      : super(const ChoosePurposeCategoryCubitState(
          expandId: '',
          purposeCategorySelected: [],
          customFieldSelected: [],
        ));

  void choosePurposeCategoryExpanded(String purposeCategoryId) {
    if (purposeCategoryId == state.expandId) {
      emit(state.copyWith(expandId: ""));
    } else {
      emit(state.copyWith(expandId: purposeCategoryId));
    }
  }

  void choosePurposeCategorySelected(PurposeCategoryModel purposeCategory) {
    final templateSelected =
        state.purposeCategorySelected.map((template) => template).toList();
    if (templateSelected.contains(purposeCategory)) {
      templateSelected.remove(purposeCategory);
      emit(state.copyWith(purposeCategorySelected: templateSelected));
    } else {
      templateSelected.add(purposeCategory);
      emit(state.copyWith(purposeCategorySelected: templateSelected));
    }
  }

  void customFieldSelected(CustomFieldModel customFieldModel) {
    final customFieldSelected =
        state.customFieldSelected.map((template) => template).toList();
    if (customFieldSelected.contains(customFieldModel)) {
      customFieldSelected.remove(customFieldModel);
      emit(state.copyWith(customFieldSelected: customFieldSelected));
    } else {
      customFieldSelected.add(customFieldModel);
      emit(state.copyWith(customFieldSelected: customFieldSelected));
    }
  }
}
