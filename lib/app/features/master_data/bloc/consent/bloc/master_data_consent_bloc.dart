import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'master_data_consent_event.dart';
part 'master_data_consent_state.dart';

class MasterDataConsentBloc extends Bloc<MasterDataConsentEvent, MasterDataConsentState> {
  MasterDataConsentBloc() : super(MasterDataConsentInitial()) {
    on<MasterDataConsentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
