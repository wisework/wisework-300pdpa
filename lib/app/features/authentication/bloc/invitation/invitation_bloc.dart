// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/repositories/authentication_repository.dart';
import 'package:pdpa/app/shared/utils/constants.dart';

part 'invitation_event.dart';
part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  InvitationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const InvitationInitial()) {
    on<VerifyInviteCodeEvent>(_verifyInviteCodeHandler);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _verifyInviteCodeHandler(
    VerifyInviteCodeEvent event,
    Emitter<InvitationState> emit,
  ) async {
    if (event.user == UserModel.empty()) {
      emit(const InvitationError('Unauthorized'));
      return;
    }

    emit(const VerifyingInviteCode());

    List<CompanyModel> companies = event.companies;
    final result = await _authenticationRepository.getCompanyById(
      event.inviteCode,
    );

    await result.fold(
      (failure) {
        emit(InvitationError(failure.errorMessage));
        return;
      },
      (company) async {
        List<String> companyIds = event.user.companies.map((id) => id).toList();
        if (!companyIds.contains(event.inviteCode)) {
          companyIds.add(event.inviteCode);
          companies.add(company);
        }

        final updated = event.user.copyWith(
          role: UserRoles.editor,
          companies: companyIds,
          currentCompany: event.inviteCode,
        );

        final result = await _authenticationRepository.updateCurrentUser(
          updated,
        );

        result.fold(
          (failure) => emit(InvitationError(failure.errorMessage)),
          (user) => emit(AcceptedInvitation(user, companies)),
        );
      },
    );
  }
}
