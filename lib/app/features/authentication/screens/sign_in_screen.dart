import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/features/general/bloc/app_settings/app_settings_bloc.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/shared/utils/toast.dart';
import 'package:pdpa/app/shared/utils/user_preferences.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final GlobalKey<FormState> _signInformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();

  bool isRememberMe = false;
  int formIndex = 0;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();

    _getEmailSaved();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _getEmailSaved() async {
    final result = await UserPreferences.getString(
      AppPreferences.rememberEmail,
    );

    if (result != null) {
      setState(() {
        isRememberMe = result.isNotEmpty;
        emailController.text = result;
      });
    }
  }

  void _formValidate() async {
    if (_signInformKey.currentState!.validate()) {
      if (isRememberMe) {
        await UserPreferences.setString(
          AppPreferences.rememberEmail,
          emailController.text,
        );
      } else {
        await UserPreferences.setString(
          AppPreferences.rememberEmail,
          '',
        );
      }

      _signInWithEmailAndPassword();
    }
  }

  void _signInWithEmailAndPassword() {
    final event = SignInWithEmailAndPasswordEvent(
      email: emailController.text,
      password: passwordController.text,
    );
    context.read<SignInBloc>().add(event);
  }

  // void _signInWithGoogle() {
  //   context.read<SignInBloc>().add(const SignInWithGoogleEvent());
  // }

  void _signInSuccessful(UserModel user) {
    showToast(context, text: tr('auth.signIn.signInSuccessful'));

    final event = InitialAppSettingsEvent(user: user);
    context.read<AppSettingsBloc>().add(event);

    if (user.defaultLanguage == "en-US") {
      context.setLocale(const Locale('en', 'US'));
    } else {
      context.setLocale(const Locale('th', 'TH'));
    }

    if (user.isFirstSignIn) {
      context.pushReplacement(AuthenticationRoute.resetPassword.path);
    } else if (user.companies.isEmpty || user.currentCompany.isEmpty) {
      context.pushReplacement(AuthenticationRoute.signUpCompany.path);
    } else {
      context.pushReplacement(GeneralRoute.home.path);
    }
  }

  void _setRememberMe(bool value) {
    setState(() {
      isRememberMe = value;
    });
  }

  void _setFormIndex(int index) {
    setState(() {
      formIndex = index;
    });
  }

  void _sendPasswordReset() {
    if (_forgotPasswordFormKey.currentState!.validate()) {
      final event = SendPasswordResetEvent(
        email: emailController.text,
      );
      context.read<SignInBloc>().add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.background
          : Theme.of(context).colorScheme.onBackground,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 480.0,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: UiConfig.lineSpacing),
                SizedBox(
                  width: screenSize.width,
                  child: Builder(builder: (context) {
                    if (formIndex != 0) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 342.0,
                        ),
                        child: Image.asset(
                          'assets/images/authentication/forgot-password.png',
                          fit: BoxFit.contain,
                        ),
                      );
                    }
                    return Image.asset(
                      'assets/images/authentication/login.png',
                      fit: BoxFit.contain,
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: UiConfig.defaultPaddingSpacing,
                  ),
                  child: Builder(builder: (context) {
                    if (formIndex != 0) {
                      return _buildResetPasswordWrapper(context);
                    }
                    return _buildLoginWrapper(context);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildLoginWrapper(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing * 2),
            Text(
              tr('auth.signIn.signIn'),
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: UiConfig.lineGap),
            Text(
              tr('auth.signIn.signInDescription'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: UiConfig.lineSpacing * 2),
            Center(child: _buildSignInForm(context)),
            const SizedBox(height: UiConfig.lineSpacing * 2),
            Align(
              alignment: Alignment.center,
              child: Text(
                tr('app.copyright'),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  ConstrainedBox _buildSignInForm(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300.0,
      ),
      child: Form(
        key: _signInformKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextField(
              key: const ValueKey('sign_in_email_field'),
              controller: emailController,
              hintText: tr('auth.signIn.email'),
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            CustomTextField(
              key: const ValueKey('sign_in_password_field'),
              controller: passwordController,
              hintText: tr('auth.signIn.password'),
              required: true,
              obscureText: true,
            ),
            const SizedBox(height: UiConfig.lineGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    CustomCheckBox(
                      value: isRememberMe,
                      onChanged: _setRememberMe,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      tr('auth.signIn.rememberMe'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                CustomButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  onPressed: () {
                    _setFormIndex(1);
                  },
                  buttonType: CustomButtonType.text,
                  child: Text(
                    tr('auth.signIn.forgotPassword'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: UiConfig.lineGap),
            CustomButton(
              height: 50.0,
              onPressed: _formValidate,
              child: BlocConsumer<SignInBloc, SignInState>(
                listener: (context, state) {
                  if (state is SignInError) {
                    showToast(context, text: state.message);
                  } else if (state is SignedInUser) {
                    _signInSuccessful(state.user);
                  }
                },
                builder: (context, state) {
                  if (state is SigningInWithEmailAndPassword) {
                    return LoadingIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 28.0,
                      loadingType: LoadingType.horizontalRotatingDots,
                    );
                  }
                  return Text(
                    tr('auth.signIn.signIn'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  );
                },
              ),
            ),
            // const SizedBox(height: UiConfig.lineGap),
            // CustomButton(
            //   height: 50.0,
            //   onPressed: _signInWithGoogle,
            //   buttonType: CustomButtonType.outlined,
            //   child: BlocConsumer<SignInBloc, SignInState>(
            //     listener: (context, state) {
            //       if (state is SignInError) {
            //         showToast(context, text: state.message);
            //       } else if (state is SignedInUser) {
            //         _signInSuccessful(state.user);
            //       }
            //     },
            //     builder: (context, state) {
            //       if (state is SigningInWithGoogle) {
            //         return LoadingIndicator(
            //           color: Theme.of(context).colorScheme.primary,
            //           size: 28.0,
            //           loadingType: LoadingType.horizontalRotatingDots,
            //         );
            //       }
            //       return Text(
            //         tr('auth.signIn.signInWithGoogle'),
            //         style: Theme.of(context).textTheme.titleMedium?.copyWith(
            //             color: Theme.of(context).colorScheme.primary),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Padding _buildResetPasswordWrapper(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 480.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing * 2),
            Text(
              '${tr('auth.signIn.forgotPassword')}?',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: UiConfig.lineGap),
            Text(
              formIndex == 2
                  ? tr('auth.signIn.resendDescription')
                  : tr('auth.signIn.forgotDescription'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: UiConfig.lineSpacing * 2),
            Center(
              child: formIndex == 2
                  ? _buildResentForgotPasswordForm(context)
                  : _buildForgotPasswordForm(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing * 2),
            Align(
              alignment: Alignment.center,
              child: Text(
                tr('app.copyright'),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  ConstrainedBox _buildForgotPasswordForm(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300.0,
      ),
      child: Form(
        key: _forgotPasswordFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextField(
              key: const ValueKey('forgot_password_email_field'),
              controller: emailController,
              hintText: tr('auth.signIn.email'),
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            CustomButton(
              height: 50.0,
              onPressed: _sendPasswordReset,
              child: BlocConsumer<SignInBloc, SignInState>(
                listener: (context, state) {
                  if (state is SentPasswordReset) {
                    _setFormIndex(2);

                    showToast(
                      context,
                      text: tr('auth.signIn.passwordResetSent'),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is SendingPasswordReset) {
                    return LoadingIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 28.0,
                      loadingType: LoadingType.horizontalRotatingDots,
                    );
                  }
                  return Text(
                    tr('app.confirm'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  );
                },
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  onPressed: () {
                    _setFormIndex(0);
                  },
                  buttonType: CustomButtonType.text,
                  child: Text(
                    tr('app.back'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ConstrainedBox _buildResentForgotPasswordForm(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300.0,
      ),
      child: Form(
        key: _forgotPasswordFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CustomTextField(
              key: const ValueKey('forgot_password_email_field'),
              controller: emailController,
              hintText: tr('auth.signIn.email'),
              keyboardType: TextInputType.emailAddress,
              required: true,
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            CustomButton(
              height: 50.0,
              onPressed: _sendPasswordReset,
              child: BlocConsumer<SignInBloc, SignInState>(
                listener: (context, state) {
                  if (state is SentPasswordReset) {
                    showToast(
                      context,
                      text: tr('auth.signIn.passwordResetSent'),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is SendingPasswordReset) {
                    return LoadingIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 28.0,
                      loadingType: LoadingType.horizontalRotatingDots,
                    );
                  }
                  return Text(
                    tr('auth.signIn.sendAgain'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  );
                },
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ),
                  onPressed: () {
                    _setFormIndex(0);
                  },
                  buttonType: CustomButtonType.text,
                  child: Text(
                    tr('app.back'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
