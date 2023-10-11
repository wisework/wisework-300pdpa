import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_settings/consent_form_settings_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsentFormSettingsBloc>(
          create: (context) => serviceLocator<ConsentFormSettingsBloc>()
            ..add(
              GetConsentFormSettingsEvent(
                consentId: consentId,
                companyId: currentUser.currentCompany,
              ),
            ),
        ),
        BlocProvider<CurrentConsentFormSettingsCubit>(
          create: (context) => CurrentConsentFormSettingsCubit(),
        ),
      ],
      child: BlocConsumer<ConsentFormSettingsBloc, ConsentFormSettingsState>(
        listener: (context, state) {
          if (state is UpdatedConsentFormSettings) {
            BotToast.showText(
              text: 'Update successfully',
              contentColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              duration: UiConfig.toastDuration,
            );
          }
        },
        builder: (context, state) {
          if (state is GotConsentFormSettings) {
            return ConsentFormSettingView(
              consentForm: state.consentForm,
              customFields: state.customFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
              consentThemes: state.consentThemes,
              consentTheme: state.consentTheme,
              currentUser: currentUser,
            );
          }
          if (state is UpdatedConsentFormSettings) {
            return ConsentFormSettingView(
              consentForm: state.consentForm,
              customFields: state.customFields,
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
              consentThemes: state.consentThemes,
              consentTheme: state.consentTheme,
              currentUser: currentUser,
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
    required this.consentTheme,
    required this.currentUser,
  });

  final ConsentFormModel consentForm;
  final List<CustomFieldModel> customFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<ConsentThemeModel> consentThemes;
  final ConsentThemeModel consentTheme;
  final UserModel currentUser;

  @override
  State<ConsentFormSettingView> createState() => _ConsentFormSettingViewState();
}

class _ConsentFormSettingViewState extends State<ConsentFormSettingView> {
  late ConsentFormModel initialConsentForm;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    initialConsentForm = widget.consentForm;

    final cubit = context.read<CurrentConsentFormSettingsCubit>();
    cubit.initialSettings(
      widget.consentForm,
      widget.consentTheme,
    );
  }

  @override
  Widget build(BuildContext context) {
    final consentForm = context.select(
      (CurrentConsentFormSettingsCubit cubit) => cubit.state.consentForm,
    );
    final consentTheme = context.select(
      (CurrentConsentFormSettingsCubit cubit) => cubit.state.consentTheme,
    );

    return BlocBuilder<CurrentConsentFormSettingsCubit,
        CurrentConsentFormSettingsState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 5,
          initialIndex: state.settingTabs,
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
                _buildSaveButton(consentForm),
              ],
              bottom: _buildTabBar(context),
              appBarHeight: 100.0,
            ),
            body: _buildTabBarView(consentForm),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              child: Icon(
                Ionicons.eye_outline,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            endDrawer: ConsentFormDrawer(
              consentForm: consentForm,
              customFields: widget.customFields,
              purposeCategories: widget.purposeCategories,
              purposes: widget.purposes,
              consentTheme: consentTheme,
            ),
          ),
        );
      },
    );
  }

  Builder _buildSaveButton(ConsentFormModel consentForm) {
    return Builder(builder: (context) {
      if (consentForm != initialConsentForm) {
        return CustomIconButton(
          onPressed: () {
            final event = UpdateConsentFormSettingsEvent(
              consentForm: consentForm,
              companyId: widget.currentUser.currentCompany,
            );

            context.read<ConsentFormSettingsBloc>().add(event);
          },
          icon: Ionicons.save_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        );
      }

      return CustomIconButton(
        icon: Ionicons.save_outline,
        iconColor: Theme.of(context).colorScheme.outlineVariant,
        backgroundColor: Theme.of(context).colorScheme.onBackground,
      );
    });
  }

  TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      tabs: const [
        Tab(text: 'URL'),
        Tab(text: 'Header'),
        Tab(text: 'Body'),
        Tab(text: 'Footer'),
        Tab(text: 'Theme'),
      ],
      indicatorColor: Theme.of(context).colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Theme.of(context).colorScheme.primary,
      labelStyle: Theme.of(context).textTheme.bodySmall,
      onTap: (value) {
        context.read<CurrentConsentFormSettingsCubit>().setSettingTab(value);
      },
    );
  }

  TabBarView _buildTabBarView(ConsentFormModel consentForm) {
    return TabBarView(
      children: <Widget>[
        UrlTab(consentForm: consentForm),
        HeaderTab(consentForm: consentForm),
        BodyTab(consentForm: consentForm),
        FooterTab(consentForm: consentForm),
        ThemeTab(consentForm: consentForm, consentThemes: widget.consentThemes),
      ],
    );
  }
}
