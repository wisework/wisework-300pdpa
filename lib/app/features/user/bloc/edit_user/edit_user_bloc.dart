// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/email_js/signed_up_template_params.dart';
import 'package:pdpa/app/data/models/etc/user_company_role.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/data/presets/mandatory_fields_preset.dart';
import 'package:pdpa/app/data/presets/purpose_categories_preset.dart';
import 'package:pdpa/app/data/presets/purposes_preset.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';
import 'package:pdpa/app/data/repositories/emailjs_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/data/repositories/user_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc({
    required AuthenticationRepository authenticationRepository,
    required MasterDataRepository masterDataRepository,
    required UserRepository userRepository,
    required EmailJsRepository emailJsRepository,
  })  : _authenticationRepository = authenticationRepository,
        _masterDataRepository = masterDataRepository,
        _userRepository = userRepository,
        _emailJsRepository = emailJsRepository,
        super(const EditUserInitial()) {
    on<GetCurrentUserEvent>(_getCurrentUserHandler);
    on<CreateCurrentUserEvent>(_createCurrentUserHandler);
    on<UpdateCurrentUserEvent>(_updateCurrentUserHandler);
    on<DeleteCurrentUserEvent>(_deleteCurrentUserHandler);
  }

  final AuthenticationRepository _authenticationRepository;
  final MasterDataRepository _masterDataRepository;
  final UserRepository _userRepository;
  final EmailJsRepository _emailJsRepository;

  Future<void> _getCurrentUserHandler(
    GetCurrentUserEvent event,
    Emitter<EditUserState> emit,
  ) async {
    final result = await _authenticationRepository.getCurrentUser();

    await result.fold((failure) {
      emit(EditUserError(failure.errorMessage));
    }, (admin) async {
      if (!AppConfig.godIds.contains(admin.id)) {
        emit(const EditUserNoAccess());
      }

      if (event.userId.isEmpty) {
        emit(GotCurrentUser(UserModel.empty(), admin));
        return;
      }

      emit(const GettingCurrentUser());

      final result = await _userRepository.getUserById(
        event.userId,
      );

      await Future.delayed(const Duration(milliseconds: 800));

      result.fold(
        (failure) => emit(EditUserError(failure.errorMessage)),
        (user) => emit(GotCurrentUser(user, admin)),
      );
    });
  }

  Future<void> _createCurrentUserHandler(
    CreateCurrentUserEvent event,
    Emitter<EditUserState> emit,
  ) async {
    emit(const CreatingCurrentUser());

    String newCompanyId = '';
    if (event.companyName.isNotEmpty) {
      final result = await _authenticationRepository.createCompany(
        CompanyModel.empty().copyWith(
          name: event.companyName,
        ),
      );

      await result.fold(
        (failure) {
          emit(EditUserError(failure.errorMessage));
          return;
        },
        (company) async {
          newCompanyId = company.id;

          //? Create Mandatory Fields
          for (MandatoryFieldModel mandatoryField in mandatoryFieldsPreset) {
            final updated = mandatoryField.setCreate(
              event.user.email,
              DateTime.now(),
            );

            final result = await _masterDataRepository.createMandatoryField(
              updated,
              company.id,
            );
            result.fold(
              (failure) {
                emit(EditUserError(failure.errorMessage));
                return;
              },
              (_) {},
            );
          }

          //? Create Purpose Categories
          for (int index = 0; index < purposeCategoriesPreset.length; index++) {
            List<PurposeModel> purposes = [];

            //? Create Purposes
            for (PurposeModel purpose in purposesPreset[index]) {
              final updated = purpose.setCreate(
                event.user.email,
                DateTime.now(),
              );

              final result = await _masterDataRepository.createPurpose(
                updated,
                company.id,
              );
              result.fold(
                (failure) => emit(EditUserError(failure.errorMessage)),
                (purpose) {
                  purposes.add(purpose);
                },
              );
            }

            final updated = purposeCategoriesPreset[index]
                .copyWith(purposes: purposes)
                .setCreate(
                  event.user.email,
                  DateTime.now(),
                );

            final result = await _masterDataRepository.createPurposeCategory(
              updated,
              company.id,
            );
            result.fold(
              (failure) => emit(EditUserError(failure.errorMessage)),
              (_) {},
            );
          }
        },
      );
    }

    final password = UtilFunctions.generatePassword();

    final result = await _authenticationRepository.signUpWithEmailAndPassword(
      event.user.email,
      password,
      user: newCompanyId.isNotEmpty
          ? event.user.copyWith(
              roles: [
                UserCompanyRole(
                  id: newCompanyId,
                  role: UserRoles.owner,
                )
              ],
              companies: [newCompanyId],
              currentCompany: newCompanyId,
            )
          : event.user,
    );

    await Future.delayed(const Duration(milliseconds: 800));

    await result.fold(
      (failure) {
        emit(EditUserError(failure.errorMessage));
      },
      (user) async {
        final params = SignedUpTemplateParams(
          toName: user.firstName,
          toEmail: user.email,
          message: 'Email: ${user.email}\nPassword: $password',
        );

        final result = await _emailJsRepository.sendEmail(
          AppConfig.signedUpTemplateId,
          params.toMap(),
        );

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

    UserModel admin = UserModel.empty();
    if (state is GotCurrentUser) {
      admin = (state as GotCurrentUser).creator;
    } else if (state is UpdatedCurrentUser) {
      admin = (state as UpdatedCurrentUser).creator;
    }

    final result = await _userRepository.updateUser(event.user);

    await Future.delayed(const Duration(milliseconds: 800));

    result.fold(
      (failure) => emit(EditUserError(failure.errorMessage)),
      (_) => emit(UpdatedCurrentUser(event.user, admin)),
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
