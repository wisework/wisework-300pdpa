import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class RequestConditionScreen extends StatefulWidget {
  const RequestConditionScreen({super.key});

  @override
  State<RequestConditionScreen> createState() => _RequestConditionScreenState();
}

class _RequestConditionScreenState extends State<RequestConditionScreen> {
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
      ),
      body: _buildStepSixForm(context),
    );
  }

  Widget _buildStepSixForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: UiConfig.lineSpacing),
                Text(
                  'ข้อสงวนสิทธิของผู้ควบคุมข้อมูล', //!
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "บริษัทขอเรียนแจ้งให้ท่านทราบว่า เพื่อให้เป็นไปตามกฎหมายที่"
                        "เกี่ยวข้องบริษัทอาจจำเป็นต้องปฏิเสธคำร้องขอของท่าน "
                        "ในบางกรณี ซึ่งรวมถึงแต่ไม่จำกัดเพียงกรณีดังต่อไปนี้", //!
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "1. ท่านไม่สามารถแสดงให้เห็นอย่างชัดเจนได้ว่าผู้ยื่นคำร้อง"
                        "เป็นเจ้าของข้อมูลส่วนบุคคลหรือมีอำนาจในการยื่นคำร้องขอดังกล่าว\n"
                        "2. คำร้องขอดังกล่าวไม่สมเหตุสมผล เช่น กรณีที่ผู้ร้อง\n"
                        "ขอไม่มีสิทธิในการขอเข้าถึงข้อมูลส่วนบุคคลหรือไม่มีข้อมูลส่วนบุคคลนั้นอยู่ที่บริษัท เป็นต้น\n"
                        "3. คำร้องขอดังกล่าวเป็นคำร้องขอฟุ่มเฟือย เช่น เป็นคำร้อง"
                        "ขอที่มีลักษณะเดียวกัน หรือ มีเนื้อหาเดียวกันซ้ำ ๆ กันโดยไม่มีเหตุอันสมควร\n"
                        "4. การเก็บรักษาข้อมูลส่วนบุคคลนั้นเป็นไปเพื่อการก่อตั้งสิทธิเรียกร้องตามกฎหมาย "
                        "การปฏิบัติตามกฎหมายการใช้สิทธิเรียกร้องตามกฎหมาย หรือการยกขึ้นต่อสู้"
                        "สิทธิเรียกร้องตามกฎหมาย\n", //!
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                CustomButton(
                  height: 40.0,
                  onPressed: () {
                    context.push(DataSubjectRightRoute.stepSeven.path);
                  },
                  child: Text(
                    'ถัดไป', //!
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
