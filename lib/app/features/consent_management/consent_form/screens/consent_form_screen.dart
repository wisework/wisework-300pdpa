import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/consent_form/consent_form_bloc.dart';

import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';

import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';

import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class ConsentFormScreen extends StatefulWidget {
  const ConsentFormScreen({super.key});

  @override
  State<ConsentFormScreen> createState() => _ConsentFormScreenState();
}

class _ConsentFormScreenState extends State<ConsentFormScreen> {
  late String language;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();

    if (bloc.state is SignedInUser) {
      language = (bloc.state as SignedInUser).user.defaultLanguage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConsentFormView(language: language);
  }
}

class ConsentFormView extends StatefulWidget {
  const ConsentFormView({super.key, required this.language});

  final String language;

  @override
  State<ConsentFormView> createState() => _ConsentFormViewState();
}

class _ConsentFormViewState extends State<ConsentFormView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _sortAscending = true;

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
        title: Text(
          tr('consentManagement.consentForm.consentForms'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push(ConsentFormRoute.searchConsentFormList.path);
            },
            icon: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                      child: Icon(
                    Icons.search_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )),
                  const WidgetSpan(child: SizedBox(width: 4.0)),
                  TextSpan(
                    text: tr('app.search'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ]),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text('รายการความยินยอม'),
                      _sortByDateButton(context),
                    ],
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  BlocBuilder<ConsentFormBloc, ConsentFormState>(
                    builder: (context, state) {
                      if (state is GotConsentForms) {
                        final consentForms = state.consentForms;
                        if (_sortAscending == true) {
                          consentForms.sort(((a, b) =>
                              a.updatedDate.compareTo(b.updatedDate)));
                        } else {
                          consentForms.sort(((a, b) =>
                              b.updatedDate.compareTo(a.updatedDate)));
                        }
                        return state.consentForms.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: consentForms.length,
                                itemBuilder: (context, index) {
                                  return _buildItemCard(
                                    context,
                                    consentForm: consentForms[index],
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
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(ConsentFormRoute.createConsentForm.path);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Wrap _sortButtonGroup(BuildContext context) {
  //   return Wrap(
  //     direction: Axis.horizontal,
  //     crossAxisAlignment: WrapCrossAlignment.center,
  //     children: <Widget>[
  //       IconButton(
  //         onPressed: () {},
  //         padding: EdgeInsets.zero,
  //         icon: Container(
  //           padding: const EdgeInsets.symmetric(
  //             vertical: 6.0,
  //             horizontal: 12.0,
  //           ),
  //           decoration: BoxDecoration(
  //             color: Theme.of(context).colorScheme.surface,
  //             borderRadius: BorderRadius.circular(10.0),
  //           ),
  //           child: Center(
  //             child: Text(
  //               tr("consentManagement.listage.filter.all"),
  //               style: Theme.of(context).textTheme.bodySmall,
  //             ),
  //           ),
  //         ),
  //       ),
  //       IconButton(
  //         onPressed: () {},
  //         padding: EdgeInsets.zero,
  //         icon: Container(
  //           padding: const EdgeInsets.symmetric(
  //             vertical: 6.0,
  //             horizontal: 12.0,
  //           ),
  //           decoration: BoxDecoration(
  //             color: Theme.of(context).colorScheme.surface,
  //             borderRadius: BorderRadius.circular(10.0),
  //           ),
  //           child: Text(
  //             tr("consentManagement.listage.filter.problem"),
  //             style: Theme.of(context).textTheme.bodySmall,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    : Icon(
                        Icons.arrow_drop_up,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
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

    final List<PurposeCategoryModel> purposeCategories =
        consentForm.purposeCategories
          ..sort(
            (a, b) => a.priority.compareTo(b.priority),
          );

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
                        visible: purposeCategories.isNotEmpty,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: UiConfig.textLineSpacing,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: purposeCategories.length,
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
