// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'current_consent_form_detail_cubit.dart';

class CurrentConsentFormDetailState extends Equatable {
  const CurrentConsentFormDetailState({
    required this.settingTabs,
  });

  final int settingTabs;

  CurrentConsentFormDetailState copyWith({
    int? settingTabs,
  }) {
    return CurrentConsentFormDetailState(
      settingTabs: settingTabs ?? this.settingTabs,
    );
  }

  @override
  List<Object> get props => [
        settingTabs,
      ];
}
