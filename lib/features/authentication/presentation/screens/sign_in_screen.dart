import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/core/widgets/custom_button.dart';
import 'package:pdpa/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pdpa/features/authentication/presentation/routes/authentication_route.dart';

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
    context.read<AuthenticationBloc>().add(const SignInWithGoogleEvent());
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
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              );
            } else if (state is SignedIn) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sign in with Google is successfully!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              );
              context.pushReplacement(AuthenticationRoute.acceptInvite.path);
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
