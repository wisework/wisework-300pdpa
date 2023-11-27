import 'package:flutter/material.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class SubmitScreen extends StatelessWidget {
  const SubmitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.all(UiConfig.lineSpacing),
      constraints: const BoxConstraints(maxWidth: 500.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "คุณได้ส่งแบบฟอร์มคำร้องแล้ว",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: UiConfig.lineGap),
          Text(
            "เราจะดำเนินการตรวจสอบแบบฟอร์มและแจ้งให้ท่านทราบทางอีเมลภายใน 30 วันหลังจากที่กรอกแบบฟอร์มคำร้อง",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
