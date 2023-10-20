import 'package:flutter/services.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/data/models/master_data/mandatory_field_model.dart';

final List<MandatoryFieldModel> mandatoryFieldPreset = [
  MandatoryFieldModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Name',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ชื่อ',
      ),
    ],
    hintText: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Enter your name',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'กรอกชื่อของคุณ',
      ),
    ],
    inputType: TextInputType.text,
    priority: 1,
  ),
  MandatoryFieldModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Address',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'ที่อยู่',
      ),
    ],
    hintText: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Enter your address',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'กรอกที่อยู่ของคุณ',
      ),
    ],
    inputType: TextInputType.multiline,
    maxLines: 3,
    priority: 2,
  ),
  MandatoryFieldModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Email',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'อีเมล',
      ),
    ],
    hintText: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Enter your email',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'กรอกอีเมลของคุณ',
      ),
    ],
    inputType: TextInputType.emailAddress,
    priority: 3,
  ),
  MandatoryFieldModel.empty().copyWith(
    title: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Phone Number',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'หมายเลขโทรศัพท์',
      ),
    ],
    hintText: const [
      LocalizedModel(
        language: 'en-US',
        text: 'Enter your phone number',
      ),
      LocalizedModel(
        language: 'th-TH',
        text: 'กรอกหมายเลขโทรศัพท์ของคุณ',
      ),
    ],
    inputType: TextInputType.phone,
    lengthLimit: 10,
    priority: 4,
  ),
];
