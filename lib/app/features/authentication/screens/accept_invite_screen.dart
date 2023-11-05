import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/authentication/bloc/invitation/invitation_bloc.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/features/general/bloc/app_settings/app_settings_bloc.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class AcceptInviteScreen extends StatelessWidget {
  const AcceptInviteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvitationBloc>(
      create: (context) => serviceLocator<InvitationBloc>(),
      child: const AcceptInviteView(),
    );
  }
}

class AcceptInviteView extends StatefulWidget {
  const AcceptInviteView({super.key});

  @override
  State<AcceptInviteView> createState() => _AcceptInviteViewState();
}

class _AcceptInviteViewState extends State<AcceptInviteView> {
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
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      final signedIn = bloc.state as SignedInUser;

      final initialAppSettings = InitialAppSettingsEvent(
        user: signedIn.user,
      );
      context.read<AppSettingsBloc>().add(initialAppSettings);

      final verifyInviteCode = VerifyInviteCodeEvent(
        inviteCode: inviteCodeController.text,
        user: signedIn.user,
        companies: signedIn.companies,
      );
      context.read<InvitationBloc>().add(verifyInviteCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        title: Text(
          tr('auth.acceptInvite.title'),
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
            context.read<SignInBloc>().add(UpdateSignedUserEvent(
                user: state.user, companies: state.companies));
            context.pushReplacement(GeneralRoute.home.path);
          }
        },
        builder: (context, state) {
          if (state is SigningInWithGoogle) {
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
