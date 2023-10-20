import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/bloc/user_consent/user_consent_bloc.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class UserConsentScreen extends StatefulWidget {
  const UserConsentScreen({super.key});

  @override
  State<UserConsentScreen> createState() => _UserConsentScreenState();
}

class _UserConsentScreenState extends State<UserConsentScreen> {
  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();

    String companyId = '';
    if (bloc.state is SignedInUser) {
      companyId = (bloc.state as SignedInUser).user.currentCompany;
    }

    context
        .read<UserConsentBloc>()
        .add(GetUserConsentsEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return const UserConsentView();
  }
}

class UserConsentView extends StatefulWidget {
  const UserConsentView({super.key});

  @override
  State<UserConsentView> createState() => _UserConsentViewState();
}

class _UserConsentViewState extends State<UserConsentView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Ionicons.menu_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('app.features.userconsents'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: BlocBuilder<UserConsentBloc, UserConsentState>(
                builder: (context, state) {
                  if (state is GotUserConsents) {
                    return state.userConsents.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.userConsents.length,
                            itemBuilder: (context, index) {
                              return _buildItemCard(
                                context,
                                userConsent: state.userConsents[index],
                                consentForm: state.consentForms.firstWhere(
                                  (role) =>
                                      role.id ==
                                      state.userConsents[index].consentFormId,
                                  orElse: () => ConsentFormModel.empty(),
                                ),
                                mandatorySelected:
                                    state.mandatoryFields.first.id,
                              );
                            },
                          )
                        : ExampleScreen(
                            headderText: tr(
                                'consentManagement.userConsent.userConsents'),
                            buttonText:
                                tr('consentManagement.userConsent.createForm.create'),
                            descriptionText:
                                tr('consentManagement.userConsent.createForm.create'),
                           
                            onPress: () {
                              context.push(
                                  ConsentFormRoute.createConsentForm.path);
                            });
                  }
                  if (state is UserConsentError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }

  Column _buildItemCard(
    BuildContext context, {
    required UserConsentModel userConsent,
    required ConsentFormModel consentForm,
    required String mandatorySelected,
  }) {
    final title = userConsent.mandatoryFields
        .firstWhere(
          (mandatoryField) => mandatoryField.id == mandatorySelected,
          orElse: () => const UserInputText.empty(),
        )
        .text;

    final dateConsentForm =
        DateFormat("dd.MM.yy").format(userConsent.updatedDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MaterialInkWell(
          onTap: () {
            context.push(
              UserConsentRoute.userConsentDetail.path
                  .replaceFirst(':id', userConsent.id),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title.isNotEmpty
                                ? title
                                : 'This data is not stored.',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Visibility(
                            visible: consentForm.title.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: UiConfig.textLineSpacing,
                              ),
                              child: Text(
                                consentForm.title.first.text,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Text(
                        dateConsentForm,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing,
          ),
          child: Divider(
            color:
                Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
