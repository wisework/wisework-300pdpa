import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class RequestAcceptTermScreen extends StatefulWidget {
  const RequestAcceptTermScreen({super.key});

  @override
  State<RequestAcceptTermScreen> createState() =>
      _RequestAcceptTermScreenState();
}

class _RequestAcceptTermScreenState extends State<RequestAcceptTermScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: CustomIconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icons.chevron_left_outlined,
          iconColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        ),
        title: Text(
          'แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย', //!
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          _buildSaveButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: UiConfig.lineSpacing),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    'การรับทราบและยินยอม', //!
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCheckBox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(
                          "ข้าพเจ้าได้อ่านและเข้าใจเนื้อหาของคำร้องขอฉบับนี้แล้ว และยืนยันว่าข้อมูลต่าง ๆ "
                          "ที่ได้แจ้งแก่บริษัทนั้นถูกต้อง ข้าพเจ้าเข้าใจดีว่าการตรวจสอบเพื่อยืนยันอำนาจตัวตน"
                          "และถิ่นที่อยู่ของข้าพเจ้านั้นเป็นการจำเป็นอย่างยิ่งเพื่อพิจารณาดำเนินการตามสิทธิของข้าพเจ้า"
                          "หากข้าพเจ้าให้ข้อมูลที่ผิดพลาดด้วยเจตนาทุจริต ข้าพเจ้าอาจถูกดำเนินคดีตามกฎหมายได้ "
                          "และบริษัทอาจขอข้อมูลเพิ่มเติมจากข้าพเจ้าเพื่อการตรวจสอบดังกล่าว "
                          "เพื่อให้การดำเนินการตามคำร้องของข้าพเจ้าเป็นไปอย่างถูกต้องครบถ้วนต่อไป", //!
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                ],
              ),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
          ],
        ),
      ),
    );
  }

  Builder _buildSaveButton() {
    return Builder(
      builder: (context) {
        if (isChecked) {
          return CustomIconButton(
            onPressed: () {
              context.go(DataSubjectRightRoute.dataSubjectRight.path);
            },
            icon: Ionicons.save_outline,
            iconColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          );
        }
        return CustomIconButton(
          icon: Ionicons.save_outline,
          iconColor: Theme.of(context).colorScheme.onTertiary,
          backgroundColor: Theme.of(context).colorScheme.onBackground,
        );
      },
    );
  }
}
