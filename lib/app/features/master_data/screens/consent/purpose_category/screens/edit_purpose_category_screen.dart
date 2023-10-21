import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/edit_purpose_category/edit_purpose_category_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose/purpose_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose_category/purpose_category_bloc.dart';
import 'package:pdpa/app/features/master_data/screens/consent/purpose_category/widgets/choose_purpose_modal.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditPurposeCategoryScreen extends StatefulWidget {
  const EditPurposeCategoryScreen({
    super.key,
    required this.purposeCategoryId,
    this.isCreateByConsent = false,
  });

  final String purposeCategoryId;
  final bool isCreateByConsent;

  @override
  State<EditPurposeCategoryScreen> createState() =>
      _EditPurposeCategoryScreenState();
}

class _EditPurposeCategoryScreenState extends State<EditPurposeCategoryScreen> {
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

    String companyId = '';
    if (bloc.state is SignedInUser) {
      companyId = (bloc.state as SignedInUser).user.currentCompany;
    }

    context.read<PurposeBloc>().add(GetPurposesEvent(companyId: companyId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditPurposeCategoryBloc>(
      create: (context) => serviceLocator<EditPurposeCategoryBloc>()
        ..add(
          GetCurrentPurposeCategoryEvent(
            purposeCategoryId: widget.purposeCategoryId,
            companyId: currentUser.currentCompany,
          ),
        ),
      child: BlocConsumer<EditPurposeCategoryBloc, EditPurposeCategoryState>(
        listener: (context, state) {
          if (state is CreatedCurrentPurposeCategory) {
            BotToast.showText(
              text: tr('masterData.cm.purposeCategory.createSuccess'), //!
              contentColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              duration: UiConfig.toastDuration,
            );

            context.read<PurposeCategoryBloc>().add(UpdatePurposeCategoryEvent(
                purposeCategory: state.purposeCategory,
                updateType: UpdateType.created));

            context.pop();
          }

          if (state is UpdatedCurrentPurposeCategory) {
            BotToast.showText(
              text: tr('masterData.cm.purposeCategory.updateSuccess'), //!
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

          if (state is DeletedCurrentPurposeCategory) {
            BotToast.showText(
              text: tr('masterData.cm.purposeCategory.deleteSuccess'), //!
              contentColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.75),
              borderRadius: BorderRadius.circular(8.0),
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary),
              duration: UiConfig.toastDuration,
            );

            final deleted = PurposeCategoryModel.empty()
                .copyWith(id: state.purposeCategoryId);

            context.read<PurposeCategoryBloc>().add(UpdatePurposeCategoryEvent(
                purposeCategory: deleted, updateType: UpdateType.deleted));

            context.pop();
          }
        },
        builder: (context, state) {
          if (state is GotCurrentPurposeCategory) {
            return EditPurposeCategoryView(
              initialPurposeCategory: state.purposeCategory,
              purposes: state.purposes,
              currentUser: currentUser,
              isNewPurposeCategory: widget.purposeCategoryId.isEmpty,
              isCreateByConsent: widget.isCreateByConsent,
            );
          }
          if (state is UpdatedCurrentPurposeCategory) {
            return EditPurposeCategoryView(
              initialPurposeCategory: state.purposeCategory,
              purposes: state.purposes,
              currentUser: currentUser,
              isNewPurposeCategory: widget.purposeCategoryId.isEmpty,
              isCreateByConsent: widget.isCreateByConsent,
            );
          }
          if (state is EditPurposeCategoryError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditPurposeCategoryView extends StatefulWidget {
  const EditPurposeCategoryView({
    super.key,
    required this.initialPurposeCategory,
    required this.purposes,
    required this.currentUser,
    required this.isNewPurposeCategory,
    required this.isCreateByConsent,
  });

  final PurposeCategoryModel initialPurposeCategory;
  final List<PurposeModel> purposes;
  final UserModel currentUser;
  final bool isNewPurposeCategory;
  final bool isCreateByConsent;

  @override
  State<EditPurposeCategoryView> createState() =>
      _EditPurposeCategoryViewState();
}

class _EditPurposeCategoryViewState extends State<EditPurposeCategoryView> {
  late PurposeCategoryModel purposeCategory;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priorityController;

  late bool isActivated;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priorityController.dispose();

    super.dispose();
  }

  void _initialData() {
    purposeCategory = widget.initialPurposeCategory;

    titleController = TextEditingController();
    descriptionController = TextEditingController();
    priorityController = TextEditingController();

    isActivated = true;

    if (purposeCategory != PurposeCategoryModel.empty()) {
      if (purposeCategory.title.isNotEmpty) {
        titleController = TextEditingController(
          text: purposeCategory.title.first.text,
        );
      }
      if (purposeCategory.description.isNotEmpty) {
        descriptionController = TextEditingController(
          text: purposeCategory.description.first.text,
        );
      }
      if (purposeCategory.priority != 0) {
        priorityController = TextEditingController(
          text: purposeCategory.priority.toString(),
        );
      }

      isActivated = purposeCategory.status == ActiveStatus.active;
    }
  }

  void _setTitle(String? value) {
    setState(() {
      final title = [
        LocalizedModel(
          language: 'en-US',
          text: titleController.text,
        ),
      ];

      purposeCategory = purposeCategory.copyWith(title: title);
    });
  }

  void _setDescription(String? value) {
    setState(() {
      final description = [
        LocalizedModel(
          language: 'en-US',
          text: descriptionController.text,
        ),
      ];

      purposeCategory = purposeCategory.copyWith(description: description);
    });
  }

  void _setPriority(String? value) {
    if (value != null && value.isNotEmpty) {
      setState(() {
        final priority = int.parse(priorityController.text);

        purposeCategory = purposeCategory.copyWith(priority: priority);
      });
    }
  }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;

      final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

      purposeCategory = purposeCategory.copyWith(status: status);
    });
  }

  void _savePurposeCategory() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewPurposeCategory) {
        purposeCategory = purposeCategory.setCreate(
          widget.currentUser.email,
          DateTime.now(),
        );

        final event = CreateCurrentPurposeCategoryEvent(
          purposeCategory: purposeCategory,
          companyId: widget.currentUser.currentCompany,
        );
        context.read<EditPurposeCategoryBloc>().add(event);
      } else {
        purposeCategory = purposeCategory.setUpdate(
          widget.currentUser.email,
          DateTime.now(),
        );

        final event = UpdateCurrentPurposeCategoryEvent(
          purposeCategory: purposeCategory,
          companyId: widget.currentUser.currentCompany,
        );
        context.read<EditPurposeCategoryBloc>().add(event);
      }
    }
  }

  void _deletePurposeCategory() {
    context
        .read<EditPurposeCategoryBloc>()
        .add(DeleteCurrentPurposeCategoryEvent(
          purposeCategoryId: purposeCategory.id,
          companyId: widget.currentUser.currentCompany,
        ));
  }

  void _goBackAndUpdate() {
    if (!widget.isNewPurposeCategory) {
      context.read<PurposeCategoryBloc>().add(UpdatePurposeCategoryEvent(
            purposeCategory: purposeCategory,
            updateType: UpdateType.updated,
          ));
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: Text(
          widget.isNewPurposeCategory
              ? tr('masterData.cm.purposeCategory.create') //!
              : tr('masterData.cm.purposeCategory.edit'), //!
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          _buildSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: _buildPurposeCategoryForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Visibility(
              visible:
                  widget.initialPurposeCategory != PurposeCategoryModel.empty(),
              child: _buildConfigurationInfo(
                context,
                widget.initialPurposeCategory,
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Ionicons.chevron_back_outline,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(builder: (context) {
      if (purposeCategory != widget.initialPurposeCategory) {
        return CustomIconButton(
          onPressed: _savePurposeCategory,
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

  Form _buildPurposeCategoryForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                tr('masterData.cm.purposeCategory.list'), //!
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.titlform'), //!
            required: true,
          ),
          CustomTextField(
            controller: titleController,
            hintText: tr('masterData.cm.purposeCategory.titleformHint'), //!
            onChanged: _setTitle,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.description'), //!
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: tr('masterData.cm.purposeCategory.descriptionHint'), //!
            onChanged: _setDescription,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.priority'), //!
            required: true,
          ),
          CustomTextField(
            controller: priorityController,
            hintText: tr('masterData.cm.purposeCategory.priorityHint'), //!
            onChanged: _setPriority,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.purposes'), //!
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildPurposeSection(context, purposeCategory.purposes),
        ],
      ),
    );
  }

  Column _buildPurposeSection(BuildContext context, List<String> purposeIds) {
    final purposeFiltered = UtilFunctions.filterPurposeByIds(
      widget.purposes,
      purposeIds,
    );

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UiConfig.defaultPaddingSpacing,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: purposeFiltered.length,
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                _buildPurposeTile(
                  context,
                  purpose: purposeFiltered[index],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildAddPurposeButton(context),
      ],
    );
  }

  Row _buildPurposeTile(
    BuildContext context, {
    required PurposeModel purpose,
  }) {
    const language = 'en-US';
    final description = purpose.description.firstWhere(
      (item) => item.language == language,
      orElse: () => const LocalizedModel.empty(),
    );

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            description.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: UiConfig.actionSpacing * 2,
          ),
          child: CustomIconButton(
            onPressed: () {
              final ids = purposeCategory.purposes
                  .where((id) => id != purpose.id)
                  .toList();

              setState(() {
                purposeCategory = purposeCategory.copyWith(purposes: ids);
              });
            },
            icon: Ionicons.close,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildAddPurposeButton(BuildContext context) {
    return MaterialInkWell(
      onTap: () async {
        await showBarModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => ChoosePurposeModal(
            purposes: widget.purposes,
            initialIds: purposeCategory.purposes,
            onChanged: (ids) {
              setState(() {
                purposeCategory = purposeCategory.copyWith(purposes: ids);
              });
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Icon(
                Ionicons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: UiConfig.actionSpacing + 11),
            Expanded(
              child: Text(
                tr('masterData.cm.purposeCategory.addPurpose'), //!
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildConfigurationInfo(
    BuildContext context,
    PurposeCategoryModel purposeCategory,
  ) {
    return Column(
      children: <Widget>[
        CustomContainer(
          child: ConfigurationInfo(
            configBody: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  tr('masterData.cm.purposeCategory.active'),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                CustomSwitchButton(
                  value: isActivated,
                  onChanged: _setActiveStatus,
                ),
              ],
            ),
            updatedBy: purposeCategory.updatedBy,
            updatedDate: purposeCategory.updatedDate,
            onDeletePressed: _deletePurposeCategory,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
