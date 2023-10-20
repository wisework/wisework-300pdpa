import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/general/cubit/setting_cubit.dart';
import 'package:pdpa/app/shared/drawers/pdpa_drawer.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_dropdown_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final bloc = context.read<SignInBloc>();
    if (bloc.state is SignedInUser) {
      currentUser = (bloc.state as SignedInUser).user;
    } else {
      currentUser = UserModel.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingCubit>();
    print(cubit.state.localDevice);
    return SettingView(
      local: cubit,
      currentUser: currentUser,
    );
  }
}

// ignore: must_be_immutable
class SettingView extends StatefulWidget {
  SettingView({
    super.key,
    required this.local,
    required this.currentUser,
  });

  SettingCubit local;
  UserModel currentUser;
  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final language = ['en-US', 'th-TH'];
  @override
  void initState() {
    super.initState();
  }

  void _setInputType(String? value) {
    if (value != null) {
      widget.local.setLocalDevice(value);

      if (widget.local.state.localDevice == 'th-TH') {
        EasyLocalization.of(context)?.setLocale(const Locale('th', 'TH'));
      } else {
        EasyLocalization.of(context)?.setLocale(const Locale('en', 'US'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.currentUser.defaultLanguage);
    print(context.supportedLocales);
    return Scaffold(
      key: _scaffoldKey,
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Ionicons.menu_outline,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          tr('app.features.setting'), //!
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: BlocBuilder<SignInBloc, SignInState>(
                builder: (context, state) {
                  if (state is SignedInUser) {
                    return Column(
                      children: <Widget>[
                        const SizedBox(height: UiConfig.lineSpacing),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              tr('app.language'),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(
                              width: 120,
                              child: CustomDropdownButton<String>(
                                value: state.user.defaultLanguage,
                                items: language.map(
                                  (e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    );
                                  },
                                ).toList(),
                                onSelected: _setInputType,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Theme.of(context)
                              .colorScheme
                              .outlineVariant
                              .withOpacity(0.5),
                        ),
                        const SizedBox(height: UiConfig.lineSpacing),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: PdpaDrawer(
        onClosed: () {
          _scaffoldKey.currentState?.closeDrawer();
        },
      ),
    );
  }
}
