import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/bloc/choose_purpose_category/choose_purpose_category_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/cubit/choose_purpose_category/choose_purpose_category_cubit.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class ChoosePurposeCategoryScreen extends StatefulWidget {
  const ChoosePurposeCategoryScreen({
    super.key,
  });

  @override
  State<ChoosePurposeCategoryScreen> createState() =>
      _ChoosePurposeCategoryScreenState();
}

class _ChoosePurposeCategoryScreenState
    extends State<ChoosePurposeCategoryScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    const language = "en-US";
    return BlocProvider<ChoosePurposeCategoryBloc>(
      create: (context) => serviceLocator<ChoosePurposeCategoryBloc>()
        ..add(GetCurrentAllPurposeCategoryEvent(
          companyId: currentUser.currentCompany,
        )),
      child: BlocBuilder<ChoosePurposeCategoryBloc, ChoosePurposeCategoryState>(
        builder: (context, state) {
          if (state is GotCurrentPurposeCategory) {
            return ChoosePurposeCategoryView(
              purposeCategories: state.purposeCategories,
              purposes: state.purposes,
            );
          }
          if (state is ChoosePurposeCategoryError) {
            return ErrorMessageScreen(message: state.message);
          }
          return const LoadingScreen();
        },
      ),
    );
  }
}

class ChoosePurposeCategoryView extends StatefulWidget {
  const ChoosePurposeCategoryView({
    super.key,
    required this.purposeCategories,
    required this.purposes,
  });

  final List<PurposeCategoryModel> purposeCategories;
  final List<PurposeModel> purposes;

  @override
  State<ChoosePurposeCategoryView> createState() =>
      _ChoosePurposeCategoryViewState();
}

class _ChoosePurposeCategoryViewState extends State<ChoosePurposeCategoryView> {
  void _savePurpose() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Choose purpose category",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: widget.purposeCategories != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 10.0,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  CustomContainer(
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.purposeCategories.length,
                          itemBuilder: (_, index) {
                            return PurposeCategoryTile(
                              purposeCategory: widget.purposeCategories[index],
                              purposes: widget.purposes,
                            );
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {},
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            )),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  width: 0.3,
                                  color: Theme.of(context).colorScheme.outline,
                                ))),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.add_rounded,
                                      size: 32,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceTint,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Text("เพิ่มหมวดหมู่วัตถุประสงค์",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 10.0,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                Expanded(
                  child: Center(
                      child: Text(
                    "Data not found.",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  )),
                ),
              ],
            ),
    );
  }
}

class PurposeCategoryTile extends StatelessWidget {
  const PurposeCategoryTile({
    Key? key,
    required this.purposeCategory,
    required this.purposes,
  }) : super(key: key);

  final PurposeCategoryModel purposeCategory;
  final List<PurposeModel> purposes;

  @override
  Widget build(BuildContext context) {
    const language = 'en-US';
    final title = purposeCategory.title
        .firstWhere(
          (item) => item.language == language,
          orElse: LocalizedModel.empty,
        )
        .text;
    return SizedBox(
      width: double.infinity,
      child: TextButton(
          onPressed: () {
            context
                .read<ChoosePurposeCategoryCubit>()
                .choosePurposeCategoryExpanded(purposeCategory.id);
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          )),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.3,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                child: BlocBuilder<ChoosePurposeCategoryCubit,
                    ChoosePurposeCategoryCubitState>(
                  builder: (context, state) {
                    return Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Checkbox(
                                value: state.purposeCategorySelected
                                    .contains(purposeCategory),
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                                onChanged: (_) {
                                  print(state.purposeCategorySelected);
                                  context
                                      .read<ChoosePurposeCategoryCubit>()
                                      .choosePurposeCategorySelected(
                                          purposeCategory);
                                }),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                ),
                              ),
                            ),
                            Icon(
                              state.expandId != purposeCategory.id
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up,
                              size: 24,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          ],
                        ),
                        ExpandedContainer(
                          expand: state.expandId == purposeCategory.id,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 47.0,
                              top: purposeCategory.purposes.isNotEmpty
                                  ? 10.0
                                  : 0,
                              bottom: purposeCategory.purposes.isNotEmpty
                                  ? 10.0
                                  : 0,
                            ),
                            child: Column(
                              children: <Widget>[
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: purposeCategory.purposes.length,
                                  itemBuilder: (_, index) {
                                    return PurposeTile(
                                      purpose: purposes[index],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )),
          )),
    );
  }
}

class PurposeTile extends StatelessWidget {
  const PurposeTile({
    Key? key,
    required this.purpose,
  }) : super(key: key);

  final PurposeModel purpose;

  @override
  Widget build(BuildContext context) {
    final description = purpose.description
        .firstWhere(
          (item) => item.language == "en-US",
          orElse: LocalizedModel.empty,
        )
        .text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(description,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                )),
      ],
    );
  }
}
