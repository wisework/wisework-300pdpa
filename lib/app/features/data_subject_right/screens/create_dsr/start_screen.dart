import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DSRStratScreen extends StatefulWidget {
  const DSRStratScreen({super.key});

  @override
  State<DSRStratScreen> createState() => _DSRStratScreenState();
}

class _DSRStratScreenState extends State<DSRStratScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: const Text('แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        padding: const EdgeInsets.only(left : 50 , right: 50 , top : 20),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'M',
                    style: TextStyle(fontSize: 48 , color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            Text(
              'แบบฟอร์มขอใช้สิทธิ์ตามกฎหมายคุ้มครองข้อมูลส่วนบุคคล',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            Divider(
              color:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            ),
            Text(
              'พระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคลได้ให้สิทธิแก่เจ้าของข้อมูลส่วนบุคคลในการขอใช้สิทธิดำเนินการต่อข้อมูลส่วนบุคคลของตนซึ่งอยู่ในความดูแลของบริษัท Yab ในฐานะผู้ควบคุมข้อมูลส่วนบุคคลทั้งนี้ท่านสามารถใช้สิทธิดังกล่าวได้โดยการกรอกรายละเอียดในแบบคำร้องนี้',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            CustomButton(
              width: double.infinity,
              height: 50,
                onPressed: () {
                  context.push(DataSubjectRightRouter.step2.path);
                },
                child: Text(
                  'กรอกแบบคำร้อง',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                ))
          ],
        ),
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
