part of 'master_data_consent_bloc.dart';

sealed class MasterDataConsentState extends Equatable {
  const MasterDataConsentState();
  
  @override
  List<Object> get props => [];
}

final class MasterDataConsentInitial extends MasterDataConsentState {}
