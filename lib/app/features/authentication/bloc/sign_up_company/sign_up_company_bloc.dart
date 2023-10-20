// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/user_company_role.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';
import 'package:pdpa/app/data/repositories/master_data_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'sign_up_company_event.dart';
part 'sign_up_company_state.dart';

class SignUpCompanyBloc extends Bloc<SignUpCompanyEvent, SignUpCompanyState> {
  SignUpCompanyBloc({
    required AuthenticationRepository authenticationRepository,
    required MasterDataRepository masterDataRepository,
  })  : _authenticationRepository = authenticationRepository,
        _masterDataRepository = masterDataRepository,
        super(const SignUpCompanyInitial()) {
    on<SubmitCompanySettingsEvent>(_submitCompanySettingsHandler);
  }

  final AuthenticationRepository _authenticationRepository;
  final MasterDataRepository _masterDataRepository;

  Future<void> _submitCompanySettingsHandler(
    SubmitCompanySettingsEvent event,
    Emitter<SignUpCompanyState> emit,
  ) async {
    emit(const SigningUpCompany());

    final result = await _authenticationRepository.createCompany(event.company);

    await result.fold(
      (failure) {
        emit(SignUpCompanyError(failure.errorMessage));
        return;
      },
      (company) async {
        for (MandatoryFieldModel mandatoryField in event.mandatoryFields) {
          final result = await _masterDataRepository.createMandatoryField(
            mandatoryField,
            company.id,
          );
          result.fold(
            (failure) {
              emit(SignUpCompanyError(failure.errorMessage));
              return;
            },
            (_) {},
          );
        }

        final updated = event.user.copyWith(
          roles: event.user.roles.map((role) => role).toList()
            ..add(UserCompanyRole(id: company.id, role: UserRoles.owner)),
          companies: event.user.companies.map((id) => id).toList()
            ..add(company.id),
          currentCompany: company.id,
        );

        final result = await _authenticationRepository.updateCurrentUser(
          updated,
        );

        await result.fold(
          (failure) {
            emit(SignUpCompanyError(failure.errorMessage));
            return;
          },
          (user) async {
            List<CompanyModel> companies = [];

            for (String id in user.companies) {
              final result = await _authenticationRepository.getCompanyById(id);
              result.fold(
                (failure) => emit(SignUpCompanyError(failure.errorMessage)),
                (company) => companies.add(company),
              );
            }

            emit(SignedUpCompany(user, companies));
          },
        );
      },
    );
  }
}
