part of 'master_data_dsr_bloc.dart';

sealed class MasterDataDsrState extends Equatable {
  const MasterDataDsrState();
  
  @override
  List<Object> get props => [];
}

final class MasterDataDsrInitial extends MasterDataDsrState {}
