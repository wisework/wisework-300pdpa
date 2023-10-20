// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'setting_cubit.dart';

class SettingCubitState extends Equatable {
  const SettingCubitState({
    required this.localDevice,
    required this.currentUser,
  });

  final String localDevice;
  final UserModel currentUser;

  SettingCubitState copyWith({
    String? localDevice,
    UserModel? currentUser,
  }) {
    return SettingCubitState(
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
