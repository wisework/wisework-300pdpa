import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_checkbox.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';

class AcknowledgePage extends StatefulWidget {
  const AcknowledgePage({
    super.key,
  });

  @override
  State<AcknowledgePage> createState() => _AcknowledgePageState();
}

class _AcknowledgePageState extends State<AcknowledgePage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Theme.of(context).colorScheme.primary),
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.lineSpacing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
