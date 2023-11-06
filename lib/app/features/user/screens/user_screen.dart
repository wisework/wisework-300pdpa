import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/authentication/user_model.dart';
import 'package:pdpa/app/data/models/etc/updated_return.dart';
import 'package:pdpa/app/features/authentication/routes/authentication_route.dart';
import 'package:pdpa/app/features/user/bloc/user/user_bloc.dart';
import 'package:pdpa/app/features/user/routes/user_route.dart';
import 'package:pdpa/app/shared/widgets/loading_indicator.dart';
import 'package:pdpa/app/shared/widgets/material_ink_well.dart';
import 'package:pdpa/app/shared/widgets/screens/error_message_screen.dart';
import 'package:pdpa/app/shared/widgets/screens/loading_screen.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    context.read<UserBloc>().add(const GetUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserNoAccess) {
          context.pushReplacement(AuthenticationRoute.splash.path);
        }
      },
      builder: (context, state) {
        if (state is GotUsers) {
          return const UserView();
        }
        if (state is UserError) {
          return ErrorMessageScreen(message: state.message);
        }
        return const LoadingScreen();
      },
    );
  }
}

class UserView extends StatefulWidget {
  const UserView({
    super.key,
  });

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  void _onUpdated(UpdatedReturn<UserModel> updated) {
    final event = UpdateUsersChangedEvent(
      user: updated.object,
      updateType: updated.type,
    );
    context.read<UserBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        title: Text(
          'User Management',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserError) {
                  return Container(
                    padding: const EdgeInsets.all(
                      UiConfig.defaultPaddingSpacing,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    child: Center(
                      child: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
                if (state is GotUsers) {
                  return _buildUserView(context, users: state.users);
                }
                return Container(
                  padding: const EdgeInsets.all(
                    UiConfig.defaultPaddingSpacing,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  child: const Center(
                    child: LoadingIndicator(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(UserRoute.createUser.path).then((value) {
            if (value != null) {
              _onUpdated(value as UpdatedReturn<UserModel>);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  SingleChildScrollView _buildUserView(
    BuildContext context, {
    required List<UserModel> users,
  }) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            return _buildItemCard(
              context,
              user: users[index],
              onUpdated: _onUpdated,
            );
          },
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: UiConfig.textSpacing,
            ),
            child: Divider(
              height: 0.1,
              color:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  MaterialInkWell _buildItemCard(
    BuildContext context, {
    required UserModel user,
    required Function(UpdatedReturn<UserModel> updated) onUpdated,
  }) {
    return MaterialInkWell(
      onTap: () async {
        await context
            .push(UserRoute.editUser.path.replaceFirst(':id', user.id))
            .then((value) {
          if (value != null) {
            onUpdated(value as UpdatedReturn<UserModel>);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${user.firstName} ${user.lastName}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              user.email,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
