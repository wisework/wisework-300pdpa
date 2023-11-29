import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/process_request_model.dart';
import 'package:pdpa/app/data/models/etc/explore_activity.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/request_type_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/bloc/user_consent/user_consent_bloc.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/data_subject_right/data_subject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/drawers/bloc/drawer_bloc.dart';
import 'package:pdpa/app/shared/drawers/models/drawer_menu_models.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
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

    context
        .read<DataSubjectRightBloc>()
        .add(GetDataSubjectRightsEvent(companyId: companyId));
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
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: UiConfig.maxWidthContent,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: _buildModalInfo(context),
            ),
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
            height: 40.0,
            child: Image.asset(
              'assets/images/general/dpo_online_mini.png',
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
                    const SizedBox(height: UiConfig.lineGap * 2),
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
                    const SizedBox(height: UiConfig.lineGap * 3),
                    _buildRecentlyDsrSection(
                      context,
                      screenSize: screenSize,
                    ),
                    const SizedBox(height: UiConfig.lineGap * 2),
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
                tr("app.disvover.new"),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineGap * 2),
          Text(
            tr("app.disvover.descriptionNew"),
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
                context.push(GeneralRoute.board.path);
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
                Ionicons.shield_checkmark_outline,
                size: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              tr("dataSubjectRight.manageRequests"),
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
                Ionicons.moon_outline,
                size: 20.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              tr("app.mode"),
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
              height: 80.0,
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
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        tr('general.home.welcome'),
                        style: Theme.of(context).textTheme.headlineMedium,
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
        title: tr('general.exploreActivity.create'),
        icon: Ionicons.add_circle_outline,
        path: ConsentFormRoute.createConsentForm.path,
      ),
      ExploreActivity(
        title: tr('general.exploreActivity.usercs'),
        icon: Ionicons.people_outline,
        path: UserConsentRoute.userConsentScreen.path,
      ),
      ExploreActivity(
        title: tr('general.exploreActivity.csform'),
        icon: Ionicons.clipboard_outline,
        path: ConsentFormRoute.consentForm.path,
      ),
      ExploreActivity(
        title: tr('general.exploreActivity.dsr'),
        icon: Ionicons.shield_checkmark_outline,
        path: DataSubjectRightRoute.dataSubjectRight.path,
      ),
      ExploreActivity(
        title: tr('general.exploreActivity.mtd'),
        icon: Ionicons.server_outline,
        path: MasterDataRoute.masterData.path,
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
      height: 114,
      width: 160.0,
      child: MaterialInkWell(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
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
                  vertical: 5.0,
                  horizontal: 7.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Icon(
                    activity.icon,
                    color: Colors.white,
                    size: 18.0,
                  ),
                ),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Text(
                activity.title,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
              ),
            ],
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
              Expanded(
                child: Text(
                  tr('general.home.recentlyUsed'),
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
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
                                SelectMenuDrawerEvent(menu: userConsentMenu));
                            context.pushReplacement(
                                UserConsentRoute.userConsentScreen.path);
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
                    return _buildUserConsentItemCard(
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
              return const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: UiConfig.defaultPaddingSpacing * 4,
                ),
                child: Center(
                  child: LoadingIndicator(),
                ),
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

  Container _buildUserConsentItemCard(
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
        backgroundColor: Theme.of(context).colorScheme.onBackground,
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
                        Text(
                          title.isNotEmpty ? title : tr('app.disvover.dataNotStored'),
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
    );
  }

  Container _buildRecentlyDsrSection(
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
              Expanded(
                child: Text(
                  tr('app.features.Latest'),
                  style: Theme.of(context).textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              BlocBuilder<UserConsentBloc, UserConsentState>(
                builder: (context, state) {
                  if (state is GotUserConsents) {
                    if (state.userConsents.isNotEmpty) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            final dataSubjectRightMenu = DrawerMenuModel(
                              value: 'data_subject_right',
                              title: tr('app.features.datasubjectright'),
                              icon: Ionicons.shield_checkmark_outline,
                              route: DataSubjectRightRoute.dataSubjectRight,
                            );

                            context.read<DrawerBloc>().add(
                                SelectMenuDrawerEvent(
                                    menu: dataSubjectRightMenu));
                            context.pushReplacement(
                                DataSubjectRightRoute.dataSubjectRight.path);
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
          BlocBuilder<DataSubjectRightBloc, DataSubjectRightState>(
            builder: (context, state) {
              if (state is GotDataSubjectRights) {
                if (state.dataSubjectRights.isEmpty) {
                  return _buildResultNotFound(context);
                }
                final processRequestFiltered =
                    UtilFunctions.filterAllProcessRequest(
                  state.dataSubjectRights,
                  ProcessRequestFilter.all,
                );

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: min(3, state.dataSubjectRights.length),
                  itemBuilder: (context, index) {
                    final entry = processRequestFiltered[index].entries.first;
                    final dataSubjectRight =
                        UtilFunctions.getDataSubjectRightById(
                      state.dataSubjectRights,
                      entry.key,
                    );

                    return _buildDataSubjectRightItemCard(
                      context,
                      dataSubjectRight: dataSubjectRight,
                      processRequest: entry.value,
                      requestTypes: state.requestTypes,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: UiConfig.lineSpacing,
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: UiConfig.defaultPaddingSpacing * 4,
                ),
                child: Center(
                  child: LoadingIndicator(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Container _buildDataSubjectRightItemCard(
    BuildContext context, {
    required DataSubjectRightModel dataSubjectRight,
    required ProcessRequestModel processRequest,
    required List<RequestTypeModel> requestTypes,
  }) {
    final requestType = UtilFunctions.getRequestTypeById(
      requestTypes,
      processRequest.requestType,
    );
    final description = requestType.description.firstWhere(
      (item) => item.language == user.defaultLanguage,
      orElse: () => const LocalizedModel.empty(),
    );

    final requester = dataSubjectRight.dataRequester.first.text;

    final dateConsentForm =
        DateFormat("dd.MM.yy").format(dataSubjectRight.updatedDate);

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
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onTap: () {
          String path = DataSubjectRightRoute.editDataSubjectRight.path;
          path = path.replaceFirst(':id1', dataSubjectRight.id);
          path = path.replaceFirst(':id2', processRequest.id);

          context.push(path);
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
                        Text(
                          description.text,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: UiConfig.textLineSpacing,
                          ),
                          child: Text(
                            requester,
                            style: Theme.of(context).textTheme.bodySmall,
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
