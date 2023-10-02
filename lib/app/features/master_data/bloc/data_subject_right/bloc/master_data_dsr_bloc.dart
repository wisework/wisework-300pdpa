// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'master_data_dsr_event.dart';
part 'master_data_dsr_state.dart';

class MasterDataDsrBloc extends Bloc<MasterDataDsrEvent, MasterDataDsrState> {
  MasterDataDsrBloc() : super(MasterDataDsrInitial()) {
    on<MasterDataDsrEvent>((event, emit) {
      // implement event handler
    });
  }
}
