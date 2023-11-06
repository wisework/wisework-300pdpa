// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';
import 'package:pdpa/app/data/repositories/user_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        super(const UserInitial()) {
    on<GetUsersEvent>(_getUsersHandler);
    on<UpdateUsersChangedEvent>(_updateUsersChangedHandler);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  Future<void> _getUsersHandler(
    GetUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const GettingUsers());

    final result = await _authenticationRepository.getCurrentUser();

    await result.fold((failure) {
      emit(UserError(failure.errorMessage));
    }, (admin) async {
      if (!AppConfig.godIds.contains(admin.id)) {
        emit(const UserNoAccess());
      }

      final result = await _userRepository.getUsers();

      result.fold(
        (failure) => emit(UserError(failure.errorMessage)),
        (customfields) => emit(GotUsers(
          customfields..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        )),
      );
    });
  }

  Future<void> _updateUsersChangedHandler(
    UpdateUsersChangedEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is GotUsers) {
      final users = (state as GotUsers).users;

      List<UserModel> updated = [];

      switch (event.updateType) {
        case UpdateType.created:
          updated = users.map((user) => user).toList()..add(event.user);
          break;
        case UpdateType.updated:
          updated = users
              .map((user) => user.id == event.user.id ? event.user : user)
              .toList();
          break;
        case UpdateType.deleted:
          updated = users.where((user) => user.id != event.user.id).toList();
          break;
      }

      emit(
        GotUsers(
          updated..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
        ),
      );
    }
  }
}
