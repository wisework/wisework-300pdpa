import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/authentication/bloc/reset_password/reset_password_bloc.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/features/general/bloc/app_settings/app_settings_bloc.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/expanded_container.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordBloc>(
      create: (context) => serviceLocator<ResetPasswordBloc>(),
      child: const ResetPasswordView(),
    );
  }
}

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({
    super.key,
  });

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  late TextEditingController currentPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isNotMatch = false;

  @override
  void initState() {
    super.initState();

    currentPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  void _onChangePressed() {
    if (_formKey.currentState!.validate()) {
      if (newPasswordController.text != confirmPasswordController.text) {
        setState(() {
          isNotMatch = true;
        });

        return;
      }

      if (isNotMatch) {
        setState(() {
          isNotMatch = false;
        });
      }

      final bloc = context.read<SignInBloc>();
      if (bloc.state is SignedInUser) {
        final signedIn = bloc.state as SignedInUser;
        final updated = signedIn.user.copyWith(isFirstSignIn: false);

        final initialAppSettings = InitialAppSettingsEvent(
          user: updated,
        );
        context.read<AppSettingsBloc>().add(initialAppSettings);

        final changePassword = ChangePasswordEvent(
          user: updated,
          currentPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
        );
        context.read<ResetPasswordBloc>().add(changePassword);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        title: Text(
          'Reset Password',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          CustomIconButton(
            onPressed: () {
              context.pushReplacement(AuthenticationRoute.signIn.path);
              context.read<SignInBloc>().add(const SignOutEvent());
            },
            icon: Ionicons.log_out_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildGreetingUser(context),
                const SizedBox(height: UiConfig.textSpacing),
                Text(
                  'Please reset your password for enhanced security.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                const TitleRequiredText(
                  text: 'Current Password',
                  required: true,
                ),
                CustomTextField(
                  controller: currentPasswordController,
                  hintText: 'Enter your current password',
                  onChanged: (value) {},
                  required: true,
                  obscureText: true,
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                const TitleRequiredText(
                  text: 'New Password',
                  required: true,
                ),
                CustomTextField(
                  controller: newPasswordController,
                  hintText: 'Enter your new password',
                  onChanged: (value) {},
                  required: true,
                  obscureText: true,
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                const TitleRequiredText(
                  text: 'Confirm Password',
                  required: true,
                ),
                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm your password',
                  onChanged: (value) {},
                  required: true,
                  obscureText: true,
                ),
                const SizedBox(height: UiConfig.lineGap),
                _buildWarningContainer(context),
                const SizedBox(height: UiConfig.lineGap),
                _buildChangeButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ExpandedContainer _buildWarningContainer(BuildContext context) {
    return ExpandedContainer(
      expand: isNotMatch,
      duration: const Duration(milliseconds: 400),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
          border: Border.all(
            color: Theme.of(context).colorScheme.onError,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: UiConfig.textSpacing),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(
                Icons.warning_outlined,
                size: 18.0,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            const SizedBox(width: UiConfig.textSpacing),
            Expanded(
              child: Text(
                'New password and confirm password do not match. Please make sure they are identical.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder _buildGreetingUser(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        if (state is SignedInUser) {
          return Row(
            children: <Widget>[
              Text(
                tr('auth.acceptInvite.hello'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                ', ${state.user.firstName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 8.0),
              Icon(
                Ionicons.sparkles,
                color: Theme.of(context).colorScheme.onError,
              ),
            ],
          );
        }
        return Text(
          tr('auth.acceptInvite.hello'),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }

  CustomButton _buildChangeButton(BuildContext context) {
    return CustomButton(
      height: 48,
      onPressed: _onChangePressed,
      child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ChangedPassword) {
            final event = UpdateCurrentUserEvent(
              user: state.user,
              companies: state.companies,
            );
            context.read<SignInBloc>().add(event);

            context.pushReplacement(GeneralRoute.home.path);
          }
          if (state is ResetPasswordError) {
            showToast(context, text: state.message);
          }
        },
        builder: (context, state) {
          if (state is ChangingPassword) {
            return LoadingIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
              size: 28.0,
              loadingType: LoadingType.horizontalRotatingDots,
            );
          }
          return Text(
            tr('auth.acceptInvite.continueButton'),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          );
        },
      ),
    );
  }
}
