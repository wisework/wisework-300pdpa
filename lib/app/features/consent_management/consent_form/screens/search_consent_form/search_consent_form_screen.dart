import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';

class SearchConsentFormScreen extends StatefulWidget {
  const SearchConsentFormScreen({super.key});

  @override
  State<SearchConsentFormScreen> createState() =>
      _SearchConsentFormScreenState();
}

class _SearchConsentFormScreenState extends State<SearchConsentFormScreen> {
  late String language;
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
      language = (bloc.state as SignedInUser).user.defaultLanguage;
    }

    context
        .read<ConsentFormBloc>()
        .add(GetConsentFormsEvent(companyId: companyId, sort: SortType.desc));
  }

  @override
  Widget build(BuildContext context) {
    return SearchConsentFormView(
      language: language,
      companyId: companyId,
    );
  }
}

class SearchConsentFormView extends StatefulWidget {
  const SearchConsentFormView({
    super.key,
    required this.language,
    required this.companyId,
  });

  final String language;
  final String companyId;

  @override
  State<SearchConsentFormView> createState() => _SearchConsentFormViewState();
}

class _SearchConsentFormViewState extends State<SearchConsentFormView> {
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
                context.read<ConsentFormBloc>().add(SearchConsentSearchChanged(
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
                      context.read<ConsentFormBloc>().add(
                          SearchConsentSearchChanged(
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
                context.read<ConsentFormBloc>().add(SearchConsentSearchChanged(
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
                                language: widget.language,
                              );
                            },
                          )
                        : ExampleScreen(
                            headderText: tr(
                                'consentManagement.consentForm.consentForms'),
                            buttonText: tr(
                                'consentManagement.consentForm.createForm.create'),
                            descriptionText:
                                tr('consentManagement.consentForm.explain'),
                            onPress: () {
                              context.push(
                                  ConsentFormRoute.createConsentForm.path);
                            });
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
            ),
          ),
        ],
      ),
    );
  }

  _buildItemCard(
    BuildContext context, {
    required ConsentFormModel consentForm,
    required String language,
  }) {
    final title = consentForm.title
        .firstWhere(
          (item) => item.language == language,
          orElse: () => const LocalizedModel.empty(),
        )
        .text;

    final dateConsentForm =
        DateFormat("dd.MM.yy").format(consentForm.updatedDate);

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
                        visible: consentForm.purposeCategories.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: UiConfig.textLineSpacing,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: consentForm.purposeCategories.length,
                            itemBuilder: (_, index) {
                              if (index <= 1) {
                                final titlePurposeCategories =
                                    consentForm.purposeCategories[index].title
                                        .firstWhere(
                                          (item) => item.language == language,
                                          orElse: LocalizedModel.empty,
                                        )
                                        .text;
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: UiConfig.textSpacing),
                                  child: Text(
                                    titlePurposeCategories,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                              }
                              if (index == 2) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: UiConfig.textSpacing),
                                  child: Text(
                                    "...",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                );
                              }
                              return Container();
                            },
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
