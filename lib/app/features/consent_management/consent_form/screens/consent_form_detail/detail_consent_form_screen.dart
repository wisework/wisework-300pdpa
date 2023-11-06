import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_theme_model.dart';
import 'package:pdpa/app/data/models/master_data/custom_field_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form_detail/consent_form_detail_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/current_consent_form_detail/current_consent_form_detail_cubit.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_detail/tabs/consent_form_tab.dart';
import 'package:pdpa/app/features/consent_management/consent_form/screens/consent_form_detail/tabs/consent_info_tab.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DetailConsentFormScreen extends StatefulWidget {
  const DetailConsentFormScreen({
    super.key,
    required this.consentFormId,
  });

  final String consentFormId;

  @override
  State<DetailConsentFormScreen> createState() =>
      _DetailConsentFormScreenState();
}

class _DetailConsentFormScreenState extends State<DetailConsentFormScreen> {
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

    _getConsentFormDetails();
  }

  void _getConsentFormDetails() {
    final bloc = context.read<ConsentFormDetailBloc>();
    bloc.add(
      GetConsentFormDetailEvent(
        consentFormId: widget.consentFormId,
        companyId: currentUser.currentCompany,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsentFormDetailBloc, ConsentFormDetailState>(
      listener: (context, state) {
        if (state is GotConsentFormDetail) {
          final cubit = context.read<CurrentConsentFormDetailCubit>();
          cubit.setConsentTheme(
            state.consentTheme,
          );
        }
      },
      builder: (context, state) {
        if (state is GotConsentFormDetail) {
          return ConsentFormDetailView(
            consentForm: state.consentForm,
            mandatoryFields: state.mandatoryFields,
            purposeCategories: state.purposeCategories,
            purposes: state.purposes,
            customFields: state.customFields,
            consentTheme: state.consentTheme,
            language: currentUser.defaultLanguage,
          );
        }
        if (state is ConsentFormDetailError) {
          return ErrorMessageScreen(message: state.message);
        }

        return const LoadingScreen();
      },
    );
  }
}

class ConsentFormDetailView extends StatefulWidget {
  const ConsentFormDetailView({
    super.key,
    required this.consentForm,
    required this.mandatoryFields,
    required this.purposeCategories,
    required this.purposes,
    required this.customFields,
    required this.consentTheme,
    required this.language,
  });

  final ConsentFormModel consentForm;
  final List<MandatoryFieldModel> mandatoryFields;
  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;
  final List<CustomFieldModel> customFields;
  final ConsentThemeModel consentTheme;
  final String language;

  @override
  State<ConsentFormDetailView> createState() => _ConsentFormDetailViewState();
}

class _ConsentFormDetailViewState extends State<ConsentFormDetailView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int tabIndex = 0;

  void _setTabIndex(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final consentTheme = context.select(
      (CurrentConsentFormDetailCubit cubit) => cubit.state.consentTheme,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PdpaAppBar(
          leadingIcon: CustomIconButton(
            onPressed: () {
              final event = UpdateConsentFormEvent(
                consentForm: widget.consentForm,
                updateType: UpdateType.updated,
              );

              context.read<ConsentFormBloc>().add(event);

              context.pop();
            },
            icon: Icons.chevron_left_outlined,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          title: Text(
            tr('consentManagement.consentForm.consentForms'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            CustomIconButton(
              onPressed: () {
                if (tabIndex == 0) {
                  context.push(
                    ConsentFormRoute.editConsentForm.path
                        .replaceFirst(':id', widget.consentForm.id),
                  );
                } else if (tabIndex == 1) {
                  context.push(
                    ConsentFormRoute.consentFormSettings.path
                        .replaceFirst(':id', widget.consentForm.id),
                  );
                }
              },
              icon: Ionicons.pencil_outline,
              iconColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: tr(
                  'consentManagement.consentForm.consentFormDetails.information',
                ),
              ),
              Tab(
                text: tr(
                  'consentManagement.consentForm.consentFormDetails.filter.form',
                ),
              ),
            ],
            // isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Theme.of(context).colorScheme.primary,
            labelStyle: Theme.of(context).textTheme.bodySmall,
            onTap: _setTabIndex,
          ),
          appBarHeight: 100.0,
        ),
        body: TabBarView(
          children: <Widget>[
            ConsentInfoTab(
              consentForm: widget.consentForm,
              mandatoryFields: widget.mandatoryFields,
              customFields: widget.customFields,
              purposeCategories: widget.purposeCategories,
              purposes: widget.purposes,
              language: widget.language,
            ),
            ConsentFormTab(
              consentForm: widget.consentForm,
              mandatoryFields: widget.mandatoryFields,
              purposeCategories: widget.purposeCategories,
              purposes: widget.purposes,
              customFields: widget.customFields,
              consentTheme: consentTheme,
            ),
          ],
        ),
      ),
    );
  }
}
