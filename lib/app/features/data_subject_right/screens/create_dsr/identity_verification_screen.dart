import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class DSRStep4Screen extends StatefulWidget {
  const DSRStep4Screen({super.key});

  @override
  State<DSRStep4Screen> createState() => _DSRStep4ScreenState();
}

class _DSRStep4ScreenState extends State<DSRStep4Screen> {
  bool? checkboxValue1 = false;
  bool? checkboxValue2 = false;
  bool? checkboxValue3 = false;
  bool? checkboxValue4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: const Text('แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: UiConfig.lineSpacing),
              Text(
                'เอกสารพิสูจน์อำนาจดำเนินการแทน',
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Text(
                'ทั้งนี้ข้าพเจ้าได้แนบเอกสารดังต่อไปนี้เพื่อการตรวจสอบอำนาจตัวตนและถิ่นที่อยู่ของผู้ยื่นคำร้องและเจ้าของข้อมูลส่วนบุคคลเพื่อให้บริษัทสามารถดำเนินการตามสิทธิที่ร้องขอได้อย่างถูกต้อง',
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              _checkfile(),
              _checkOtherFile(),
              const SizedBox(height: UiConfig.lineSpacing),
              CustomButton(
                width: double.infinity,
                height: 50,
                onPressed: () {
                  context.push(DataSubjectRightRouter.step5.path);
                },
                child: Text(
                  'ถัดไป',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
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

  _checkfile() {
    return Column(
      children: [
        CheckboxListTile(
          side: const BorderSide(color: Color(0xff2684FF)),
          controlAffinity: ListTileControlAffinity.leading,
          value: checkboxValue1,
          onChanged: (bool? value) {
            if (value != checkboxValue1) {
              setState(() {
                checkboxValue1 = value;
              });
            }
          },
          title: Transform.translate(
            offset: const Offset(-16, 0),
            child: Text("สำเนาทะเบียนบ้าน",
                style: checkboxValue1 == false
                    ? Theme.of(context).textTheme.bodySmall?.copyWith()
                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
          ),
        ),
        Visibility(
          visible: checkboxValue1 == true,
          child: Padding(
            padding: const EdgeInsets.only(left : 50.0 , right: 50),
            child: Column(
              children: [
                const Row(
                  children: [
                    TitleRequiredText(
                      text: 'ไฟล์สำเนา ',
                      required: true,
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.textSpacing),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 280,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.7),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        enabled: false,
                        decoration: const InputDecoration(
                          hintText: 'ไม่ได้เลือกไฟล์',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: UiConfig.textSpacing),
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.upload),
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        CheckboxListTile(
          side: const BorderSide(color: Color(0xff2684FF)),
          controlAffinity: ListTileControlAffinity.leading,
          value: checkboxValue2,
          onChanged: (bool? value) {
            if (value != checkboxValue2) {
              setState(() {
                checkboxValue2 = value;
              });
            }
          },
          title: Transform.translate(
            offset: const Offset(-16, 0),
            child: Text("สำเนาบัตรประจำตัวประชาชน(กรณีสัญชาติไทย)",
                style: checkboxValue2 == false
                    ? Theme.of(context).textTheme.bodySmall?.copyWith()
                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
          ),
        ),
        Visibility(
          visible: checkboxValue2 == true,
          child: Padding(
            padding: const EdgeInsets.only(left : 50.0 , right: 50),
            child: Column(
              children: [
                const Row(
                  children: [
                    TitleRequiredText(
                      text: 'ไฟล์สำเนา ',
                      required: true,
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.textSpacing),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 280,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.7),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        enabled: false,
                        decoration: const InputDecoration(
                          hintText: 'ไม่ได้เลือกไฟล์',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: UiConfig.textSpacing),
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.upload),
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        CheckboxListTile(
          side: const BorderSide(color: Color(0xff2684FF)),
          controlAffinity: ListTileControlAffinity.leading,
          value: checkboxValue3,
          onChanged: (bool? value) {
            if (value != checkboxValue3) {
              setState(() {
                checkboxValue3 = value;
              });
            }
          },
          title: Transform.translate(
            offset: const Offset(-16, 0),
            child: Text("สำเนาพาสปอร์ต",
                style: checkboxValue3 == false
                    ? Theme.of(context).textTheme.bodySmall?.copyWith()
                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
          ),
        ),
        Visibility(
          visible: checkboxValue3 == true,
          child: Padding(
            padding: const EdgeInsets.only(left : 50.0 , right: 50),
            child: Column(
              children: [
                const Row(
                  children: [
                    TitleRequiredText(
                      text: 'ไฟล์สำเนา ',
                      required: true,
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.textSpacing),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 280,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.7),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        enabled: false,
                        decoration: const InputDecoration(
                          hintText: 'ไม่ได้เลือกไฟล์',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: UiConfig.textSpacing),
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.upload),
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _checkOtherFile() {
    return Column(
      children: [
        CheckboxListTile(
          side: const BorderSide(color: Color(0xff2684FF)),
          controlAffinity: ListTileControlAffinity.leading,
          value: checkboxValue4,
          onChanged: (bool? value) {
            if (value != checkboxValue4) {
              setState(() {
                checkboxValue4 = value;
              });
            }
          },
          title: Transform.translate(
            offset: const Offset(-16, 0),
            child: Text("อื่นๆ ถ้ามี(โปรดระบุ)",
                style: checkboxValue4 == false
                    ? Theme.of(context).textTheme.bodySmall?.copyWith()
                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
          ),
        ),
        Visibility(
          visible: checkboxValue4 == true,
          child: Padding(
            padding: const EdgeInsets.only(left : 50.0 , right: 50),
            child: Column(
              children: [
                const Row(
                  children: [
                    TitleRequiredText(
                      text: 'ประเภทเอกสาร ',
                      required: true,
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.textSpacing),
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 280,
                      child: TextFormField(
                          decoration: InputDecoration(
                        hintText: "ประเภทเอกสาร",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.7,
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.lineSpacing),
                const Row(
                  children: [
                    TitleRequiredText(
                      text: 'ไฟล์สำเนา ',
                      required: true,
                    ),
                  ],
                ),
                const SizedBox(height: UiConfig.textSpacing),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 280,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.7),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        enabled: false,
                        decoration: const InputDecoration(
                          hintText: 'ไม่ได้เลือกไฟล์',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(width: UiConfig.textSpacing),
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.upload),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
