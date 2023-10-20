// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(SettingState(
          localDevice: 'en-US',
          currentUser: UserModel.empty(),
        ));

  final AuthenticationRepository _authenticationRepository;

  void setLocalDevice(String localDevice) async {
    // state.currentUser.copyWith(defaultLanguage: state.localDevice);

    // await _authenticationRepository.updateCurrentUser(state.currentUser);
    emit(state.copyWith(localDevice: localDevice));
  }

  // Future<void> _verifyInviteCodeHandler(String localDevice) async {
  //   final updated =
  //       state.currentUser.copyWith(defaultLanguage: state.localDevice);
  //   final result = await _authenticationRepository.updateCurrentUser(
  //     updated,
  //   );

  //   emit(state.copyWith(currentUser: updated));
  //   emit(state.copyWith(localDevice: localDevice));
  // }
}
