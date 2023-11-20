import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';

import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_list_tile.dart';

import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class OwnerVerifyPage extends StatefulWidget {
  const OwnerVerifyPage({
    super.key,
  });

  @override
  State<OwnerVerifyPage> createState() => _OwnerVerifyPageState();
}

class _OwnerVerifyPageState extends State<OwnerVerifyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<RequesterInputModel> dataRequester = [];
  late DataSubjectRightModel dataSubjectRight;

  late int selectedRadioTile;

  late TextEditingController fullNameController;
  late TextEditingController addressTextController;
  late TextEditingController emailController;
  late TextEditingController phonenumberController;

  RequesterInputModel fullName = RequesterInputModel.empty();
  RequesterInputModel address = RequesterInputModel.empty();
  RequesterInputModel email = RequesterInputModel.empty();
  RequesterInputModel phonenumber = RequesterInputModel.empty();

  bool isDataOwner = true;

  @override
  void initState() {
    selectedRadioTile = 1;
    _initialData();
    super.initState();
  }

  void _initialData() {
    dataSubjectRight =
        context.read<FormDataSubjectRightCubit>().state.dataSubjectRight;

    isDataOwner = dataSubjectRight.isDataOwner;
    isDataOwner == true ? selectedRadioTile = 1 : selectedRadioTile = 2;
    if (dataSubjectRight.dataRequester.isNotEmpty &&
        dataSubjectRight.dataRequester
            .where((element) => element.id == 'RequesterInput-001')
            .isNotEmpty) {
      fullNameController = TextEditingController(
        text: dataSubjectRight.dataRequester
            .where((element) => element.id == 'RequesterInput-001')
            .first
            .text,
      );
    } else {
      fullNameController = TextEditingController();
    }

    if (dataSubjectRight.dataRequester.isNotEmpty &&
        dataSubjectRight.dataRequester
            .where((element) => element.id == 'RequesterInput-002')
            .isNotEmpty) {
      addressTextController = TextEditingController(
        text: dataSubjectRight.dataRequester
            .where((element) => element.id == 'RequesterInput-002')
            .first
            .text,
      );
    } else {
      addressTextController = TextEditingController();
    }

    if (dataSubjectRight.dataRequester.isNotEmpty &&
        dataSubjectRight.dataRequester
            .where(
              (element) => element.id == 'RequesterInput-003',
            )
            .isNotEmpty) {
      emailController = TextEditingController(
        text: dataSubjectRight.dataRequester
            .where((element) => element.id == 'RequesterInput-003')
            .first
            .text,
      );
    } else {
      emailController = TextEditingController();
    }

    if (dataSubjectRight.dataRequester.isNotEmpty &&
        dataSubjectRight.dataRequester
            .where((element) => element.id == 'RequesterInput-004')
            .isNotEmpty) {
      phonenumberController = TextEditingController(
        text: dataSubjectRight.dataRequester
            .where((element) => element.id == 'RequesterInput-004')
            .first
            .text,
      );
    } else {
      phonenumberController = TextEditingController();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressTextController.dispose();
    emailController.dispose();
    phonenumberController.dispose();

    super.dispose();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });

    val == 1 ? isDataOwner = true : isDataOwner = false;

    context.read<FormDataSubjectRightCubit>().setDataSubjectRight(
        dataSubjectRight.copyWith(isDataOwner: isDataOwner));
  }

  void _setdataRequester(RequesterInputModel newData) {
    int existingIndex = dataSubjectRight.dataRequester
        .indexWhere((element) => element.id == newData.id);

    // If the ID exists, update the data; otherwise, add it to the list
    if (existingIndex != -1) {
      dataSubjectRight.dataRequester[existingIndex] = newData;
    } else {
      dataSubjectRight.dataRequester.add(newData);
    }

    context.read<FormDataSubjectRightCubit>().setDataSubjectRight(
        dataSubjectRight.copyWith(
            dataRequester: dataSubjectRight.dataRequester));
  }

  void _setFullNameController(String? value) {
    fullName = RequesterInputModel(
      id: 'RequesterInput-001',
      title: const [
        LocalizedModel(
          language: 'en-US',
          text: 'Firstname - Lastname',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'ชื่อ - นามสกุล',
        ),
      ],
      text: fullNameController.text,
      priority: 1,
    );
    _setdataRequester(fullName);
  }

  void _setAddressTextController(String? value) {
    address = RequesterInputModel(
      id: 'RequesterInput-002',
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
      text: addressTextController.text,
      priority: 2,
    );
    _setdataRequester(address);
  }

  void _setEmailController(String? value) {
    email = RequesterInputModel(
      id: 'RequesterInput-003',
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
      text: emailController.text,
      priority: 3,
    );
    _setdataRequester(email);
  }

  void _setPhoneNumberController(String? value) {
    phonenumber = RequesterInputModel(
      id: 'RequesterInput-004',
      title: const [
        LocalizedModel(
          language: 'en-US',
          text: 'Phone number',
        ),
        LocalizedModel(
          language: 'th-TH',
          text: 'เบอร์โทรติดต่อ',
        ),
      ],
      text: phonenumberController.text,
      priority: 4,
    );
    _setdataRequester(phonenumber);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: UiConfig.lineSpacing),
          CustomContainer(
            padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
            child: _buildStep1Form(context),
          ),
        ],
      ),
    );
  }

  Form _buildStep1Form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'ท่านเป็นเจ้าของข้อมูลหรือไม่', //!
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          DataSubjectRightListTile(
            title: 'ผู้ยื่นคำร้องเป็นบุคคลเดียวกับเจ้าของข้อมูล', //!
            onTap: () {
              setSelectedRadioTile(1);
            },
            leading: CustomRadioButton(
              value: 1,
              selected: selectedRadioTile,
              onChanged: (val) {
                setSelectedRadioTile(val!);
              },
            ),
          ),
          DataSubjectRightListTile(
            title: 'ผู้ยื่นคำร้องเป็นตัวแทนเจ้าของข้อมูล', //!
            onTap: () {
              setSelectedRadioTile(2);
            },
            leading: CustomRadioButton(
              value: 2,
              selected: selectedRadioTile,
              onChanged: (val) {
                setSelectedRadioTile(val!);
              },
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                'ข้อมูลของผู้ยื่นคำขอ', //!
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'ชื่อ - นามสกุล', //!
            required: true,
          ),
          CustomTextField(
            hintText: 'กรอกชื่อ - นามสกุล', //!
            controller: fullNameController,
            required: true,
            keyboardType: TextInputType.text,
            onChanged: _setFullNameController,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'ที่อยู่', //!
            required: true,
          ),
          CustomTextField(
            hintText: 'กรอกที่อยู่', //!
            controller: addressTextController,
            required: true,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            onChanged: _setAddressTextController,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'อีเมล', //!
            required: true,
          ),
          CustomTextField(
            hintText: 'กรอกอีเมล', //!
            controller: emailController,
            required: true,
            keyboardType: TextInputType.emailAddress,
            onChanged: _setEmailController,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
          const TitleRequiredText(
            text: 'เบอร์โทรติดต่อ', //!
            required: true,
          ),
          CustomTextField(
            hintText: 'กรอกเบอร์โทรติดต่อ', //!
            controller: phonenumberController,
            keyboardType: TextInputType.phone,
            required: true,
            maxLength: 10,
            onChanged: _setPhoneNumberController,
          ),
        ],
      ),
    );
  }
}
