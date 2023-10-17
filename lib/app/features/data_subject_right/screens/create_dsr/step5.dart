import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/features/data_subject_right/routes/data_subject_right_route.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class DSRStep5Screen extends StatefulWidget {
  const DSRStep5Screen({super.key});

  @override
  State<DSRStep5Screen> createState() => _DSRStep5ScreenState();
}

class _DSRStep5ScreenState extends State<DSRStep5Screen> {
  bool? checkboxValue1 = false;
  bool? checkboxValue2 = false;

  late int selectedRadioTile;

  @override
  void initState() {
    super.initState();
    // ตั้งค่าค่าเริ่มต้นของ Radio
    selectedRadioTile = 1;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  Map<String, bool> choices = {
    'อยู่ในระหว่างการตรวจสอบตามที่เจ้าของข้อมูลส่วนบุคคลร้องขอให้บริษัทแก้ไขข้อมูลส่วนบุคคล':
        false,
    'เป็นข้อมูลส่วนบุคคลที่ต้องลบหรือทำลาย เพราะเป็นการประมวลผลข้อมูลส่วนบุคคลโดยไม่ชอบด้วยกฎหมายแต่เจ้าของข้อมูลส่วนบุคคลประสงค์ขอให้ระงับการใช้แทน ':
        false,
    'ข้อมูลส่วนบุคคลหมดความจำเป็นในการเก็บรักษาไว้ตามวัตถุประสงค์ในการประมวลผลแต่เจ้าของข้อมูลส่วนบุคคลมีความจำเป็นต้องขอให้เก็บรักษาไว้เพื่อใช้ในการก่อตั้งสิทธิเรียกร้องตามกฎหมายการปฏิบัติตามหรือการใช้สิทธิเรียกร้องตามกฎหมาย':
        false,
    'เหตุผลอื่นๆ โปรดระบุ': false,
  }; // ตั้งค่า Checkbox เริ่มต้น
  String otherReason = '';

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
                'ต้องการยื่นคำร้องขอเพื่อจุดประสงค์ดังต่อไปนี้',
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Text(
                'โปรดเลือกจุดประสงค์ที่ท่านต้องการ',
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),

              _checkOtherFile(),
              const SizedBox(height: UiConfig.lineSpacing),
                CustomButton(
                width: double.infinity,
                height: 50,
                onPressed: () {
                  context.push(DataSubjectRightRouter.step6.path);
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

  _checkOtherFile() {
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
            child: Text("ระงับการประมวลผลข้อมูล",
                style: checkboxValue2 == false
                    ? Theme.of(context).textTheme.bodySmall?.copyWith()
                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
          ),
        ),
        Visibility(
          visible: checkboxValue1 == true,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // กำหนดให้ชิดซ้าย
                children: [
                  Text(
                    'ข้อมูลและรายละเอียดการดำเนินการ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  const TitleRequiredText(
                    text: 'ข้อมูลส่วนบุคคล',
                    required: true,
                  ),
                  const CustomTextField(
                    hintText: 'กรอกข้อมูลส่วนบุคคล',
                    required: true,
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  const TitleRequiredText(
                    text: 'สถานที่พบเจอ',
                  ),
                  const CustomTextField(
                    hintText: 'กรอกสถานที่พบเจอ',
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  const TitleRequiredText(
                    text: 'การดำเนินการ',
                    required: true,
                  ),
                  ListTile(
                    title: Text('ลบ',
                        style: Theme.of(context).textTheme.bodyMedium),
                    leading: Radio(
                      value: 1,
                      groupValue: selectedRadioTile,
                      onChanged: (val) {
                        setSelectedRadioTile(val!);
                      },
                    ),
                    onTap: () {
                      setSelectedRadioTile(1);
                    },
                  ),
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.5),
                  ),
                  ListTile(
                    title: Text('ไม่ทำลาย',
                        style: Theme.of(context).textTheme.bodyMedium),
                    leading: Radio(
                      value: 2,
                      groupValue: selectedRadioTile,
                      onChanged: (val) {
                        setSelectedRadioTile(val!);
                      },
                    ),
                    onTap: () {
                      setSelectedRadioTile(2);
                    },
                  ),
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .outlineVariant
                        .withOpacity(0.5),
                  ),
                  ListTile(
                    title: Text('ทำให้ไม่สามารถระบุตัวตน',
                        style: Theme.of(context).textTheme.bodyMedium),
                    leading: Radio(
                      value: 3,
                      groupValue: selectedRadioTile,
                      onChanged: (val) {
                        setSelectedRadioTile(val!);
                      },
                    ),
                    onTap: () {
                      setSelectedRadioTile(3);
                    },
                  ),
                  const SizedBox(height: UiConfig.lineSpacing),
                  Text(
                    'เหตุผลประกอบคำร้อง',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Column(
                    children: choices.keys.map((String choice) {
                      return choice == 'เหตุผลอื่นๆ โปรดระบุ'
                          ? Column(
                              children: [
                                CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: const EdgeInsets.only(
                                      top: 0, left: 0, right: 16, bottom: 0),
                                  title: Text(choice),
                                  value: choices[choice]!,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      choices[choice] = value!;
                                    });
                                  },
                                ),
                                if (choices[choice]!)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const TitleRequiredText(
                                          text: 'เหตุผล',
                                          required: true,
                                        ),
                                        TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              otherReason = value;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'เหตุผล',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            )
                          : CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: const EdgeInsets.only(
                                  top: 0, left: 0, right: 16, bottom: 0),
                              title: Text(choice),
                              value: choices[choice]!,
                              onChanged: (bool? value) {
                                setState(() {
                                  choices[choice] = value!;
                                });
                              },
                            );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
