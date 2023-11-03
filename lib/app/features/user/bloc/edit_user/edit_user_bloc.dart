// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/email_template_params.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';
import 'package:pdpa/app/data/repositories/emailjs_repository.dart';
import 'package:pdpa/app/data/repositories/user_repository.dart';
import 'package:pdpa/app/shared/utils/functions.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    required EmailJsRepository emailJsRepository,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        _emailJsRepository = emailJsRepository,
        super(const EditUserInitial()) {
    on<GetCurrentUserEvent>(_getCurrentUserHandler);
    on<CreateCurrentUserEvent>(_createCurrentUserHandler);
    on<UpdateCurrentUserEvent>(_updateCurrentUserHandler);
    on<DeleteCurrentUserEvent>(_deleteCurrentUserHandler);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final EmailJsRepository _emailJsRepository;

  Future<void> _getCurrentUserHandler(
    GetCurrentUserEvent event,
    Emitter<EditUserState> emit,
  ) async {
    if (event.userId.isEmpty) {
      emit(GotCurrentUser(UserModel.empty()));
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

  Future<void> _createCurrentUserHandler(
    CreateCurrentUserEvent event,
    Emitter<EditUserState> emit,
  ) async {
    emit(const CreatingCurrentUser());

    final password = UtilFunctions.generatePassword();

    final result = await _authenticationRepository.signUpWithEmailAndPassword(
      event.user.email,
      password,
      user: event.user,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    await result.fold(
      (failure) {
        emit(EditUserError(failure.errorMessage));
      },
      (user) async {
        final params = EmailTemplateParams(
          toName: user.firstName,
          toEmail: user.email,
          message: 'Email: ${user.email}\nPassword: $password',
        );

        final result = await _emailJsRepository.sendEmail(params);

        result.fold(
          (failure) => emit(EditUserError(failure.errorMessage)),
          (_) => emit(CreatedCurrentUser(user)),
        );
      },
    );
  }

  Future<void> _updateCurrentUserHandler(
    UpdateCurrentUserEvent event,
    Emitter<EditUserState> emit,
  ) async {
    emit(const UpdatingCurrentUser());

    final result = await _userRepository.updateUser(event.user);

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditUserError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentUser(event.user)),
    );
  }

  Future<void> _deleteCurrentUserHandler(
    DeleteCurrentUserEvent event,
    Emitter<EditUserState> emit,
  ) async {
    if (event.userId.isEmpty) return;

    emit(const DeletingCurrentUser());

    final result = await _userRepository.deleteUser(event.userId);

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditUserError(failure.errorMessage)),
      (_) => emit(DeletedurrentUser(event.userId)),
    );
  }
}
