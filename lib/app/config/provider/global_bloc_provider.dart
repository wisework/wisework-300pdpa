import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_settings/consent_form_settings_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/user_consent_form/user_consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/custom_field/custom_field_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose_category/purpose_category_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reason_type/reason_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/reject_type/reject_type_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_reason_tp/request_reason_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_reject_tp/request_reject_tp_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/data_subject_right/request_type/request_type_bloc.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/drawers/bloc/drawer_bloc.dart';
import 'package:pdpa/app/shared/drawers/drawer_menu.dart';

class GlobalBlocProvider {
  static List<BlocProvider> get providers {
    return [
      BlocProvider<SignInBloc>(
        create: (context) => serviceLocator<SignInBloc>(),
      ),
      BlocProvider<DrawerBloc>(
        create: (context) => serviceLocator<DrawerBloc>()
          ..add(SelectMenuDrawerEvent(menu: drawerMenu.first)),
      ),
      BlocProvider<ConsentFormSettingsBloc>(
        create: (context) => serviceLocator<ConsentFormSettingsBloc>(),
      ),
      BlocProvider<CurrentConsentFormSettingsCubit>(
        create: (context) => serviceLocator<CurrentConsentFormSettingsCubit>(),
      ),
      BlocProvider<UserConsentFormBloc>(
        create: (context) => serviceLocator<UserConsentFormBloc>(),
      ),
      BlocProvider<PurposeBloc>(
        create: (context) => serviceLocator<PurposeBloc>(),
      ),
      BlocProvider<CustomFieldBloc>(
        create: (context) => serviceLocator<CustomFieldBloc>(),
      ),
      BlocProvider<PurposeCategoryBloc>(
        create: (context) => serviceLocator<PurposeCategoryBloc>(),
      ),
      BlocProvider<RequestTypeBloc>(
        create: (context) => serviceLocator<RequestTypeBloc>(),
      ),
      BlocProvider<RejectTypeBloc>(
        create: (context) => serviceLocator<RejectTypeBloc>(),
      ),
      BlocProvider<ReasonTypeBloc>(
        create: (context) => serviceLocator<ReasonTypeBloc>(),
      ),
      BlocProvider<RequestReasonTpBloc>(
        create: (context) => serviceLocator<RequestReasonTpBloc>(),
      ),
      BlocProvider<RequestRejectTpBloc>(
        create: (context) => serviceLocator<RequestRejectTpBloc>(),
      ),
    ];
  }
}
