// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';

part 'setting_state_cubit.dart';

class SettingCubit extends Cubit<SettingCubitState> {
  SettingCubit({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(SettingCubitState(
          localDevice: 'en-US',
          currentUser: UserModel.empty(),
        ));

  final AuthenticationRepository _authenticationRepository;

  void setLocalDevice(String localDevice) async {
    
    // state.currentUser.copyWith(defaultLanguage: state.localDevice);

    // await _authenticationRepository.updateCurrentUser(state.currentUser);

    emit(state.copyWith(localDevice: localDevice));
  }
}
