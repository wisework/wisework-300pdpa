// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/repositories/user_repository.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const EditUserInitial()) {
    on<GetCurrentUserEvent>(_getCurrentUserHandler);
  }

  final UserRepository _userRepository;

  Future<void> _getCurrentUserHandler(
    GetCurrentUserEvent event,
    Emitter<EditUserState> emit,
  ) async {
    if (event.userId.isEmpty) {
      emit(const EditUserError('Required user ID'));
      return;
    }

    emit(const GettingCurrentUser());

    final result = await _userRepository.getUserById(
      event.userId,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditUserError(failure.errorMessage)),
      (purpose) => emit(GotCurrentUser(purpose)),
    );
  }
}
