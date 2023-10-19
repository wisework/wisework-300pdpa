import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'current_consent_form_detail_state.dart';

class CurrentConsentFormDetailCubit
    extends Cubit<CurrentConsentFormDetailState> {
  CurrentConsentFormDetailCubit()
      : super(const CurrentConsentFormDetailState(settingTabs: 0));

  void setSettingTab(int tabIndex) {
    emit(state.copyWith(settingTabs: tabIndex));
  }
}
