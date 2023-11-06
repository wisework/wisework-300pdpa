import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/etc/explore_activity.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/bloc/user_consent/user_consent_bloc.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/drawers/bloc/drawer_bloc.dart';
import 'package:pdpa/app/shared/drawers/models/drawer_menu_models.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/utils/user_preferences.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel currentUser;
  late CompanyModel currentCompany;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();

    String companyId = '';
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
      companyId = currentUser.currentCompany;

      final companies = (bloc.state as SignedInUser).companies;
      currentCompany = companies.firstWhere(
        (company) => company.id == companyId,
        orElse: () => CompanyModel.empty(),
      );
    } else {
      currentCompany = CompanyModel.empty();
    }

    final menuSelect = DrawerMenuModel(
      value: 'home',
      title: tr('app.features.home'),
      icon: Ionicons.home_outline,
      route: GeneralRoute.home,
    );
    context.read<DrawerBloc>().add(SelectMenuDrawerEvent(menu: menuSelect));

    context
        .read<UserConsentBloc>()
        .add(GetUserConsentsEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return HomeView(
      currentUser: currentUser,
      currentCompany: currentCompany,
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.currentUser,
    required this.currentCompany,
  });

  final UserModel currentUser;
  final CompanyModel currentCompany;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late UserModel user;
  late CompanyModel company;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    user = widget.currentUser;
    company = widget.currentCompany;

    _checkIsFirstLaunch();
  }

  Future<void> _checkIsFirstLaunch() async {
    final result = await UserPreferences.getBool(
      AppPreferences.isFirstLaunch,
    );

    if (result != null || !(result ?? true)) return;

    _showModalBottomSheet();
  }

  int _getGridItemSize(Size screenSize) {
    if (screenSize.width < 300) {
      return 1;
    } else if (screenSize.width < 500) {
      return 2;
    } else if (screenSize.width < 700) {
      return 3;
    } else {
      return 4;
    }
  }

  void _showModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: _buildModalInfo(context),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
        title: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: SizedBox(
            width: 110.0,
            child: Image.asset(
              'assets/images/general/wisework-logo-mini.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          if (state is SignedInUser) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: UiConfig.lineSpacing + 5),
                    _buildBannerSection(
                      context,
                      screenSize: screenSize,
                    ),
                    const SizedBox(height: UiConfig.lineGap * 2),
                    _buildExploreSection(
                      context,
                      screenSize: screenSize,
                    ),
                    const SizedBox(height: UiConfig.lineGap * 2),
                    _buildRecentlyUsedSection(
                      context,
                      screenSize: screenSize,
                    ),
                    const SizedBox(height: UiConfig.lineSpacing + 5),
                  ],
                ),
              ),
            );
          }
          return const CustomContainer(
            padding: EdgeInsets.symmetric(
              vertical: UiConfig.defaultPaddingSpacing * 4,
            ),
            margin: EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: Center(
              child: LoadingIndicator(),
            ),
          );
        },
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }

  Container _buildModalInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        UiConfig.defaultPaddingSpacing,
      ),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: MaterialInkWell(
              borderRadius: BorderRadius.circular(13.0),
              backgroundColor:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.4),
              onTap: () async {
                await UserPreferences.setBool(
                  AppPreferences.isFirstLaunch,
                  false,
                ).then((_) => Navigator.of(context).pop());
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 2.0,
                  top: 1.0,
                  right: 2.0,
                  bottom: 3.0,
                ),
                child: Icon(
                  Ionicons.close_outline,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              const SizedBox(height: UiConfig.lineGap),
              Text(
                tr('app.disvover.discover'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
          Text(
            tr('app.disvover.description'),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConfig.defaultPaddingSpacing,
            ),
            child: _buildAppMenuInfo(),
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: UiConfig.defaultPaddingSpacing,
            ),
            child: CustomButton(
              height: 45.0,
              onPressed: () {
                GoRouter.of(context).go(GeneralRoute.board.path);
              },
              child: Text(
                tr('app.disvover.seewhatnew'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
        ],
      ),
    );
  }

  Column _buildAppMenuInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: UiConfig.defaultPaddingSpacing,
                bottom: 4.0,
              ),
              child: Icon(
                Ionicons.home_outline,
                size: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              tr('app.features.home'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: UiConfig.defaultPaddingSpacing,
                bottom: 4.0,
              ),
              child: Icon(
                Ionicons.reader_outline,
                size: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              tr('app.features.consentmanagement'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: UiConfig.defaultPaddingSpacing,
                bottom: 4.0,
              ),
              child: Icon(
                Ionicons.server_outline,
                size: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              tr('app.features.masterdata'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: UiConfig.lineGap),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: UiConfig.defaultPaddingSpacing,
                bottom: 4.0,
              ),
              child: Icon(
                Ionicons.settings_outline,
                size: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              tr('app.features.setting'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }

  Padding _buildBannerSection(
    BuildContext context, {
    required Size screenSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UiConfig.defaultPaddingSpacing,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: <Widget>[
            Container(
              width: screenSize.width,
              height: 165.0 + (165.0 * screenSize.width * 0.15),
              constraints: const BoxConstraints(
                maxWidth: UiConfig.maxWidthContent,
                maxHeight: 200.0,
              ),
              color: (Theme.of(context).brightness == Brightness.light)
                  ? const Color(0xFFE2F3FB)
                  : const Color(0xFF171A1F),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: screenSize.width,
                constraints: const BoxConstraints(
                  maxWidth: UiConfig.maxWidthContent,
                  maxHeight: 200.0,
                ),
                child: Image.asset(
                    (Theme.of(context).brightness == Brightness.light)
                        ? 'assets/images/general/city-light.png'
                        : 'assets/images/general/city-dark.png',
                    fit: BoxFit.contain),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
                width: screenSize.width,
                constraints: const BoxConstraints(
                  maxWidth: UiConfig.maxWidthContent,
                  maxHeight: 200.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        tr('general.home.welcome'),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              user.firstName,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(width: 8.0),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Icon(
                                Ionicons.sparkles,
                                color: Theme.of(context).colorScheme.onError,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          company.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildExploreSection(
    BuildContext context, {
    required Size screenSize,
  }) {
    final List<ExploreActivity> activities = [
      ExploreActivity(
        title: tr('app.features.consent'),
        subTitle: tr('app.features.createcsf'),
        icon: Ionicons.add_circle_outline,
        path: ConsentFormRoute.createConsentForm.path,
      ),
      ExploreActivity(
        title: tr('app.features.consent'),
        subTitle: tr('app.features.userconsents'),
        icon: Ionicons.people_outline,
        path: UserConsentRoute.userConsentScreen.path,
      ),
      ExploreActivity(
        title: tr('app.features.consent'),
        subTitle: tr('app.features.consentforms'),
        icon: Ionicons.clipboard_outline,
        path: ConsentFormRoute.consentForm.path,
      ),
      ExploreActivity(
        title: tr('app.features.masterdata'),
        subTitle: tr('masterData.cm.purposeCategory.title'),
        icon: Ionicons.server_outline,
        path: MasterDataRoute.purposesCategories.path,
      ),
    ];

    return Container(
      width: screenSize.width,
      constraints: const BoxConstraints(
        maxWidth: UiConfig.maxWidthContent,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: UiConfig.defaultPaddingSpacing + UiConfig.textSpacing,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('general.home.explore'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          StaggeredGrid.count(
            crossAxisCount: _getGridItemSize(screenSize),
            mainAxisSpacing: UiConfig.defaultPaddingSpacing,
            crossAxisSpacing: UiConfig.defaultPaddingSpacing,
            children: activities.map((activity) {
              return _buildExploreCard(context, activity: activity);
            }).toList(),
          ),
        ],
      ),
    );
  }

  SizedBox _buildExploreCard(
    BuildContext context, {
    required ExploreActivity activity,
  }) {
    return SizedBox(
      width: 159.0,
      child: Flexible(
        child: MaterialInkWell(
          onTap: () {
            if (activity.path == "/user-consents") {
              final DrawerMenuModel menuSelect;
              menuSelect = DrawerMenuModel(
                value: 'user_consents',
                title: tr('app.features.userconsents'),
                icon: Ionicons.people_outline,
                route: UserConsentRoute.userConsentScreen,
                parent: 'consent_management',
              );
              context
                  .read<DrawerBloc>()
                  .add(SelectMenuDrawerEvent(menu: menuSelect));
            }

            if (activity.path == "/consent-form") {
              final DrawerMenuModel menuSelect;
              menuSelect = DrawerMenuModel(
                value: 'consent_forms',
                title: tr('app.features.consentforms'),
                icon: Ionicons.clipboard_outline,
                route: ConsentFormRoute.consentForm,
                parent: 'consent_management',
              );
              context
                  .read<DrawerBloc>()
                  .add(SelectMenuDrawerEvent(menu: menuSelect));
            }

          context.push(activity.path);
        },
        hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        child: Padding(
          padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 7.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Icon(
                    activity.icon,
                    color: Colors.white,
                    size: 18.0,
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildRecentlyUsedSection(
    BuildContext context, {
    required Size screenSize,
  }) {
    return Container(
      width: screenSize.width,
      constraints: const BoxConstraints(
        maxWidth: UiConfig.maxWidthContent,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: UiConfig.defaultPaddingSpacing + UiConfig.textSpacing,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                tr('general.home.recentlyUsed'),
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              BlocBuilder<UserConsentBloc, UserConsentState>(
                builder: (context, state) {
                  if (state is GotUserConsents) {
                    if (state.userConsents.isNotEmpty) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            final userConsentMenu = DrawerMenuModel(
                              value: 'user_consents',
                              title: tr('app.features.userconsents'),
                              icon: Ionicons.people_outline,
                              route: UserConsentRoute.userConsentScreen,
                              parent: 'consent_management',
                            );

                            context.read<DrawerBloc>().add(
                                  SelectMenuDrawerEvent(menu: userConsentMenu),
                                );
                            context.pushReplacement(
                              UserConsentRoute.userConsentScreen.path,
                            );
                          },
                          child: Text(
                            tr('app.features.seeMore'),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Theme.of(context).colorScheme.primary,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            overflow: TextOverflow
                                .clip, // Add this line to handle overflow
                          ),
                        ),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          BlocBuilder<UserConsentBloc, UserConsentState>(
            builder: (context, state) {
              if (state is GotUserConsents) {
                if (state.userConsents.isEmpty) {
                  return _buildResultNotFound(context);
                }
                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: min(3, state.userConsents.length),
                  itemBuilder: (context, index) {
                    return _buildItemCard(
                      context,
                      userConsent: state.userConsents[index],
                      consentForm: state.consentForms.firstWhere(
                        (role) =>
                            role.id == state.userConsents[index].consentFormId,
                        orElse: () => ConsentFormModel.empty(),
                      ),
                      mandatorySelected: state.mandatoryFields.first.id,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: UiConfig.lineSpacing,
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  Column _buildResultNotFound(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: UiConfig.lineSpacing),
        Image.asset(
          'assets/images/general/result-not-found.png',
        ),
        Text(
          tr('app.features.resultNotFound'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing * 2,
          ),
          child: Text(
            tr('app.features.description'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }

  Container _buildItemCard(
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

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.outline,
            blurRadius: 6.0,
            offset: const Offset(0, 4.0),
          ),
        ],
      ),
      child: MaterialInkWell(
        onTap: () {
          context.push(
            UserConsentRoute.userConsentDetail.path
                .replaceFirst(':id', userConsent.id),
          );
        },
        hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
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
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title.isNotEmpty
                                    ? title
                                    : tr('general.home.thisDataIsNotStored'),
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
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
