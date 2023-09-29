import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';

class CustomFieldScreen extends StatelessWidget {
  CustomFieldScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CustomIconButton(
              onPressed: () {
                context.pop();
              },
              icon: Ionicons.arrow_back,
              iconColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.onBackground,
            ),
            Text(tr('masterdata.consentmasterdata.customfields'))
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () async {
              // await Navigator.pushNamed(
              //   context,
              //   AppRoutes.masterData.inputField.create(),
              // ).then((result) {
              //   if (result != null) {
              //     final inputField = result as InputField;
              //     context
              //         .read<InputFieldBloc>()
              //         .add(InputFieldUpdated(inputField));
              //   }
              // });
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.add_rounded,
              size: 40,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          );
        },
      ),
    );
  }
}
