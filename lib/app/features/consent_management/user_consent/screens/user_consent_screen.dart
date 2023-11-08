import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/bloc/user_consent/user_consent_bloc.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/widgets/search_user_consent_modal.dart';
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
  late String language;

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
      language = (bloc.state as SignedInUser).user.defaultLanguage;
    }

    context
        .read<UserConsentBloc>()
        .add(GetUserConsentsEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return UserConsentView(language: language);
  }
}

class UserConsentView extends StatefulWidget {
  const UserConsentView({super.key, required this.language});

  final String language;

  @override
  State<UserConsentView> createState() => _UserConsentViewState();
}

class _UserConsentViewState extends State<UserConsentView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _sortAscending = false;

  void _openSeachConsentFormModal() {
    final bloc = context.read<UserConsentBloc>();

    List<UserConsentModel> userConsents = [];
    List<ConsentFormModel> consenForms = [];
    List<MandatoryFieldModel> mandatoryFields = [];
    if (bloc.state is GotUserConsents) {
      userConsents = (bloc.state as GotUserConsents).userConsents;
      consenForms = (bloc.state as GotUserConsents).consentForms;
      mandatoryFields = (bloc.state as GotUserConsents).mandatoryFields;
    }

    showBarModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchUserConsentModal(
        initialUserConsents: userConsents,
        initialConsentForms: consenForms,
        initialMadatoryFields: mandatoryFields,
        language: widget.language,
      ),
    );
  }

  void _sortProducts(bool ascending) {
    setState(() {
      _sortAscending = ascending;
    });
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
          icon: Icons.menu_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Expanded(
          child: Text(
            tr('app.features.userconsents'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        actions: [
          CustomIconButton(
            onPressed: _openSeachConsentFormModal,
            icon: Ionicons.search,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: UiConfig.lineSpacing),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: UiConfig.defaultPaddingSpacing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'รายการความยินยอมที่ได้รับ', //!
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _sortByDateButton(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<UserConsentBloc, UserConsentState>(
                      builder: (context, state) {
                        if (state is GotUserConsents) {
                          final consentForms = state.consentForms;
                          if (_sortAscending == true) {
                            consentForms.sort(((a, b) =>
                                a.updatedDate.compareTo(b.updatedDate)));
                          } else {
                            consentForms.sort(((a, b) =>
                                b.updatedDate.compareTo(a.updatedDate)));
                          }
                          final userConsents = state.userConsents;
                          if (_sortAscending == true) {
                            userConsents.sort(((a, b) =>
                                a.updatedDate.compareTo(b.updatedDate)));
                          } else {
                            userConsents.sort(((a, b) =>
                                b.updatedDate.compareTo(a.updatedDate)));
                          }

                          return consentForms.isNotEmpty ||
                                  userConsents.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: consentForms.length,
                                  itemBuilder: (context, index) {
                                    return _buildItemCard(
                                      context,
                                      userConsent: state.userConsents[index],
                                      consentForm: consentForms.firstWhere(
                                        (role) =>
                                            role.id ==
                                            state.userConsents[index]
                                                .consentFormId,
                                        orElse: () => ConsentFormModel.empty(),
                                      ),
                                      mandatorySelected:
                                          state.mandatoryFields.first.id,
                                    );
                                  },
                                )
                              : ExampleScreen(
                                  headderText: tr(
                                      'consentManagement.consentForm.consentForms'),
                                  buttonText: tr(
                                      'consentManagement.consentForm.createForm.create'),
                                  descriptionText: tr(
                                      'consentManagement.consentForm.explain'),
                                  onPress: () {
                                    context.push(ConsentFormRoute
                                        .createConsentForm.path);
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
                ],
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

  Widget _sortByDateButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        _sortProducts(!_sortAscending);
      },
      padding: EdgeInsets.zero,
      icon: Column(
        children: [
          RichText(
              text: TextSpan(
            children: [
              TextSpan(
                  text: tr("consentManagement.listage.filter.date"),
                  style: Theme.of(context).textTheme.bodyMedium),
              WidgetSpan(
                child: _sortAscending
                    ? Icon(
                        Icons.arrow_drop_down,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      )
                    : Icon(
                        Icons.arrow_drop_up,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  _buildItemCard(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title == ''
                                  ? tr(
                                      'consentManagement.consentForm.titleNull')
                                  : title,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 3,
                            ),
                          ),
                          Text(
                            dateConsentForm,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
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
