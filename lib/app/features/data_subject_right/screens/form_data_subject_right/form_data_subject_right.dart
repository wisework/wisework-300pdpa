import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdpa/app/data/models/master_data/request_reason_template_model.dart';
import 'package:pdpa/app/features/data_subject_right/bloc/form_data_sub_ject_right/form_data_sub_ject_right_bloc.dart';
import 'package:pdpa/app/features/data_subject_right/cubit/form_data_subject_right/form_data_subject_right_cubit.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/acknowledge_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/data_owner_detail_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/identity_proofing_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/owner_verify_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/intro_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/power_of_attorney_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/request_reason_page.dart';
import 'package:pdpa/app/features/data_subject_right/screens/form_data_subject_right/pages/reserve_the_right_page.dart';
import 'package:pdpa/app/injection.dart';
import 'package:pdpa/app/shared/widgets/content_wrapper.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class FormDataSubjectRight extends StatefulWidget {
  const FormDataSubjectRight({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  State<FormDataSubjectRight> createState() => _FormDataSubjectRightState();
}

class _FormDataSubjectRightState extends State<FormDataSubjectRight> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<FormDataSubJectRightBloc>()
        ..add(
          GetFormDataSubJectRightEvent(companyId: widget.companyId),
        ),
      child: Scaffold(
        appBar: PdpaAppBar(
          leadingIcon: _buildPopButton(),
          title: const Text('แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย'), //!
        ),
        body: const FormDataSubjectRightView(
          requestResons: [],
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: () => context.pop(),
      icon: Icons.chevron_left_outlined,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }
}

class FormDataSubjectRightView extends StatefulWidget {
  const FormDataSubjectRightView({
    super.key,
    required this.requestResons,
  });

  final List<RequestReasonTemplateModel> requestResons;

  @override
  State<FormDataSubjectRightView> createState() =>
      _FormDataSubjectRightViewState();
}

class _FormDataSubjectRightViewState extends State<FormDataSubjectRightView> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();

    _initialData();
  }

  void _initialData() {
    final cubit = context.read<FormDataSubjectRightCubit>();
    _controller = PageController(
      initialPage: cubit.state.currentPage,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = context.select(
      (FormDataSubjectRightCubit cubit) => cubit.state.currentPage,
    );

    return Column(
      children: [
        Expanded(
          child: ContentWrapper(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              children: <Widget>[
                IntroPage(
                  controller: _controller,
                  currentPage: currentPage,
                ),
                OwnerVerifyPage(
                  controller: _controller,
                  currentPage: currentPage,
                ),
                PowerOfAttorneyPage(
                  controller: _controller,
                  currentPage: currentPage,
                ),
                DataOwnerDetailPage(
                  controller: _controller,
                  currentPage: currentPage,
                ),
                IdentityProofingPage(
                  controller: _controller,
                  currentPage: currentPage,
                  previousPage: currentPage,
                ),
                RequestReasonPage(
                  controller: _controller,
                  currentPage: currentPage,
                ),
                ReserveTheRightPage(
                  controller: _controller,
                  currentPage: currentPage,
                ),
                AcknowledgePage(
                  controller: _controller,
                  currentPage: currentPage,
                ),
              ],
            ),
          ),
        ),
        // Visibility(
        //   visible: currentPage != 0,
        //   child: ContentWrapper(
        //     child: Container(
        //       padding: const EdgeInsets.all(
        //         UiConfig.defaultPaddingSpacing,
        //       ),
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).colorScheme.onBackground,
        //         boxShadow: [
        //           BoxShadow(
        //             color: Theme.of(context).colorScheme.outline,
        //             blurRadius: 1.0,
        //             offset: const Offset(0, -2.0),
        //           ),
        //         ],
        //       ),
        //       child: _buildPageViewController(
        //         context,
        //         _controller,
        //         currentPage,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }

  // Row _buildPageViewController(
  //   BuildContext context,
  //   PageController controller,
  //   int currentpage,
  // ) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       TextButton(
  //         style: TextButton.styleFrom(
  //           textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                 color: Theme.of(context).colorScheme.primary,
  //               ),
  //         ),
  //         onPressed: previousPage,
  //         child: Text(
  //           tr("app.previous"),
  //         ),
  //       ),
  //       Text("$currentpage/7"),
  //       TextButton(
  //           style: TextButton.styleFrom(
  //             textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
  //                   color: Theme.of(context).colorScheme.primary,
  //                 ),
  //           ),
  //           onPressed: nextPage,
  //           child: currentpage != 7
  //               ? Text(
  //                   tr("app.next"),
  //                 )
  //               : const Text("ส่งแบบคำร้อง")),
  //     ],
  //   );
  // }

  // void nextPage() {
  //   context.read<FormDataSubjectRightCubit>().nextPage(_controller);
  // }

  // void previousPage() {
  //   context.read<FormDataSubjectRightCubit>().previousPage(_controller);
  // }
}
