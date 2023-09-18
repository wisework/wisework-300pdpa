import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('app.title')),
      ),
      body: Container(),
    );
  }
}
