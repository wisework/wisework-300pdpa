import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/core/widgets/custom_button.dart';
import 'package:pdpa/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pdpa/features/authentication/presentation/routes/authentication_route.dart';

class AcceptInviteScreen extends StatelessWidget {
  const AcceptInviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: <Widget>[
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300.0),
              child: CustomButton(
                height: 40.0,
                onPressed: () {
                  context.read<AuthenticationBloc>().add(const SignOutEvent());
                  context.pushReplacement(AuthenticationRoute.signIn.path);
                },
                buttonType: CustomButtonType.outlined,
                child: Text(
                  'Sign out',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
