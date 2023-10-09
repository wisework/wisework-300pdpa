import 'package:bot_toast/bot_toast.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/purpose_category_model.dart';

import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/edit_purpose_category/edit_purpose_category_bloc.dart';
import 'package:pdpa/app/features/master_data/bloc/consent/purpose_category/purpose_category_bloc.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_multiselect_dropdown_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditPurposeCategoryScreen extends StatefulWidget {
  const EditPurposeCategoryScreen({
    super.key,
    required this.purposeCategoryId,
  });

  final String purposeCategoryId;

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
              text: 'Create successfully',
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
              text: 'Update successfully',
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
              text: 'Delete successfully',
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
              currentUser: currentUser,
              isNewPurposeCategory: widget.purposeCategoryId.isEmpty,
            );
          }
          if (state is UpdatedCurrentPurposeCategory) {
            return EditPurposeCategoryView(
              initialPurposeCategory: state.purposeCategory,
              currentUser: currentUser,
              isNewPurposeCategory: widget.purposeCategoryId.isEmpty,
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
    required this.currentUser,
    required this.isNewPurposeCategory,
  });

  final PurposeCategoryModel initialPurposeCategory;
  final UserModel currentUser;
  final bool isNewPurposeCategory;

  @override
  State<EditPurposeCategoryView> createState() =>
      _EditPurposeCategoryViewState();
}

class _EditPurposeCategoryViewState extends State<EditPurposeCategoryView> {
  late PurposeCategoryModel purposeCategory;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priorityController;
  late List<String> purposeList;

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

    purposeList = [];
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

      purposeList = purposeCategory.purposes;
      // print(purpose);

      // purpose = purposeCategory.purposes.;
      // unitSelected = purpose.periodUnit.isNotEmpty ? purpose.periodUnit : 'd';

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

  // void _setPurpose(List<String>? value) {
  //   setState(() {
  //     final description = [
  //       LocalizedModel(
  //         language: 'en-US',
  //         text: descriptionController.text,
  //       ),
  //     ];

  //     purpose = purpose.copyWith(description: description);
  //   });
  // }

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
        purposeCategory = purposeCategory.toCreated(
          widget.currentUser.email,
          DateTime.now(),
        );

        context
            .read<EditPurposeCategoryBloc>()
            .add(CreateCurrentPurposeCategoryEvent(
              purposeCategory: purposeCategory,
              companyId: widget.currentUser.currentCompany,
            ));
      } else {
        purposeCategory = purposeCategory.toUpdated(
          widget.currentUser.email,
          DateTime.now(),
        );

        context
            .read<EditPurposeCategoryBloc>()
            .add(UpdateCurrentPurposeCategoryEvent(
              purposeCategory: purposeCategory,
              companyId: widget.currentUser.currentCompany,
            ));
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
        leadingIcon: _buildPopButton(widget.initialPurposeCategory),
        title: Text(
          widget.isNewPurposeCategory
              ? tr('masterData.cm.purposeCategory.create')
              : tr('masterData.cm.purposeCategory.edit'),
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
                  context, widget.initialPurposeCategory),
            ),
          ],
        ),
      ),
    );
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
                tr('masterData.cm.purposeCategory.list'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.titlform'),
            required: true,
          ),
          CustomTextField(
            controller: titleController,
            hintText: tr('masterData.cm.purposeCategory.titleformHint'),
            onChanged: _setTitle,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.description'),
          ),
          CustomTextField(
            controller: descriptionController,
            hintText: tr('masterData.cm.purposeCategory.descriptionHint'),
            onChanged: _setDescription,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.priority'),
            required: true,
          ),
          CustomTextField(
            controller: priorityController,
            hintText: tr('masterData.cm.purposeCategory.priorityHint'),
            onChanged: _setPriority,
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          TitleRequiredText(
            text: tr('masterData.cm.purposeCategory.purposes'),
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          _buildPurposeList(context),

          // CustomDropdownButton<String>(
          //   value: unitSelected,
          //   items: periodUnits.map(
          //     (unit) {
          //       return DropdownMenuItem(
          //         value: unit[0].toLowerCase(),
          //         child: Text(
          //           unit,
          //           style: Theme.of(context).textTheme.bodyMedium,
          //         ),
          //       );
          //     },
          //   ).toList(),
          //   onSelected: _setPeriodUnit,
          // ),
        ],
      ),
    );
  }

  Column _buildPurposeList(BuildContext context) {
    List<String> items = purposeList;
    Map<String, bool> itemSelection = {};
    final List<String> itemsDropDown = [
      'Item1',
      'Item2',
      'Item3',
      'Item4',
    ];
    List<String> selectedItems = [];


    void addItem(String item) {
      setState(() {
        items.add(item);
        itemSelection[item] = false;
      });
    }

    void removeItem(String item) {
      setState(() {
        items.remove(item);
        itemSelection.remove(item);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        purposeList.isEmpty
            ? const CustomContainer(child: Text('No Data'))
            : CustomContainer(
                color: Theme.of(context).colorScheme.onTertiary,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: purposeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    // return Text(purposeList[index]);
                    final item = items[index];

                    return CheckboxListTile(
                      title: Text(item),
                      value: itemSelection[item] ?? false,
                      onChanged: (newValue) {
                        setState(() {
                          itemSelection[item] = newValue!;
                        });
                      },
                      secondary: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeItem(item);
                        },
                      ),
                    );
                  },
                ),
              ),
        const SizedBox(height: UiConfig.lineSpacing),
        // CustomIconButton(
        //   icon: Icons.add,
        //   onPressed: _addPurposes,
        // ),
        const SizedBox(height: UiConfig.lineSpacing),

        CustomMultiSelectDropdownButton(
          hint: 'Select Purposes',
          value: selectedItems.isEmpty ? null : selectedItems.last,
          dropdownItems: itemsDropDown,
          onChanged: (value) {},
        ),
       
      ],
    );
  }

  // void _addPurposes() {
  //   showModalBottomSheet<dynamic>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Column(
  //         children: [CheckboxListTile(value: value, onChanged: onChanged)],
  //       );
  //     },
  //   );
  // }

  CustomIconButton _buildPopButton(PurposeCategoryModel purposeCategory) {
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
                  tr('masterData.etc.active'),
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
