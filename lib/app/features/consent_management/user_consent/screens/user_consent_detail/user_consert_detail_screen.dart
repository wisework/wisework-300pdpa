import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/user_consent/bloc/user_consent_detail/user_consent_detail_bloc.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DetailUserConsentScreen extends StatefulWidget {
  const DetailUserConsentScreen({
    super.key,
    required this.userConsentId,
  });

  final String userConsentId;

  @override
  State<DetailUserConsentScreen> createState() =>
      _DetailUserConsentScreenState();
}

class _DetailUserConsentScreenState extends State<DetailUserConsentScreen> {
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
          GetUserConsentFormEvent(
            consentFormId: widget.userConsentId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocBuilder<UserConsentDetailBloc, UserConsentDetailState>(
        builder: (context, state) {
          if (state is GotUserConsentDetail) {
            return DetailUserConsentView(
              userConsent: state.userConsent,
              customFields: state.customFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
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

class DetailUserConsentView extends StatefulWidget {
  const DetailUserConsentView({
    super.key,
    required this.userConsent,
    required this.customFields,
    required this.purposeCategories,
    required this.purposes,
  });

  final UserConsentModel userConsent;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;

  @override
  State<DetailUserConsentView> createState() => _DetailUserConsentViewState();
}

class _DetailUserConsentViewState extends State<DetailUserConsentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Ionicons.chevron_back_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('consentManagement.userConsent.userConsents'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        widget.userConsent.consentFormId,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.5),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                ],
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }
}
