import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/search_consent_form/search_consent_form_cubit.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';

class SearchConsentFormModal extends StatefulWidget {
  const SearchConsentFormModal({
    super.key,
    required this.initialConsentForms,
    required this.language,
  });

  final List<ConsentFormModel> initialConsentForms;
  final String language;

  @override
  State<SearchConsentFormModal> createState() => _SearchConsentFormModalState();
}

class _SearchConsentFormModalState extends State<SearchConsentFormModal> {
  late UserModel currentUser;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  void _initialData() {
    searchController = TextEditingController();

    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchConsentFormCubit>(
      create: (context) => SearchConsentFormCubit()
        ..initialConsentForm(
          widget.initialConsentForms,
        ),
      child: _buildSearchScreen(context),
    );
  }

  Widget _buildSearchScreen(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              CustomIconButton(
                onPressed: () {
                  Navigator.pop(context);
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: UiConfig.actionSpacing),
                      child: CustomTextField(
                        controller: searchController,
                        hintText: 'ค้นหา', //!
                        onChanged: (search) {
                          final cubit = context.read<SearchConsentFormCubit>();
                          cubit.searchConsentForm(search, widget.language);
                        },
                      ),
                    );
                  }),
                ),
              ),
              Builder(builder: (context) {
                return CustomIconButton(
                  backgroundColor: Theme.of(context).colorScheme.onBackground,
                  icon: Ionicons.close_outline,
                  iconColor: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    final cubit = context.read<SearchConsentFormCubit>();
                    cubit.searchConsentForm('', widget.language);

                    searchController.clear();
                  },
                );
              }),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              child:
                  BlocBuilder<SearchConsentFormCubit, SearchConsentFormState>(
                builder: (context, state) {
                  if (state.consentForms.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.consentForms.length,
                      itemBuilder: (context, index) {
                        return _buildItemCard(
                          context,
                          consentForm: state.consentForms[index],
                          language: widget.language,
                        );
                      },
                    );
                  }

                  return _buildResultNotFound(context);
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
}
