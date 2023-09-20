import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/core/widgets/custom_button.dart';
import 'package:pdpa/features/authentication/presentation/bloc/authentication_bloc.dart';

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

    getCurrentUser();
  }

  void signInWithGoogle() {
    context.read<AuthenticationBloc>().add(const SignInWithGoogleEvent());
  }

  void getCurrentUser() {
    context.read<AuthenticationBloc>().add(const GetCurrentUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxHeight < 600) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  Image.asset('assets/images/wisework-logo.png'),
                  const SizedBox(height: 60.0),
                  Text(
                    tr('app.name'),
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 40.0),
                  _buildAuthenticationButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      tr('app.auth.joinOverForGoal'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiary),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset('assets/images/wisework-logo.png'),
                    const SizedBox(height: 60.0),
                    Text(
                      tr('app.name'),
                      style: Theme.of(context).textTheme.displayLarge,
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
                tr('app.auth.joinOverForGoal'),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ),
          ],
        );
      }),
    );
  }

  ConstrainedBox _buildAuthenticationButton() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300.0),
      child: Column(
        children: <Widget>[
          CustomButton(
            height: 40.0,
            onPressed: signInWithGoogle,
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
                } else if (state is SignedInWithGoogle) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Sign in with Google is successfully!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is GettingCurrentUser) {
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
                  tr('app.auth.signInWithGoogle'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                );
              },
            ),
          ),
          const SizedBox(height: 10.0),
          BlocConsumer<AuthenticationBloc, AuthenticationState>(
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
              } else if (state is SignedOut) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Sign out is successfully!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is SignedInWithGoogle || state is GotCurrentUser) {
                return CustomButton(
                  height: 40.0,
                  onPressed: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(const SignOutEvent());
                  },
                  buttonType: CustomButtonType.outlined,
                  child: Text(
                    'Sign out',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  /*ConstrainedBox _buildSignInForm(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CustomTextField(
            key: const ValueKey('sign_in_email_field'),
            controller: usernameController,
            hintText: tr('app.auth.username'),
          ),
          const SizedBox(height: 15.0),
          CustomTextField(
            key: const ValueKey('sign_in_password_field'),
            controller: passwordController,
            hintText: tr('app.auth.password'),
            obscureText: true,
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomCheckBox(
                    value: false,
                    onChanged: (value) {},
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    tr('app.auth.rememberMe'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              CustomButton(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2.0,
                ),
                onPressed: () {},
                buttonType: CustomButtonType.text,
                child: Text(
                  tr('app.auth.forgotPassword'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          CustomButton(
            height: 40.0,
            onPressed: () {},
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
                } else if (state is GotCurrentUser) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Sign in is successfully!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is GettingCurrentUser) {
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
                  tr('app.auth.signIn'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                );
              },
            ),
          ),
          const SizedBox(height: 10.0),
          CustomButton(
            height: 40.0,
            onPressed: signInWithGoogle,
            buttonType: CustomButtonType.outlined,
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
                } else if (state is SignedInWithGoogle) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Sign in with Google is successfully!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is GettingCurrentUser) {
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
                  tr('app.auth.signInWithGoogle'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                );
              },
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }*/
}
