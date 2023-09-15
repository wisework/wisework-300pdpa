import 'package:flutter/material.dart';
import 'package:pdpa/core/responsive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: Responsive.screenSize(context).height,
            constraints: const BoxConstraints(
              maxWidth: 400.0,
              minHeight: 580.0,
            ),
            child: Column(
              children: <Widget>[
                // BlocBuilder<LoginBloc, LoginState>(
                //   builder: (context, state) {
                //     if (state.preferencesStatus ==
                //         LoginSharedPreferencesStatus.loaded) {
                //       return const LoginContainer();
                //     }
                //     return Container();
                //   },
                // ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20.0,
                      ),
                      child: Text(
                        "Join over 100,000 users smashing their goals!",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

