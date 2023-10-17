import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class DSRStep6Screen extends StatefulWidget {
  const DSRStep6Screen({super.key});

  @override
  State<DSRStep6Screen> createState() => _DSRStep6ScreenState();
}

class _DSRStep6ScreenState extends State<DSRStep6Screen> {
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
        padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
        child: _buildStep6Form(context),
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

  Form _buildStep6Form(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'ข้อสงวนสิทธิของผู้ควบคุมข้อมูล',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            const Row(
              children: <Widget>[
                Text(
                  'บริษัทขอเรียนแจ้งให้ท่านทราบว่า เพื่อให้เป็นไปตามกฎหมายที่\nเกี่ยวข้องบริษัทอาจจำเป็นต้องปฏิเสธคำร้องขอของท่าน\n ในบางกรณี ซึ่งรวมถึงแต่ไม่จำกัดเพียงกรณีดังต่อไปนี้',
                ),
              ],
            ),
         
            const TitleRequiredText(
              text:
                  '1. ท่านไม่สามารถแสดงให้เห็นอย่างชัดเจนได้ว่าผู้ยื่นคำร้อง\nเป็นเจ้าของข้อมูลส่วนบุคคลหรือมีอำนาจใน\nการยื่นคำร้องขอดังกล่าว',
            ),
           
            const TitleRequiredText(
              text:
                  '2. คำร้องขอดังกล่าวไม่สมเหตุสมผล เช่น กรณีที่ผู้ร้อง\nขอไม่มีสิทธิในการขอเข้าถึงข้อมูลส่วนบุคคลหรือ\nไม่มีข้อมูลส่วนบุคคลนั้นอยู่ที่บริษัท เป็นต้น',
            ),
        
            const TitleRequiredText(
              text:
                  '3. คำร้องขอดังกล่าวเป็นคำร้องขอฟุ่มเฟือย เช่น เป็นคำร้อง\nขอที่มีลักษณะเดียวกัน หรือ มีเนื้อหาเดียวกัน\nซ้ำ ๆ กันโดยไม่มีเหตุอันสมควร',
            ),
            
            const TitleRequiredText(
              text:
                  '4. การเก็บรักษาข้อมูลส่วนบุคคลนั้นเป็นไป\nเพื่อการก่อตั้งสิทธิเรียกร้องตามกฎหมาย การปฏิบัติตามกฎหมาย\nการใช้สิทธิเรียกร้องตามกฎหมาย หรือการยกขึ้นต่อสู้\nสิทธิเรียกร้องตามกฎหมาย',
            ),
            const TitleRequiredText(
              text:
                  '5. การดำเนินการดังกล่าวกระทบในด้านลบต่อ\nสิทธิเสรีภาพของบุคคลอื่น',
            ),
            
            const TitleRequiredText(
              text:
                  '6. การประมวลผลข้อมูลนั้นมีความจำเป็นในการปฏิบัติ\nหน้าที่ตามสัญญาระหว่างเจ้าของข้อมูลส่วนบุคคลกับบริษัท ',
            ),
           
            const TitleRequiredText(
              text:
                  '7. การประมวลผลข้อมูลมีความจำเป็นเพื่อประโยชน์โดย\nชอบด้วยกฎหมายของบริษัท',
            ),
        
            const TitleRequiredText(
              text:
                  '8. กรณีอื่นๆตามกฎหมายที่เกี่ยวข้องกำหนดโดยปกติ\nท่านจะไม่เสียค่าใช้จ่ายในการดำเนินการตามคำร้อง\nขอของท่านอย่างไรก็ดีหากปรากฏอย่างชัดเจนว่า\nคำร้องขอของท่านเป็นคำร้องขอที่ไม่สมเหตุสมผลหรือคำร้อง\nขอฟุ่มเฟือยบริษัทอาจคิดค่าใช้จ่ายในการ\nดำเนินการแก่ท่านตามสมควร',
            ),
            const SizedBox(height: UiConfig.lineSpacing),
            CustomButton(
              width: double.infinity,
              height: 50,
              onPressed: () {
                context.push(DataSubjectRightRouter.step7.path);
              },
              child: Text(
                'ถัดไป',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
