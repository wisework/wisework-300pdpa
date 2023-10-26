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
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void _signInWithGoogle() {
    context.read<SignInBloc>().add(const SignInWithGoogleEvent());
  }

  void _signInSuccessful(UserModel user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sign in with Google is successfully!',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        duration: UiConfig.toastDuration,
      ),
    );

    final event = InitialAppSettingsEvent(user: user);
    context.read<AppSettingsBloc>().add(event);

    if (user.defaultLanguage == "en-US") {
      context.setLocale(const Locale('en', 'US'));
    } else {
      context.setLocale(const Locale('th', 'TH'));
    }

    if (user.companies.isEmpty || user.currentCompany.isEmpty) {
      context.pushReplacement(AuthenticationRoute.signUpCompany.path);
    } else {
      context.pushReplacement(GeneralRoute.home.path);
    }
  }

  void _signInFailed(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
        duration: UiConfig.toastDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: 240.0,
                    child: Image.asset(
                      'assets/images/wisework-logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 60.0),
                  Text(
                    tr('app.name'),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 40.0),
                  _buildAuthenticationButton(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              tr('auth.signIn.joinOverForGoal'),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
        ],
      ),
    );
  }

  ConstrainedBox _buildAuthenticationButton() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260.0),
      child: CustomButton(
        height: 40.0,
        onPressed: _signInWithGoogle,
        child: BlocConsumer<SignInBloc, SignInState>(
          listener: (context, state) {
            if (state is SignInError) {
              _signInFailed(state.message);
            } else if (state is SignedInUser) {
              _signInSuccessful(state.user);
            }
          },
          builder: (context, state) {
            if (state is SigningInWithGoogle) {
              return SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                  strokeWidth: 3.0,
                ),
              );
            }
            return Text(
              tr('auth.signIn.signInWithGoogle'),
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
            );
          },
        ),
      ),
    );
  }
}
