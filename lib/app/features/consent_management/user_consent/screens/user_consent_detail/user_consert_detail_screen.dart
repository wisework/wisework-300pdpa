import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/widgets/consent_form_preview.dart';
import 'package:pdpa/app/features/consent_management/user_consent/bloc/user_consent_detail/user_consent_detail_bloc.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class UserConsentDetailScreen extends StatefulWidget {
  const UserConsentDetailScreen({
    super.key,
    required this.userConsentId,
  });

  final String userConsentId;

  @override
  State<UserConsentDetailScreen> createState() =>
      _UserConsentDetailScreenState();
}

class _UserConsentDetailScreenState extends State<UserConsentDetailScreen> {
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    } else {
      currentUser = UserModel.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserConsentDetailBloc>(
      create: (context) => serviceLocator<UserConsentDetailBloc>()
        ..add(
          GetUserConsentFormDetailEvent(
            userConsentId: widget.userConsentId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocBuilder<UserConsentDetailBloc, UserConsentDetailState>(
        builder: (context, state) {
          if (state is GotUserConsentDetail) {
            return UserConsentDetailView(
              consentForm: state.consentForm,
              mandatoryFields: state.mandatoryFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
              customFields: state.customFields,
              consentTheme: state.consentTheme,
              userConsent: state.userConsent,
            );
          }
          if (state is UserConsentDetailError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class UserConsentDetailView extends StatefulWidget {
  const UserConsentDetailView({
    super.key,
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.purposes,
    required this.customFields,
    required this.consentTheme,
    required this.userConsent,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final ConsentThemeModel consentTheme;
  final UserConsentModel userConsent;

  @override
  State<UserConsentDetailView> createState() => _UserConsentDetailViewState();
}

class _UserConsentDetailViewState extends State<UserConsentDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icons.chevron_left_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('consentManagement.userConsent.userConsents'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: ConsentFormPreview(
          consentForm: widget.consentForm,
          mandatoryFields: widget.mandatoryFields,
          purposeCategories: widget.purposeCategories,
          purposes: widget.purposes,
          customFields: widget.customFields,
          consentTheme: widget.consentTheme,
          userConsent: widget.userConsent,
          isShowActionButton: false,
          isReadOnly: true,
        ),
      ),
    );
  }
}
