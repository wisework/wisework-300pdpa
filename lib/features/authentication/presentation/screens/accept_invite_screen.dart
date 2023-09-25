import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/config/config.dart';
import 'package:pdpa/core/widgets/custom_button.dart';
import 'package:pdpa/core/widgets/custom_icon_button.dart';
import 'package:pdpa/core/widgets/custom_text_field.dart';
import 'package:pdpa/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pdpa/features/authentication/presentation/routes/authentication_route.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UiConfig.paddingAllSpacing),
          child: Container(
            padding: const EdgeInsets.all(UiConfig.paddingAllSpacing),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(10.0),
            ),
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
              context.read<AuthenticationBloc>().add(const SignOutEvent());
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
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is SignedIn) {
          return RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: tr('auth.acceptInvite.hello'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextSpan(
                  text: ', ${state.user.firstName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const WidgetSpan(
                  child: SizedBox(width: 8.0),
                ),
                WidgetSpan(
                  child: Icon(
                    Ionicons.sparkles,
                    color: Theme.of(context).colorScheme.onError,
                  ),
                ),
              ],
            ),
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
      onPressed: () {
        // final authBloc = BlocProvider.of<AuthenticationBloc>(context);
        // if (authBloc is SignedIn) {
        //   final updated = (authBloc.state as SignedIn).user;

        //   context.read<AuthenticationBloc>().add(UpdateUserEvent(user: updated));
        // }
      },
      child: Text(
        tr('auth.acceptInvite.continueButton'),
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }
}
