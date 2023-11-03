import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_detail/consent_form_detail_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_settings/consent_form_settings_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_detail/current_consent_form_detail_cubit.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_settings/current_consent_form_settings_cubit.dart';
import 'package:pdpa/app/features/consent_management/consent_form/widgets/consent_form_preview.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

import 'tabs/body_tab.dart';
import 'tabs/footer_tab.dart';
import 'tabs/header_tab.dart';
import 'tabs/theme_tab.dart';
import 'tabs/url_tab.dart';

class ConsentFormSettingScreen extends StatefulWidget {
  const ConsentFormSettingScreen({
    super.key,
    required this.consentFormId,
  });

  final String consentFormId;

  @override
  State<ConsentFormSettingScreen> createState() =>
      _ConsentFormSettingScreenState();
}

class _ConsentFormSettingScreenState extends State<ConsentFormSettingScreen> {
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

    _getConsentFormSettings();
  }

  void _getConsentFormSettings() {
    final bloc = context.read<ConsentFormSettingsBloc>();
    bloc.add(GetConsentFormSettingsEvent(
      consentFormId: widget.consentFormId,
      companyId: currentUser.currentCompany,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsentFormSettingsBloc, ConsentFormSettingsState>(
      listener: (context, state) {
        if (state is UpdatedConsentFormSettings) {
          BotToast.showText(
            text: tr(
                'consentManagement.consentForm.consentFormsetting.updateSuccess'),
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
            mandatoryFields: state.mandatoryFields,
            purposeCategories: state.purposeCategories,
            purposes: state.purposes,
            customFields: state.customFields,
            consentThemes: state.consentThemes,
            consentTheme: state.consentTheme,
            currentUser: currentUser,
          );
        }
        if (state is UpdatedConsentFormSettings) {
          return ConsentFormSettingView(
            consentForm: state.consentForm,
            mandatoryFields: state.mandatoryFields,
            purposeCategories: state.purposeCategories,
            purposes: state.purposes,
            customFields: state.customFields,
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
    );
  }
}

class ConsentFormSettingView extends StatefulWidget {
  const ConsentFormSettingView({
    super.key,
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.purposes,
    required this.customFields,
    required this.consentThemes,
    required this.consentTheme,
    required this.currentUser,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
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
      widget.currentUser.currentCompany,
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

    return _buildTabController(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PdpaAppBar(
          leadingIcon: CustomIconButton(
            onPressed: () {
              final event = UpdateConsentFormDetailEvent(
                consentForm: consentForm,
                updateType: UpdateType.updated,
              );

              context.read<ConsentFormDetailBloc>().add(event);

              context
                  .read<CurrentConsentFormDetailCubit>()
                  .setConsentForm(consentForm);

              context
                  .read<CurrentConsentFormDetailCubit>()
                  .setConsentTheme(consentTheme);

              context.pop();
            },
            icon: Icons.chevron_left_outlined,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          title: Text(
            tr('consentManagement.consentForm.consentFormsetting.consentFormSettings'),
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
        endDrawer: _buildPreviewDrawer(
          context,
          consentForm: consentForm,
          consentTheme: consentTheme,
        ),
      ),
    );
  }

  Builder _buildSaveButton(ConsentFormModel consentForm) {
    return Builder(builder: (context) {
      if (consentForm != initialConsentForm) {
        return CustomIconButton(
          onPressed: () {
            final updated = consentForm.setUpdate(
              widget.currentUser.email,
              DateTime.now(),
            );
            final event = UpdateConsentFormSettingsEvent(
              consentForm: updated,
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

  FractionallySizedBox _buildPreviewDrawer(
    BuildContext context, {
    required ConsentFormModel consentForm,
    required ConsentThemeModel consentTheme,
  }) {
    return FractionallySizedBox(
      widthFactor: 0.85,
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        surfaceTintColor: Theme.of(context).colorScheme.onBackground,
        child: SingleChildScrollView(
          child: ConsentFormPreview(
            consentForm: consentForm,
            mandatoryFields: widget.mandatoryFields,
            purposeCategories: widget.purposeCategories,
            purposes: widget.purposes,
            customFields: widget.customFields,
            consentTheme: consentTheme,
          ),
        ),
      ),
    );
  }

  BlocBuilder _buildTabController({
    required Widget child,
  }) {
    return BlocBuilder<CurrentConsentFormSettingsCubit,
        CurrentConsentFormSettingsState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 5,
          initialIndex: state.settingTabs,
          child: child,
        );
      },
    );
  }

  TabBar _buildTabBar(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(text: tr('consentManagement.consentForm.consentFormsetting.url')),
        Tab(
            text:
                tr('consentManagement.consentForm.consentFormsetting.header')),
        Tab(text: tr('consentManagement.consentForm.consentFormsetting.body')),
        Tab(
            text:
                tr('consentManagement.consentForm.consentFormsetting.footer')),
        Tab(text: tr('consentManagement.consentForm.consentFormsetting.theme')),
      ],
      indicatorColor: Theme.of(context).colorScheme.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Theme.of(context).colorScheme.primary,
      labelStyle: Theme.of(context).textTheme.bodySmall,
      onTap: (value) {
        final cubit = context.read<CurrentConsentFormSettingsCubit>();
        cubit.setSettingTab(value);
      },
    );
  }

  TabBarView _buildTabBarView(ConsentFormModel consentForm) {
    return TabBarView(
      children: <Widget>[
        UrlTab(
          consentForm: consentForm,
          companyId: widget.currentUser.currentCompany,
        ),
        HeaderTab(
          consentForm: consentForm,
          companyId: widget.currentUser.currentCompany,
        ),
        BodyTab(
          consentForm: consentForm,
          companyId: widget.currentUser.currentCompany,
        ),
        FooterTab(consentForm: consentForm),
        ThemeTab(consentForm: consentForm, consentThemes: widget.consentThemes),
      ],
    );
  }
}
