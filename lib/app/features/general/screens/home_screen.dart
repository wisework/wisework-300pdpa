
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/user_consent/bloc/user_consent/user_consent_bloc.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        title: SizedBox(
          width: 110.0,
          child: Image.asset(
            'assets/images/wisework-logo-mini.png',
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          CustomIconButton(
            onPressed: () {},
            icon: Ionicons.notifications_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildGreetingUser(context),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildExplore(context),
                  const SizedBox(height: UiConfig.lineSpacing),
                ],
              ),
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: _buildRecentUser(context),
            ),
          ],
        ),
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }

  BlocBuilder _buildGreetingUser(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        if (state is SignedInUser) {
          return Column(
            children: [
              Row(
                children: <Widget>[
                  Text(
                    tr('auth.acceptInvite.hello'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    state.user.firstName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 8.0),
                  Icon(
                    Ionicons.sparkles,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    'The wisework Co.,Ltd.',
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              )
            ],
          );
        }
        return Text(
          tr('general.home.hello'),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }

  BlocBuilder _buildExplore(BuildContext context) {
    final List<String> cardTitles = [
      tr("consentManagement.consentForm.consentForms"),
      tr("consentManagement.userConsent.userConsents"),
      tr("app.features.masterdata")
    ];
    final List<Icon> icons = [
      const Icon(Icons.document_scanner_outlined),
      const Icon(Icons.account_circle_outlined),
      const Icon(Icons.checklist_outlined),
    ];
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        if (state is SignedInUser) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(tr('general.home.explore'),
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: cardTitles.length,
                      itemBuilder: (BuildContext context, int index) {
                        String currentCardTitle = cardTitles[index];
                        return GestureDetector(
                          onTap: () {
                            if (currentCardTitle == 'Consent Forms') {
                              context.pushReplacement('/consent-form');
                            } else if (currentCardTitle == 'User Consent') {
                              context.pushReplacement('/user-consents');
                            } else if (currentCardTitle == 'Master Data') {
                              context.pushReplacement('/master-data');
                            }
                          },
                          child: Card(
                            margin: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 160,
                              height: 200,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  icons[index],
                                  const SizedBox(height: UiConfig.lineSpacing),
                                  Text(
                                    cardTitles[index],
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        }
        return Text(
          tr('general.home.hello'),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }
}

BlocBuilder _buildRecentUser(BuildContext context) {
  return BlocBuilder<SignInBloc, SignInState>(
    builder: (context, state) {
      if (state is SignedInUser) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              tr('general.home.recentlyUsed'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
                      return ListView.builder(
                        itemCount: state.userConsents.length,
                        itemBuilder: (context, index) {
                          return _buildItemCard(
                            context,
                            userConsent: state.userConsents[index],
                            mandatorySelected: state.mandatoryFields.first.id,
                          );
                        },
                      );
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
        );
      }
      return Text(
        tr('general.home.hello'),
        style: Theme.of(context).textTheme.titleMedium,
      );
    },
  );
}

Column _buildItemCard(
  BuildContext context, {
  required UserConsentModel userConsent,
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
                  Text(
                    title.isNotEmpty ? title : tr('general.home.thisDataIsNotStored'),
                    style: Theme.of(context).textTheme.bodyMedium,
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
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
    ],
  );
}
