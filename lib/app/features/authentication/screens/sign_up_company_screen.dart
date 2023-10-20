import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/presets/mandatory_field_preset.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_up_company/sign_up_company_bloc.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/features/general/routes/general_route.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class SignUpCompanyScreen extends StatelessWidget {
  const SignUpCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCompanyBloc>(
      create: (context) => serviceLocator<SignUpCompanyBloc>(),
      child: const SignUpCompanyView(),
    );
  }
}

class SignUpCompanyView extends StatefulWidget {
  const SignUpCompanyView({super.key});

  @override
  State<SignUpCompanyView> createState() => _SignUpCompanyViewState();
}

class _SignUpCompanyViewState extends State<SignUpCompanyView> {
  late CompanyModel company;
  late TextEditingController companyNameController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    company = CompanyModel.empty();
    companyNameController = TextEditingController();
  }

  @override
  void dispose() {
    companyNameController.dispose();

    super.dispose();
  }

  void _onSignUpPressed() {
    if (_formKey.currentState!.validate()) {
      final bloc = context.read<SignInBloc>();
      if (bloc.state is SignedInUser) {
        final signedIn = bloc.state as SignedInUser;

        final event = SubmitCompanySettingsEvent(
          user: signedIn.user,
          company: company
              .copyWith(name: companyNameController.text)
              .setCreate(signedIn.user.email, DateTime.now()),
          mandatoryFields: mandatoryFieldPreset
              .map((field) =>
                  field.setCreate(signedIn.user.email, DateTime.now()))
              .toList(),
        );
        context.read<SignUpCompanyBloc>().add(event);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        title: Text(
          tr('auth.signUpCompany.title'),
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
        child: Column(
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildGreetingUser(context),
                    const SizedBox(height: UiConfig.lineSpacing),
                    Text(
                      tr('auth.signUpCompany.tagline1'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      tr('auth.signUpCompany.tagline2'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20.0),
                    CustomTextField(
                      controller: companyNameController,
                      hintText: tr('auth.signUpCompany.enterCompanyName'),
                      required: true,
                    ),
                    const SizedBox(height: 20.0),
                    _buildSignUpButton(context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
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
                tr('auth.signUpCompany.hello'),
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
          tr('auth.signUpCompany.hello'),
          style: Theme.of(context).textTheme.titleMedium,
        );
      },
    );
  }

  CustomButton _buildSignUpButton(BuildContext context) {
    return CustomButton(
      height: 40.0,
      onPressed: _onSignUpPressed,
      child: BlocConsumer<SignUpCompanyBloc, SignUpCompanyState>(
        listener: (context, state) {
          if (state is SignedUpCompany) {
            context.read<SignInBloc>().add(UpdateCurrentUserEvent(
                user: state.user, companies: state.companies));
            context.pushReplacement(GeneralRoute.home.path);
          }
        },
        builder: (context, state) {
          if (state is SigningUpCompany) {
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
            tr('auth.signUpCompany.signUpButton'),
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
