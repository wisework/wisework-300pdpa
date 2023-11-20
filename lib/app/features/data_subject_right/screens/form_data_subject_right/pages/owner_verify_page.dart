import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/widgets/data_subject_right_list_tile.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_radio_button.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class OwnerVerifyPage extends StatefulWidget {
  const OwnerVerifyPage({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.dataSubjectRight,
  });

  final PageController controller;
  final int currentPage;
  final DataSubjectRightModel dataSubjectRight;

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
    dataSubjectRight = DataSubjectRightModel.empty();
    selectedRadioTile = 1;
    _initialData();
    super.initState();
  }

  void _initialData() {
    fullNameController = TextEditingController();
    addressTextController = TextEditingController();
    emailController = TextEditingController();
    phonenumberController = TextEditingController();
    // isDataOwner = widget.dataSubjectRight.isDataOwner;
    // isDataOwner == true ? selectedRadioTile = 1 : selectedRadioTile = 2;
    // if (widget.dataSubjectRight.dataRequester.isNotEmpty &&
    //     widget.dataSubjectRight.dataRequester
    //         .where(
    //           (element) =>
    //               element.title.first ==
    //               const LocalizedModel(
    //                 language: 'en-US',
    //                 text: 'Firstname - Lastname',
    //               ),
    //         )
    //         .isNotEmpty) {
    //   fullNameController = TextEditingController(
    //     text: widget.dataSubjectRight.dataRequester
    //         .where(
    //           (element) =>
    //               element.title.first ==
    //               const LocalizedModel(
    //                 language: 'en-US',
    //                 text: 'Firstname - Lastname',
    //               ),
    //         )
    //         .first
    //         .text,
    //   );
    // } else {
    //   fullNameController = TextEditingController();
    // }

    // if (widget.dataSubjectRight.dataRequester.isNotEmpty &&
    //     widget.dataSubjectRight.dataRequester
    //         .where(
    //           (element) =>
    //               element.title.first ==
    //               const LocalizedModel(
    //                 language: 'en-US',
    //                 text: 'Address',
    //               ),
    //         )
    //         .isNotEmpty) {
    //   addressTextController = TextEditingController(
    //     text: widget.dataSubjectRight.dataRequester
    //         .where(
    //           (element) =>
    //               element.title.first ==
    //               const LocalizedModel(
    //                 language: 'en-US',
    //                 text: 'Address',
    //               ),
    //         )
    //         .first
    //         .text,
    //   );
    // } else {
    //   addressTextController = TextEditingController();
    // }

    // if (widget.dataSubjectRight.dataRequester.isNotEmpty &&
    //     widget.dataSubjectRight.dataRequester
    //         .where(
    //           (element) =>
    //               element.title.first ==
    //               const LocalizedModel(
    //                 language: 'en-US',
    //                 text: 'Email',
    //               ),
    //         )
    //         .isNotEmpty) {
    //   emailController = TextEditingController(
    //     text: widget.dataSubjectRight.dataRequester
    //         .where(
    //           (element) =>
    //               element.title.first ==
    //               const LocalizedModel(
    //                 language: 'en-US',
    //                 text: 'Email',
    //               ),
    //         )
    //         .first
    //         .text,
    //   );
    // } else {
    //   emailController = TextEditingController();
    // }

    // if (widget.dataSubjectRight.dataRequester.isNotEmpty &&
    //     widget.dataSubjectRight.dataRequester
    //         .where(
    //           (element) =>
    //               element.title.first ==
    //               const LocalizedModel(
    //                 language: 'en-US',
    //                 text: 'Phone number',
    //               ),
    //         )
    //         .isNotEmpty) {
    //   phonenumberController = TextEditingController(
    //     text: widget.dataSubjectRight.dataRequester
    //         .where(
    //           (element) =>
    //               element.title.first ==
    //               const LocalizedModel(
    //                 language: 'en-US',
    //                 text: 'Phone number',
    //               ),
    //         )
    //         .first
    //         .text,
    //   );
    // } else {
    //   phonenumberController = TextEditingController();
    // }
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
          const SizedBox(height: UiConfig.lineSpacing),
          ContentWrapper(
            child: Container(
              padding: const EdgeInsets.all(
                UiConfig.defaultPaddingSpacing,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.outline,
                    blurRadius: 1.0,
                    offset: const Offset(0, -2.0),
                  ),
                ],
              ),
              child: _buildPageViewController(
                context,
                widget.controller,
                widget.currentPage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildPageViewController(
    BuildContext context,
    PageController controller,
    int currentpage,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Text("$currentpage/7"),
        TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            onPressed: nextPage,
            child: currentpage != 7
                ? Text(
                    tr("app.next"),
                  )
                : const Text("ส่งแบบคำร้อง")),
      ],
    );
  }

  void nextPage() {
    dataRequester.add(fullName);
    dataRequester.add(address);
    dataRequester.add(email);
    dataRequester.add(phonenumber);

    dataSubjectRight = dataSubjectRight.copyWith(
      isDataOwner: isDataOwner,
      dataRequester: dataRequester,
    );

    context
        .read<FormDataSubjectRightCubit>()
        .setDataSubjectRight(dataSubjectRight);

    // print(userConsent.isDataOwner);
    // print(userConsent.dataRequester);
    // print(dataSubjectRight.isDataOwner);
    // print(dataSubjectRight.dataRequester);

    if (selectedRadioTile == 1) {
      widget.controller.jumpToPage(
        4,
      );
      context.read<FormDataSubjectRightCubit>().nextPage(4);
    } else {
      widget.controller.animateToPage(widget.currentPage + 1,
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
      context
          .read<FormDataSubjectRightCubit>()
          .nextPage(widget.currentPage + 1);
    }
  }

  Form _buildStep1Form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tr('dataSubjectRight.dataRequester.areYouTheDs'),
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          DataSubjectRightListTile(
            title: tr('dataSubjectRight.dataRequester.applicantDs'), 
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
            title: tr('dataSubjectRight.dataRequester.ApplicantAds'), 
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
                tr('dataSubjectRight.dataRequester.ApplicantInformation'), 
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataRequester.namesurename'), 
            required: true,
          ),
          CustomTextField(
            hintText: tr('dataSubjectRight.dataRequester.hintnamesurename'), 
            controller: fullNameController,
            required: true,
            keyboardType: TextInputType.text,
            onChanged: _setFullNameController,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataRequester.address'), 
            required: true,
          ),
          CustomTextField(
            hintText: tr('dataSubjectRight.dataRequester.hintnameaddress'), 
            controller: addressTextController,
            required: true,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            onChanged: _setAddressTextController,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataRequester.email'), 
            required: true,
          ),
          CustomTextField(
            hintText: tr('dataSubjectRight.dataRequester.hintemail'), 
            controller: emailController,
            required: true,
            keyboardType: TextInputType.emailAddress,
            onChanged: _setEmailController,
          ),
          const SizedBox(height: UiConfig.lineSpacing),
           TitleRequiredText(
            text: tr('dataSubjectRight.dataRequester.telnumber'), 
            required: true,
          ),
          CustomTextField(
            hintText: tr('dataSubjectRight.dataRequester.hinttelnumber'), 
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
