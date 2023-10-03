import 'package:flutter/material.dart';

class ConsentFormDrawer extends StatelessWidget {
  const ConsentFormDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      child: Column(
        children: <Widget>[
          Text(
            'Consent Form',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Divider(
            color: Theme.of(context).colorScheme.outline,
          ),
        ],
      ),
    );
  }
}
