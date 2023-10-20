// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'setting_cubit.dart';

class SettingState extends Equatable {
  const SettingState({
    required this.localDevice,
    required this.currentUser,
  });

  final String localDevice;
  final UserModel currentUser;

  SettingState copyWith({
    String? localDevice,
    UserModel? currentUser,
  }) {
    return SettingState(
      localDevice: localDevice ?? this.localDevice,
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  List<Object> get props {
    return [
      localDevice,
      currentUser,
    ];
  }
}
