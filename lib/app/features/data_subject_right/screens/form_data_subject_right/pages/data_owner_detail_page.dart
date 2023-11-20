import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/data/models/data_subject_right/data_subject_right_model.dart';
import 'package:pdpa/app/data/models/data_subject_right/requester_input_model.dart';
import 'package:pdpa/app/data/models/master_data/localized_model.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_container.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_text_field.dart';
import 'package:pdpa/app/shared/widgets/title_required_text.dart';

class DataOwnerDetailPage extends StatefulWidget {
  const DataOwnerDetailPage({
    super.key,
    required this.controller,
    required this.currentPage,
    required this.dataSubjectRight,
  });

  final PageController controller;
  final int currentPage;
  final DataSubjectRightModel dataSubjectRight;

  @override
  State<DataOwnerDetailPage> createState() => _DataOwnerDetailPageState();
}

class _DataOwnerDetailPageState extends State<DataOwnerDetailPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<RequesterInputModel> dataOwner = [];

  late TextEditingController fullNameController;
  late TextEditingController addressTextController;
  late TextEditingController emailController;
  late TextEditingController phonenumberController;

  RequesterInputModel fullName = RequesterInputModel.empty();
  RequesterInputModel address = RequesterInputModel.empty();
  RequesterInputModel email = RequesterInputModel.empty();
  RequesterInputModel phonenumber = RequesterInputModel.empty();

  @override
  void initState() {
    fullNameController = TextEditingController();
    addressTextController = TextEditingController();
    emailController = TextEditingController();
    phonenumberController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressTextController.dispose();
    emailController.dispose();
    phonenumberController.dispose();

    super.dispose();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: UiConfig.lineSpacing),
        Expanded(
          child: SingleChildScrollView(
            child: CustomContainer(
              padding: const EdgeInsets.all(UiConfig.defaultPaddingSpacing),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'รายละเอียดเจ้าของข้อมูล', //!
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
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
              ),
            ),
          ),
        ),
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
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          onPressed: previousPage,
          child: Text(
            tr("app.previous"),
          ),
        ),
        Text("$currentpage/7"),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          onPressed: nextPage,
          child: Text(
            tr("app.next"),
          ),
        ),
      ],
    );
  }

  void nextPage() {
    widget.controller.animateToPage(widget.currentPage + 1,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    context.read<FormDataSubjectRightCubit>().nextPage(widget.currentPage + 1);
  }

  void previousPage() {
    widget.controller.animateToPage(widget.currentPage - 1,
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    context.read<FormDataSubjectRightCubit>().nextPage(widget.currentPage - 1);
  }
}
