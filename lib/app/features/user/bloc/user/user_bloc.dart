// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const UserInitial()) {
    on<GetUsersEvent>(_getUsersHandler);
  }

  final UserRepository _userRepository;

  Future<void> _getUsersHandler(
    GetUsersEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(const GettingUsers());

    final result = await _userRepository.getUsers();

    result.fold(
      (failure) => emit(UserError(failure.errorMessage)),
      (customfields) => emit(GotUsers(
        customfields..sort((a, b) => b.updatedDate.compareTo(a.updatedDate)),
      )),
    );
  }
}
