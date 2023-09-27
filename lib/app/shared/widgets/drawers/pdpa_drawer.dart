import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/authentication/bloc/sign_in/sign_in_bloc.dart';

class PdpaDrawer extends StatelessWidget {
  const PdpaDrawer({
    super.key,
    required this.onClosed,
  });

  final VoidCallback onClosed;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildUserInfo(context),
              _buildCloseButton(context),
            ],
          ),
          Divider(
            color: Theme.of(context).colorScheme.outline,
          ),
          Container(),
        ],
      ),
    );
  }

  Row _buildUserInfo(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10.0),
          ),
          constraints: const BoxConstraints(maxWidth: 75.0),
          margin: const EdgeInsets.all(UiConfig.paddingAllSpacing),
          child: Text(
            'M',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
        BlocBuilder<SignInBloc, SignInState>(
          builder: (context, state) {
            if (state is SignedInUser) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${state.user.firstName} ${state.user.lastName}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${state.user.role.name[0].toUpperCase()}'
                    '${state.user.role.name.substring(1)}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ],
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
        onTap: onClosed,
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
}
