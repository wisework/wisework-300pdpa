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
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';

class UserConsentSearchScreen extends StatefulWidget {
  const UserConsentSearchScreen({super.key});

  @override
  State<UserConsentSearchScreen> createState() =>
      _UserConsentSearchScreenState();
}

class _UserConsentSearchScreenState extends State<UserConsentSearchScreen> {
  late String companyId;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();

    companyId = '';
    if (bloc.state is SignedInUser) {
      companyId = (bloc.state as SignedInUser).user.currentCompany;
    }

    context.read<UserConsentBloc>().add(
          GetUserConsentsEvent(companyId: companyId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return UserConsentSearchView(
      companyId: companyId,
    );
  }
}

class UserConsentSearchView extends StatefulWidget {
  const UserConsentSearchView({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  State<UserConsentSearchView> createState() => _UserConsentSearchViewState();
}

class _UserConsentSearchViewState extends State<UserConsentSearchView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            CustomIconButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<UserConsentBloc>().add(
                    SearchUserConsentSearchChanged(
                        companyId: widget.companyId, search: ""));
              },
              icon: Icons.chevron_left_outlined,
              iconColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: 40.0,
                child: Builder(builder: (context) {
                  return CustomTextField(
                    controller: _searchController,
                    hintText: 'ค้นหา',
                    onChanged: (search) {
                      context.read<UserConsentBloc>().add(
                          SearchUserConsentSearchChanged(
                              companyId: widget.companyId, search: search));
                    },
                  );
                }),
              ),
            ),
            CustomIconButton(
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              icon: Ionicons.close_outline,
              iconColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                _searchController.clear();
                context.read<UserConsentBloc>().add(
                    SearchUserConsentSearchChanged(
                        companyId: widget.companyId, search: ""));
              },
            ),
          ],
        ),
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
              child: BlocBuilder<UserConsentBloc, UserConsentState>(
                builder: (context, state) {
                  if (state is GotUserConsents) {
                    return state.consentForms.isNotEmpty
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
                            buttonText: tr(
                                'consentManagement.userConsent.createForm.create'),
                            descriptionText:
                                tr('consentManagement.userConsent.explain'),
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
                              title,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 3,
                            ),
                          ),
                          Text(
                            dateConsentForm,
                            style: Theme.of(context).textTheme.bodyMedium,
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
