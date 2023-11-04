part of 'search_user_consent_cubit.dart';

class SearchUserConsentState extends Equatable {
  const SearchUserConsentState({
    required this.initialUserConsents,
    required this.userConsents,
  });

  final List<UserConsentModel> initialUserConsents;
  final List<UserConsentModel> userConsents;

  SearchUserConsentState copyWith({
    List<UserConsentModel>? initialUserConsents,
    List<UserConsentModel>? userConsents,
  }) {
    return SearchUserConsentState(
      initialUserConsents: initialUserConsents ?? this.initialUserConsents,
      userConsents: userConsents ?? this.userConsents,
    );
  }

  @override
  List<Object> get props => [initialUserConsents, userConsents];
}
