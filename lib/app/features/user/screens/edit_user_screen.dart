import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/data/models/etc/user_company_role.dart';
import 'package:pdpa/app/features/user/bloc/edit_user/edit_user_bloc.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/constants.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_dropdown_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class EditUserScreen extends StatelessWidget {
  const EditUserScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditUserBloc>(
      create: (context) => serviceLocator<EditUserBloc>()
        ..add(GetCurrentUserEvent(userId: userId)),
      child: BlocConsumer<EditUserBloc, EditUserState>(
        listener: (context, state) {
          if (state is CreatedCurrentUser) {
            showToast(
              context,
              text: 'Create successfully',
            );

            context.pop(
              UpdatedReturn<UserModel>(
                object: state.user,
                type: UpdateType.created,
              ),
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

            final deleted = UserModel.empty().copyWith(
              id: state.userId,
            );
            context.pop(
              UpdatedReturn<UserModel>(
                object: deleted,
                type: UpdateType.deleted,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GotCurrentUser) {
            return EditUserView(
              initialUser: state.user,
              isNewUser: userId.isEmpty,
            );
          }
          if (state is UpdatedCurrentUser) {
            return EditUserView(
              initialUser: state.user,
              isNewUser: userId.isEmpty,
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
  late TextEditingController companyIdController;

  // late List<UserCompanyRole> userCompanyRoles;
  late int roleSelected;
  late bool isActivated;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    companyIdController.dispose();

    super.dispose();
  }

  void _initialData() {
    user = widget.initialUser;

    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    citizenIdController = TextEditingController();
    companyIdController = TextEditingController();

    // userCompanyRoles = [];
    roleSelected = 2;
    isActivated = true;

    if (user != UserModel.empty()) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      phoneNumberController.text = user.phoneNumber;
      citizenIdController.text = user.citizenId;

      if (user.roles.isNotEmpty) {
        companyIdController.text = user.roles.first.id;
        roleSelected = user.roles.first.role.index;
      }

      // userCompanyRoles = user.roles;
      isActivated = user.status == ActiveStatus.active;
    }
  }

  // void _setActiveStatus(bool value) {
  //   setState(() {
  //     isActivated = value;

  //     final status = isActivated ? ActiveStatus.active : ActiveStatus.inactive;

  //     user = user.copyWith(status: status);
  //   });
  // }

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      user = user.copyWith(
        defaultLanguage: 'th-TH',
      );

      if (widget.isNewUser) {
        user = user.setCreate(
          AppConfig.notificationEmail,
          DateTime.now(),
        );

        final event = CreateCurrentUserEvent(user: user);
        context.read<EditUserBloc>().add(event);
      } else {
        user = user.setUpdate(
          AppConfig.notificationEmail,
          DateTime.now(),
        );

        final event = UpdateCurrentUserEvent(user: user);
        context.read<EditUserBloc>().add(event);
      }
    }
  }

  // void _deleteUser() {
  //   final event = DeleteCurrentUserEvent(userId: user.id);
  //   context.read<EditUserBloc>().add(event);
  // }

  void _goBackAndUpdate() {
    if (!widget.isNewUser) {
      context.pop(
        UpdatedReturn<UserModel>(
          object: widget.initialUser,
          type: UpdateType.updated,
        ),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: UiConfig.lineSpacing),
              CustomContainer(
                child: _buildInformationForm(context),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              CustomContainer(
                child: _buildCompanyForm(context),
              ),
              // const SizedBox(height: UiConfig.lineSpacing),
              // Visibility(
              //   visible: widget.initialUser != UserModel.empty(),
              //   child: _buildConfigurationInfo(context, widget.initialUser),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildInformationForm(BuildContext context) {
    return Column(
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
          onChanged: (value) {
            setState(() {
              user = user.copyWith(firstName: value);
            });
          },
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
          onChanged: (value) {
            setState(() {
              user = user.copyWith(lastName: value);
            });
          },
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
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            setState(() {
              user = user.copyWith(email: value);
            });
          },
          required: true,
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(text: 'Phone Number'),
        CustomTextField(
          controller: phoneNumberController,
          hintText: 'Enter your phone number',
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            setState(() {
              user = user.copyWith(phoneNumber: value);
            });
          },
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        const TitleRequiredText(text: 'Citizen ID'),
        CustomTextField(
          controller: citizenIdController,
          hintText: 'Enter your citizen ID',
          onChanged: (value) {
            setState(() {
              user = user.copyWith(citizenId: value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildCompanyForm(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'User Companies',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // CustomIconButton(
            //   onPressed: () async {},
            //   icon: Ionicons.add,
            //   iconColor: Theme.of(context).colorScheme.primary,
            //   backgroundColor: Theme.of(context).colorScheme.onBackground,
            // ),
          ],
        ),
        const SizedBox(height: UiConfig.lineSpacing),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: CustomTextField(
                controller: companyIdController,
                hintText: 'Enter your company ID',
                onChanged: (value) {
                  setState(() {
                    user = user.copyWith(
                      roles: user.roles.isEmpty
                          ? [
                              UserCompanyRole(
                                id: value,
                                role: UserRoles.values[roleSelected],
                              )
                            ]
                          : [user.roles.first.copyWith(id: value)],
                      companies: [companyIdController.text],
                      currentCompany: companyIdController.text,
                    );
                  });
                },
                required: true,
              ),
            ),
            const SizedBox(width: UiConfig.actionSpacing),
            SizedBox(
              width: 140.0,
              child: CustomDropdownButton<int>(
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
                onSelected: (value) {
                  if (value != null) {
                    setState(() {
                      roleSelected = value;
                      user = user.copyWith(
                        roles: user.roles.isEmpty
                            ? [
                                UserCompanyRole(
                                  id: companyIdController.text,
                                  role: UserRoles.values[roleSelected],
                                )
                              ]
                            : [
                                user.roles.first.copyWith(
                                    role: UserRoles.values[roleSelected])
                              ],
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
        /*ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Row(
              children: <Widget>[
                Expanded(
                  child: CustomTextField(
                    controller: companyIdController,
                    hintText: 'Enter your first name',
                    onChanged: (value) {},
                    required: true,
                  ),
                ),
                const SizedBox(width: UiConfig.actionSpacing),
                SizedBox(
                  width: 200.0,
                  child: CustomDropdownButton<int>(
                    value: userCompanyRoles[index].role.index,
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
                ),
              ],
            );
          },
          itemCount: userCompanyRoles.length,
        ),*/
      ],
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

  // Column _buildConfigurationInfo(
  //   BuildContext context,
  //   UserModel user,
  // ) {
  //   return Column(
  //     children: <Widget>[
  //       CustomContainer(
  //         child: ConfigurationInfo(
  //           configBody: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text(
  //                 'Active',
  //                 style: Theme.of(context).textTheme.bodyMedium,
  //               ),
  //               CustomSwitchButton(
  //                 value: isActivated,
  //                 onChanged: _setActiveStatus,
  //               ),
  //             ],
  //           ),
  //           updatedBy: user.updatedBy,
  //           updatedDate: user.updatedDate,
  //           onDeletePressed: _deleteUser,
  //         ),
  //       ),
  //       const SizedBox(height: UiConfig.lineSpacing),
  //     ],
  //   );
  // }
}
