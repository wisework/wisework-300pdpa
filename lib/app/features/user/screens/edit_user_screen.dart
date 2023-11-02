import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/features/master_data/widgets/configuration_info.dart';
import 'package:pdpa/app/features/user/bloc/edit_user/edit_user_bloc.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_dropdown_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_switch_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<EditUserBloc>()
        ..add(GetCurrentUserEvent(userId: widget.userId)),
      child: BlocConsumer<EditUserBloc, EditUserState>(
        listener: (context, state) {
          if (state is CreatedCurrentUser) {
            showToast(
              context,
              text: 'Create successfully',
            );

            context.pop(
                // UpdatedReturn<PurposeCategoryModel>(
                //   object: state.purposeCategory,
                //   type: UpdateType.created,
                // ),
                );
          }

          if (state is UpdatedCurrentUser) {
            showToast(
              context,
              text: 'Update successfully',
            );
          }

          if (state is DeletedurrentUser) {
            showToast(
              context,
              text: 'Delete successfully',
            );

            // final deleted = PurposeCategoryModel.empty().copyWith(
            //   id: state.purposeCategoryId,
            // );
            // context.pop(
            //   UpdatedReturn<PurposeCategoryModel>(
            //     object: deleted,
            //     type: UpdateType.deleted,
            //   ),
            // );
          }
        },
        builder: (context, state) {
          if (state is GotCurrentUser) {
            return EditUserView(
              initialUser: state.user,
              isNewUser: widget.userId.isEmpty,
            );
          }
          if (state is UpdatedCurrentUser) {
            return EditUserView(
              initialUser: state.user,
              isNewUser: widget.userId.isEmpty,
            );
          }
          if (state is EditUserError) {
            return ErrorMessageScreen(message: state.message);
          }

          return const LoadingScreen();
        },
      ),
    );
  }
}

class EditUserView extends StatefulWidget {
  const EditUserView({
    super.key,
    required this.initialUser,
    required this.isNewUser,
  });

  final UserModel initialUser;
  final bool isNewUser;

  @override
  State<EditUserView> createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  late UserModel user;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController citizenIdController;

  late int roleSelected;
  late bool isActivated;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String adminEmail = 'admin-ww300@gmail.com';

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    citizenIdController.dispose();

    super.dispose();
  }

  void _initialData() {
    user = widget.initialUser;

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    citizenIdController = TextEditingController();

    roleSelected = 2;
    isActivated = true;

    if (user != UserModel.empty()) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      phoneNumberController.text = user.phoneNumber;
      citizenIdController.text = user.citizenId;

      isActivated = user.status == ActiveStatus.active;
    }
  }

  void _setActiveStatus(bool value) {
    setState(() {
      isActivated = value;

      final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

      user = user.copyWith(status: status);
    });
  }

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      if (widget.isNewUser) {
        user = user.setCreate(
          adminEmail,
          DateTime.now(),
        );

        // final event = CreateCurrentPurposeCategoryEvent(
        //   purposeCategory: purposeCategory,
        //   companyId: widget.currentUser.currentCompany,
        // );
        // context.read<EditPurposeCategoryBloc>().add(event);
      } else {
        user = user.setUpdate(
          adminEmail,
          DateTime.now(),
        );

        // final event = UpdateCurrentPurposeCategoryEvent(
        //   purposeCategory: purposeCategory,
        //   companyId: widget.currentUser.currentCompany,
        // );
        // context.read<EditPurposeCategoryBloc>().add(event);
      }
    }
  }

  void _deleteUser() {
    // final event = DeleteCurrentPurposeCategoryEvent(
    //   purposeCategoryId: purposeCategory.id,
    //   companyId: widget.currentUser.currentCompany,
    // );
    // context.read<EditPurposeCategoryBloc>().add(event);
  }

  void _goBackAndUpdate() {
    if (!widget.isNewUser) {
      context.pop(
          // UpdatedReturn<PurposeCategoryModel>(
          //   object: widget.initialPurposeCategory,
          //   type: UpdateType.updated,
          // ),
          );
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: Text(
          widget.isNewUser ? 'Create User' : 'Edit User',
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
              child: _buildUserForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Visibility(
              visible: widget.initialUser != UserModel.empty(),
              child: _buildConfigurationInfo(context, widget.initialUser),
            ),
          ],
        ),
      ),
    );
  }

  Form _buildUserForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Infomation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'First Name',
            required: true,
          ),
          CustomTextField(
            controller: firstNameController,
            hintText: 'Enter your first name',
            onChanged: (value) {},
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'Last Name',
            required: true,
          ),
          CustomTextField(
            controller: lastNameController,
            hintText: 'Enter your last name',
            onChanged: (value) {},
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'Email',
            required: true,
          ),
          CustomTextField(
            controller: emailController,
            hintText: 'Enter your email',
            onChanged: (value) {},
            required: true,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(text: 'Phone Number'),
          CustomTextField(
            controller: phoneNumberController,
            hintText: 'Enter your phone number',
            onChanged: (value) {},
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(text: 'Citizen ID'),
          CustomTextField(
            controller: citizenIdController,
            hintText: 'Enter your citizen ID',
            onChanged: (value) {},
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(text: 'Role'),
          CustomDropdownButton<int>(
            value: roleSelected,
            items: UserRoles.values.map(
              (role) {
                return DropdownMenuItem(
                  value: role.index,
                  child: Text(
                    '${role.name[0].toUpperCase()}${role.name.substring(1)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ).toList(),
            onSelected: (value) {},
          ),
        ],
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: _goBackAndUpdate,
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  Builder _buildSaveButton() {
    return Builder(builder: (context) {
      if (user != widget.initialUser) {
        return CustomIconButton(
          onPressed: _saveUser,
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
    UserModel user,
  ) {
    return Column(
      children: <Widget>[
        CustomContainer(
          child: ConfigurationInfo(
            configBody: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Active',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                CustomSwitchButton(
                  value: isActivated,
                  onChanged: _setActiveStatus,
                ),
              ],
            ),
            updatedBy: user.updatedBy,
            updatedDate: user.updatedDate,
            onDeletePressed: _deleteUser,
          ),
        ),
        const SizedBox(height: UiConfig.lineSpacing),
      ],
    );
  }
}
