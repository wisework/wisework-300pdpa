import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/company_model.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/data/presets/drawer_menu_preset.dart';
import 'package:pdpa/app/shared/utils/functions.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

import 'widgets/drawer_menu_tile.dart';

class PdpaDrawer extends StatefulWidget {
  const PdpaDrawer({
    super.key,
    required this.onClosed,
  });

  final VoidCallback onClosed;

  @override
  State<PdpaDrawer> createState() => _PdpaDrawerState();
}

class _PdpaDrawerState extends State<PdpaDrawer> {
  void _signOut() {
    context.pushReplacement(AuthenticationRoute.signIn.path);
    context.read<SignInBloc>().add(const SignOutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      child: BlocBuilder<SignInBloc, SignInState>(
        builder: (context, state) {
          if (state is SignedInUser) {
            return Column(
              children: <Widget>[
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildCompanyInfo(context, state.companies, state.user),
                    _buildCloseButton(context),
                  ],
                ),
                Divider(
                  color: Theme.of(context).colorScheme.outline,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: UiConfig.lineGap,
                      ),
                      child: Column(
                        children: drawerMenuPreset
                            .map((menu) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: UiConfig.lineGap,
                                  ),
                                  child: DrawerMenuTile(menu: menu),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Theme.of(context).colorScheme.outline,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _buildUserInfo(context, state.user),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CustomIconButton(
                        onPressed: _signOut,
                        icon: Ionicons.log_out_outline,
                        iconColor: Theme.of(context).colorScheme.primary,
                        backgroundColor:
                            Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Expanded _buildCompanyInfo(
    BuildContext context,
    List<CompanyModel> companies,
    UserModel user,
  ) {
    final company = UtilFunctions.getCurrentCompany(
      companies,
      user.currentCompany,
    );

    return Expanded(
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10.0),
            ),
            constraints: const BoxConstraints(maxWidth: 45.0, maxHeight: 45.0),
            margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text(
                  company.name[0].toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                company.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                UtilFunctions.getUserCompanyRole(
                  user.roles,
                  user.currentCompany,
                ),
                style: Theme.of(context).textTheme.labelMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Material _buildCloseButton(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(4.0),
        bottomLeft: Radius.circular(4.0),
      ),
      child: InkWell(
        onTap: widget.onClosed,
        splashColor: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4.0),
          bottomLeft: Radius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
          child: Icon(
            Ionicons.chevron_back_outline,
            size: 14.0,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }

  Expanded _buildUserInfo(BuildContext context, UserModel user) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10.0),
            ),
            constraints: const BoxConstraints(maxWidth: 45.0, maxHeight: 45.0),
            margin: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Text(
                  user.firstName[0].toUpperCase(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${user.firstName} ${user.lastName}',
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.labelMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
