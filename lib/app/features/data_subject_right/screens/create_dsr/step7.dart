import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DSRStep7Screen extends StatefulWidget {
  const DSRStep7Screen({super.key});

  @override
  State<DSRStep7Screen> createState() => _DSRStep7ScreenState();
}

class _DSRStep7ScreenState extends State<DSRStep7Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: const Text('แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย'),
      ),
      body: Container(
      ),
    );
  }
  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: () => context.pop(),
      icon: Ionicons.chevron_back_outline,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}