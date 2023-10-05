import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_settings/consent_form_settings_bloc.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

import 'tabs/body_tab.dart';
import 'tabs/footer_tab.dart';
import 'tabs/header_tab.dart';
import 'tabs/theme_tab.dart';
import 'tabs/url_tab.dart';
import 'widgets/consent_form_drawer.dart';

class ConsentFormSettingScreen extends StatefulWidget {
  const ConsentFormSettingScreen({super.key});

  @override
  State<ConsentFormSettingScreen> createState() =>
      _ConsentFormSettingScreenState();
}

class _ConsentFormSettingScreenState extends State<ConsentFormSettingScreen> {
  late UserModel currentUser;
  late String consentId;

  @override
  void initState() {
    super.initState();

    _initialData();
    consentId = 'L1qX5GsxWn5u9CCKzNCr';
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
    return BlocProvider<ConsentFormSettingsBloc>(
      create: (context) => serviceLocator<ConsentFormSettingsBloc>()
        ..add(
          GetConsentFormSettingsEvent(
            consentId: consentId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocBuilder<ConsentFormSettingsBloc, ConsentFormSettingsState>(
        builder: (context, state) {
          if (state is GotConsentFormSettings) {
            return ConsentFormSettingView(
              consentForm: state.consentForm,
              customFields: state.customFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposeCategories,
              consentThemes: state.consentThemes,
            );
          }
          if (state is ConsentFormSettingsError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class ConsentFormSettingView extends StatefulWidget {
  const ConsentFormSettingView({
    super.key,
    required this.consentForm,
    required this.customFields,
    required this.purposeCategories,
    required this.purposes,
    required this.consentThemes,
  });

  final ConsentFormModel consentForm;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeCategoryModel> purposes;
  final List<ConsentThemeModel> consentThemes;

  @override
  State<ConsentFormSettingView> createState() => _ConsentFormSettingViewState();
}

class _ConsentFormSettingViewState extends State<ConsentFormSettingView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final consentTheme = ConsentThemeModel(
    id: '',
    title: 'Meow theme',
    headerTextColor: 'ff0a6152',
    headerBackgroundColor: 'ffffffff',
    bodyBackgroundColor: 'ffffffff',
    formTextColor: 'ff0a6152',
    categoryTitleTextColor: 'ff0a6152',
    acceptConsentTextColor: 'ff0a6152',
    linkToPolicyTextColor: 'ff0a6152',
    acceptButtonColor: 'ff0a6152',
    acceptTextColor: 'ffffffff',
    cancelButtonColor: 'ffffffff',
    cancelTextColor: 'ff0a6152',
    actionButtonColor: 'ff0a6152',
    createdBy: 'meow@gmail.com',
    createdDate: DateTime.now(),
    updatedBy: 'meow@gmail.com',
    updatedDate: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        key: _scaffoldKey,
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
            'Consent Form Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            CustomIconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              icon: Ionicons.eye_outline,
              iconColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
            ),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(text: 'URL'),
              Tab(text: 'Header'),
              Tab(text: 'Body'),
              Tab(text: 'Footer'),
              Tab(text: 'Theme'),
            ],
            // isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).colorScheme.primary,
            labelStyle: Theme.of(context).textTheme.bodySmall,
          ),
          appBarHeight: 100.0,
        ),
        body: TabBarView(
          children: <Widget>[
            UrlTab(consentForm: widget.consentForm),
            HeaderTab(consentForm: widget.consentForm),
            BodyTab(
              consentForm: widget.consentForm,
              purposeCategories: widget.purposeCategories,
            ),
            FooterTab(consentForm: widget.consentForm),
            ThemeTab(
              consentForm: widget.consentForm,
              consentThemes: widget.consentThemes,
            ),
          ],
        ),
        endDrawer: const ConsentFormDrawer(),
      ),
    );
  }

  // Column _buildThemeTab() {
  //   return Column(
  //     children: <Widget>[
  //       Text(
  //         'Footer Tab',
  //         style: Theme.of(context).textTheme.bodyMedium,
  //       ),
  //       ElevatedButton(
  //         onPressed: () async {
  //           final purposeCategory = PurposeCategoryModel(
  //             id: '',
  //             title: const [
  //               LocalizedModel(language: 'en-US', text: 'Something'),
  //             ],
  //             description: const [
  //               LocalizedModel(language: 'en-US', text: 'Something like that'),
  //             ],
  //             purposes: const ['cLouEcHLR7AIWfxNtmzs'],
  //             priority: 2,
  //             status: ActiveStatus.active,
  //             createdBy: 'meow@gmail.com',
  //             createdDate: DateTime.now(),
  //             updatedBy: 'meow@gmail.com',
  //             updatedDate: DateTime.now(),
  //           );

  //           final api = MasterDataApi(FirebaseFirestore.instance);
  //           const companyId = 'C7q7rpbkjgLMeROuJQhi';

  //           await api
  //               .createPurposeCategory(purposeCategory, companyId)
  //               .then((value) {
  //             BotToast.showText(text: value.id);
  //           });
  //         },
  //         child: const Text('Add'),
  //       ),
  //       ElevatedButton(
  //         onPressed: () async {
  //           final purposeCategory = PurposeCategoryModel(
  //             id: 'XnOAtOwdZKf7y9keMaL3',
  //             title: const [
  //               LocalizedModel(language: 'en-US', text: 'My field'),
  //             ],
  //             description: const [
  //               LocalizedModel(language: 'en-US', text: 'Enter my field'),
  //             ],
  //             purposes: const [
  //               '5gIaK0L7N8GrX7Nd40FC',
  //               'MGGzjoFrgJHNLeYqTeKv',
  //             ],
  //             priority: 1,
  //             status: ActiveStatus.active,
  //             createdBy: 'meow@gmail.com',
  //             createdDate: DateTime.now(),
  //             updatedBy: 'meow@gmail.com',
  //             updatedDate: DateTime.now(),
  //           );

  //           final api = MasterDataApi(FirebaseFirestore.instance);
  //           const companyId = 'C7q7rpbkjgLMeROuJQhi';

  //           await api
  //               .updatePurposeCategory(purposeCategory, companyId)
  //               .then((_) {
  //             BotToast.showText(text: 'Updated');
  //           });
  //         },
  //         child: const Text('Update'),
  //       ),
  //       ElevatedButton(
  //         onPressed: () async {
  //           final api = MasterDataApi(FirebaseFirestore.instance);
  //           const companyId = 'C7q7rpbkjgLMeROuJQhi';

  //           await api.getPurposeCategories(companyId).then((value) {
  //             print(value);
  //           });
  //         },
  //         child: const Text('Get'),
  //       ),
  //       ElevatedButton(
  //         onPressed: () async {
  //           final api = MasterDataApi(FirebaseFirestore.instance);
  //           const companyId = 'C7q7rpbkjgLMeROuJQhi';

  //           await api
  //               .getPurposeCategoryById('XnOAtOwdZKf7y9keMaL3', companyId)
  //               .then((value) {
  //             print(value);
  //           });
  //         },
  //         child: const Text('Get by ID'),
  //       ),
  //       ElevatedButton(
  //         onPressed: () async {
  //           final api = MasterDataApi(FirebaseFirestore.instance);
  //           const companyId = 'C7q7rpbkjgLMeROuJQhi';

  //           await api
  //               .deletePurposeCategory('pUfTe3pX3EqreOC8f4ly', companyId)
  //               .then((_) {
  //             BotToast.showText(text: 'Deleted');
  //           });
  //         },
  //         child: const Text('Delete by ID'),
  //       ),
  //     ],
  //   );
  // }
}
