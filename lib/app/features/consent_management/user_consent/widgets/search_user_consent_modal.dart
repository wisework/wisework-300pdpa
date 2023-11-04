import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/consent_management/consent_form_model.dart';
import 'package:pdpa/app/data/models/consent_management/user_consent_model.dart';
import 'package:pdpa/app/data/models/etc/user_input_text.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/consent_management/consent_form/routes/consent_form_route.dart';
import 'package:pdpa/app/features/consent_management/user_consent/cubit/search_user_consent_cubit.dart';
import 'package:pdpa/app/features/consent_management/user_consent/routes/user_consent_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/screens/example_screen.dart';

class SearchUserConsentModal extends StatefulWidget {
  const SearchUserConsentModal({
    super.key,
    required this.initialUserConsents,
    required this.language,
  });
  final List<UserConsentModel> initialUserConsents;
  final String language;
  @override
  State<SearchUserConsentModal> createState() => _SearchUserConsentModalState();
}

class _SearchUserConsentModalState extends State<SearchUserConsentModal> {
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
    return BlocProvider<SearchUserConsentCubit>(
      create: (context) => SearchUserConsentCubit()
        ..initialUserConsent(
          widget.initialUserConsents,
        ),
      child: CustomContainer(
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
                      return CustomTextField(
                        controller: searchController,
                        hintText: 'ค้นหา', //!
                        onChanged: (search) {
                          final cubit = context.read<SearchUserConsentCubit>();
                          cubit.searchUserConsent(search, widget.language);
                        },
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
                      final cubit = context.read<SearchUserConsentCubit>();
                      cubit.searchUserConsent('', widget.language);

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
                    BlocBuilder<SearchUserConsentCubit, SearchUserConsentState>(
                  builder: (context, state) {
                    if (state.userConsents.isNotEmpty) {
                      // final consentForms = state.userConsents //!
                      //     .map((e) => e.consentFormId)
                      //     .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.userConsents.length,
                        itemBuilder: (context, index) {
                          return Text('test'' $index'); //!
                          // return _buildItemCard(
                          //   context,
                          //   userConsent: state.userConsents[index],
                          //   consentForm: state.userConsents.firstWhere(
                          //     (role) =>
                          //         role.id ==
                          //         state.userConsents[index].consentFormId,
                          //     orElse: () => ConsentFormModel.empty(),
                          //   ),
                          //   mandatorySelected: state.mandatoryFields.first.id,
                          // );
                        },
                      );
                    }

                    return ExampleScreen(
                      //! FIX
                      headderText:
                          tr('consentManagement.consentForm.consentForms'),
                      buttonText:
                          tr('consentManagement.consentForm.createForm.create'),
                      descriptionText:
                          tr('consentManagement.consentForm.explain'),
                      onPress: () {
                        context.push(
                          ConsentFormRoute.createConsentForm.path,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
