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
import 'package:pdpa/app/shared/widgets/wise_work_shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _getCurrentUser();
  }

  void _getCurrentUser() {
    context.read<SignInBloc>().add(const GetSignedUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  void _alreadySignedIn(UserModel user) {
    showToast(context, text: tr('auth.signIn.welcomeBack'));

    final event = InitialAppSettingsEvent(user: user);
    context.read<AppSettingsBloc>().add(event);

    if (user.isFirstSignIn) {
      context.pushReplacement(AuthenticationRoute.resetPassword.path);
    } else if (user.companies.isEmpty || user.currentCompany.isEmpty) {
      context.pushReplacement(AuthenticationRoute.signUpCompany.path);
    } else {
      context.pushReplacement(GeneralRoute.home.path);
    }
  }

  void _redirectToSignIn() {
    context.pushReplacement(AuthenticationRoute.signIn.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing * 2),
        child: Column(
          children: <Widget>[
            _buildLogoApp(),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text(
                    tr('app.poweredBy'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onTertiary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: UiConfig.textSpacing),
                  Text(
                    tr('app.copyright'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onTertiary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  BlocListener _buildLogoApp() {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) async {
        await Future.delayed(const Duration(milliseconds: 1000)).then((_) {
          if (state is SignedInUser) {
            _alreadySignedIn(state.user);
          } else if (state is SignInInitial || state is SignInError) {
            _redirectToSignIn();
          }
        });
      },
      child: const Padding(
        padding: EdgeInsets.only(
          top: UiConfig.defaultPaddingSpacing * 8,
          bottom: UiConfig.defaultPaddingSpacing * 2,
        ),
        child: WiseWorkShimmer(),
      ),
    );
  }
}
