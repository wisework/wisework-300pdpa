import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/authentication/bloc/invitation/invitation_bloc.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';

class AcceptInviteScreen extends StatefulWidget {
  const AcceptInviteScreen({super.key});

  @override
  State<AcceptInviteScreen> createState() => _AcceptInviteScreenState();
}

class _AcceptInviteScreenState extends State<AcceptInviteScreen> {
  late TextEditingController inviteCodeController;

  @override
  void initState() {
    super.initState();

    inviteCodeController = TextEditingController();
  }

  @override
  void dispose() {
    inviteCodeController.dispose();

    super.dispose();
  }

  void _onContinuePressed() {
    final signInBloc = BlocProvider.of<SignInBloc>(context);

    if (signInBloc.state is SignedInUser) {
      final signedIn = signInBloc.state as SignedInUser;
      context.read<InvitationBloc>().add(VerifyInviteCodeEvent(
          inviteCode: inviteCodeController.text,
          user: signedIn.user,
          companies: signedIn.companies));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(UiConfig.paddingAllSpacing),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(UiConfig.paddingAllSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildGreetingUser(context),
              const SizedBox(height: UiConfig.lineSpacing),
              Text(
                tr('auth.acceptInvite.tagline1'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                tr('auth.acceptInvite.tagline2'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20.0),
              CustomTextField(
                controller: inviteCodeController,
                hintText: tr('auth.acceptInvite.enterCode'),
              ),
              const SizedBox(height: 20.0),
              _buildContinueButton(context),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        tr('auth.acceptInvite.title'),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: CustomIconButton(
            onPressed: () {
              context.pushReplacement(AuthenticationRoute.signIn.path);
              context.read<SignInBloc>().add(const SignOutEvent());
            },
            icon: Ionicons.log_out_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.onBackground,
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

  CustomButton _buildContinueButton(BuildContext context) {
    return CustomButton(
      height: 40.0,
      onPressed: _onContinuePressed,
      child: BlocConsumer<InvitationBloc, InvitationState>(
        listener: (context, state) {
          if (state is AcceptedInvitation) {
            context.read<SignInBloc>().add(UpdateCurrentUserEvent(
                user: state.user, companies: state.companies));
            context.pushReplacement(GeneralRoute.home.path);
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
