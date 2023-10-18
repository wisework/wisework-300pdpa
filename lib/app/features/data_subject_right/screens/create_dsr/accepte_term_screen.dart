import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DSRStep7Screen extends StatefulWidget {
  const DSRStep7Screen({super.key});

  @override
  State<DSRStep7Screen> createState() => _DSRStep7ScreenState();
}

class _DSRStep7ScreenState extends State<DSRStep7Screen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: const Text('แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: _buildStep7Form(context),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
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

  Form _buildStep7Form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'การรับทราบและยินยอม',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          CheckboxListTile(
            title: const Text(
              'ข้าพเจ้าได้อ่านและเข้าใจเนื้อหาของคำร้องขอฉบับนี้แล้ว และยืนยันว่าข้อมูลต่าง ๆ ที่ได้แจ้งแก่บริษัทนั้นถูกต้อง ข้าพเจ้าเข้าใจดีว่าการตรวจสอบเพื่อยืนยันอำนาจตัวตนและถิ่นที่อยู่ของข้าพเจ้านั้นเป็นการจำเป็นอย่างยิ่งเพื่อพิจารณาดำเนินการตามสิทธิของข้าพเจ้า หากข้าพเจ้าให้ข้อมูลที่ผิดพลาดด้วยเจตนาทุจริต ข้าพเจ้าอาจถูกดำเนินคดีตามกฎหมายได้ และบริษัทอาจขอข้อมูลเพิ่มเติมจากข้าพเจ้าเพื่อการตรวจสอบดังกล่าว เพื่อให้การดำเนินการตามคำร้องของข้าพเจ้าเป็นไปอย่างถูกต้องครบถ้วนต่อไป',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding:
                const EdgeInsets.only(top: 0, left: 0, right: 16, bottom: 0),
          ),
      
        ],
      ),
    );
  }
}
