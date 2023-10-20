import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/features/master_data/routes/master_data_route.dart';
import 'package:pdpa/app/shared/drawers/bloc/drawer_bloc.dart';
import 'package:pdpa/app/shared/drawers/models/drawer_menu_models.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
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
        .read<ConsentFormBloc>()
        .add(GetConsentFormsEvent(companyId: companyId));
  }

  void _selectMenuDrawer(DrawerMenuModel menu) {
    context.read<DrawerBloc>().add(SelectMenuDrawerEvent(menu: menu));
    context.pushReplacement(menu.route.path);
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
        // actions: [
        //   CustomIconButton(
        //     onPressed: () {},
        //     icon: Ionicons.notifications_outline,
        //     iconColor: Theme.of(context).colorScheme.primary,
        //     backgroundColor: Theme.of(context).colorScheme.onBackground,
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (context, state) {
            if (state is SignedInUser) {
              return Column(
                children: [
                  const SizedBox(
                    height: UiConfig.defaultPaddingSpacing,
                  ),
                  CustomContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildGreetingUser(context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: UiConfig.defaultPaddingSpacing,
                  ),
                  CustomContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildExplore(context),
                        const SizedBox(height: UiConfig.lineSpacing),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: UiConfig.defaultPaddingSpacing,
                  ),
                  CustomContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Recent',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        _buildRecent(context),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: UiConfig.defaultPaddingSpacing,
                  ),
                ],
              );
            }
            return Text(
              tr('general.home.hello'),
              style: Theme.of(context).textTheme.titleMedium,
            );
          },
        ),
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }

  Container _buildRecent(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      child: BlocBuilder<ConsentFormBloc, ConsentFormState>(
        builder: (context, state) {
          if (state is GotConsentForms) {
            return state.consentForms.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.consentForms.length,
                    itemBuilder: (context, index) {
                      return _buildItemCard(
                        context,
                        consentForm: state.consentForms[index],
                        purposeCategory: state.purposeCategories,
                      );
                    },
                  )
                : Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(tr('no data')), //!
                        ],
                      ),
                      const SizedBox(
                        height: UiConfig.defaultPaddingSpacing,
                      ),
                      CustomButton(
                        height: 40.0,
                        onPressed: () {
                          _selectMenuDrawer(
                            DrawerMenuModel(
                              value: 'consent_forms',
                              title: 'Consent Forms',
                              icon: Ionicons.clipboard_outline,
                              route: ConsentFormRoute.consentForm,
                              parent: 'consent_management',
                            ),
                          );
                        },
                        child: Text(
                          tr('create new consent form'),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                        ),
                      )
                    ],
                  );
          }
          if (state is ConsentFormError) {
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
      "Consent Forms",
      "User Consent",
      "Master Data"
    ];
    final List<IconData> icons = [
      Ionicons.clipboard_outline,
      Ionicons.people_outline,
      Ionicons.server_outline,
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
                    Text(
                      'Explore',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                SizedBox(
                  height: 150.0,
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
                              _selectMenuDrawer(
                                DrawerMenuModel(
                                  value: 'consent_forms',
                                  title: 'Consent Forms',
                                  icon: Ionicons.clipboard_outline,
                                  route: ConsentFormRoute.consentForm,
                                  parent: 'consent_management',
                                ),
                              );
                            } else if (currentCardTitle == 'User Consent') {
                              _selectMenuDrawer(
                                DrawerMenuModel(
                                  value: 'user_consents',
                                  title: 'User Consents',
                                  icon: Ionicons.people_outline,
                                  route: UserConsentRoute.userConsentScreen,
                                  parent: 'consent_management',
                                ),
                              );
                            } else if (currentCardTitle == 'Master Data') {
                              _selectMenuDrawer(
                                DrawerMenuModel(
                                  value: 'master_data',
                                  title: 'Master Data',
                                  icon: Ionicons.server_outline,
                                  route: MasterDataRoute.masterData,
                                ),
                              );
                            }
                          },
                          child: Container(
                            // width: 160,
                            // height: 200,
                            // alignment: Alignment.center,
                            // color: Theme.of(context).colorScheme.outline,
                            padding: const EdgeInsets.all(
                                UiConfig.defaultPaddingSpacing),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(
                                      1.0, // Move to right 7.0 horizontally
                                      2.0, // Move to bottom 8.0 Vertically
                                    ))
                              ],
                            ),

                            margin: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  icons[index],
                                  size: 20,
                                ),
                                const SizedBox(height: 20.0),
                                Text(
                                  cardTitles[index],
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
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

  Column _buildItemCard(
    BuildContext context, {
    required ConsentFormModel consentForm,
    required List<PurposeCategoryModel> purposeCategory,
  }) {
    const language = 'en-US';

    final title = consentForm.title
        .firstWhere(
          (item) => item.language == language,
          orElse: () => const LocalizedModel.empty(),
        )
        .text;
    final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
      purposeCategory,
      consentForm.purposeCategories,
    );
    final dateConsentForm =
        DateFormat("dd.MM.yy").format(consentForm.updatedDate);

    // final purposeCategoryFiltered = UtilFunctions.filterPurposeCategoriesByIds(
    //   purposeCategory,
    //   consentForm.purposeCategories,
    // );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MaterialInkWell(
          onTap: () {
            context.push(
              ConsentFormRoute.consentFormDetail.path
                  .replaceFirst(':id', consentForm.id),
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
                      title.isNotEmpty ? title : 'This data is not stored.',
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
                Visibility(
                  visible: purposeCategoryFiltered.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: UiConfig.textLineSpacing,
                    ),
                    child: Text(purposeCategoryFiltered.first.title
                        .firstWhere(
                          (item) => item.language == language,
                          orElse: LocalizedModel.empty,
                        )
                        .text),
                  ),
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
